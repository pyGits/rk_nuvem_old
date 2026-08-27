import { Op } from "sequelize";

// Motor comum das rotas de lote do agente de sincronizacao.
//
// O agente antigo sobe um registro por requisicao HTTPS, o que custa um
// handshake TLS por linha e deixa o cupom inteiro demorando dezenas de
// segundos. As rotas de lote recebem o mesmo payload, so que em array, e
// resolvem tudo em duas idas ao banco: um SELECT para descobrir o que ja
// existe e um INSERT multi-values para o resto.
//
// Duas garantias sao obrigatorias aqui, porque o agente so marca NUVEM = 1
// do que a nuvem confirmar:
//   - a resposta diz, registro a registro, o que entrou e o que nao entrou;
//   - um registro problematico no meio do lote nao pode derrubar os demais.
// Por isso nao existe transacao unica envolvendo o lote todo: se o INSERT em
// bloco falhar, cai para insercao individual e o erro fica restrito a linha
// que o causou - exatamente o comportamento que o envio unitario ja tem.

export const LIMITE_REGISTROS_LOTE = 500;

export interface ResultadoLote {
  message: string;
  aceitos: number[];
  rejeitados: { indice: number; erro: string }[];
  // subconjunto de `aceitos` que entrou como registro novo. Rotas com efeito
  // colateral acumulativo (movimentacao somando saldo de estoque) precisam
  // distinguir insercao de reenvio para nao contar o mesmo movimento duas vezes.
  inseridos: number[];
}

export interface OpcoesLote {
  model: any;
  tenant_id: number;
  registros: any[];
  // chave de negocio do registro, sem o tenant_id (ele entra sozinho)
  chave: (registro: any) => Record<string, any>;
  // payload do agente convertido para as colunas do model
  mapear: (registro: any) => Record<string, any>;
}

// O findAll volta com os tipos do Postgres (loja como number, DATEONLY como
// string), enquanto o agente manda tudo como texto. Comparar pela forma
// textual normalizada evita que "1" e 1 sejam tratados como chaves distintas
// e o registro seja inserido duas vezes.
function assinatura(origem: any, campos: string[]): string {
  return campos
    .map((campo) => {
      const valor = origem?.[campo];
      return valor === null || valor === undefined ? "" : String(valor);
    })
    .join("");
}

function descreveErro(erro: any): string {
  if (!erro) return "Erro desconhecido";
  if (erro.errors?.length) return erro.errors.map((e: any) => e.message).join("; ");
  return erro.message ?? String(erro);
}

export function validaCorpoLote(registros: any): string | null {
  if (!Array.isArray(registros)) return "O corpo da requisicao precisa ser um array de registros";
  if (registros.length === 0) return "O lote esta vazio";
  if (registros.length > LIMITE_REGISTROS_LOTE)
    return `O lote excede o limite de ${LIMITE_REGISTROS_LOTE} registros`;
  return null;
}

export async function sincronizarLote(opcoes: OpcoesLote): Promise<ResultadoLote> {
  const { model, tenant_id, registros } = opcoes;

  const aceitos: number[] = [];
  const inseridos: number[] = [];
  const rejeitados: { indice: number; erro: string }[] = [];

  // A chave pode variar de registro para registro se o agente mandar campo
  // faltando; os campos vem do primeiro, que e o contrato da rota.
  const chaves = registros.map((registro) => opcoes.chave(registro));
  const camposChave = Object.keys(chaves[0]);

  const existentes: any[] = await model.findAll({
    where: { tenant_id, [Op.or]: chaves },
    raw: true,
  });

  const jaGravados = new Set(existentes.map((linha) => assinatura(linha, camposChave)));

  const inserir: { indice: number; valores: Record<string, any> }[] = [];
  const atualizar: { indice: number; valores: Record<string, any>; chave: Record<string, any> }[] = [];

  registros.forEach((registro, indice) => {
    try {
      const chave = chaves[indice];
      const valores = opcoes.mapear(registro);
      const marca = assinatura(chave, camposChave);

      if (jaGravados.has(marca)) {
        atualizar.push({ indice, valores, chave });
      } else {
        // marca aqui tambem: o mesmo lote pode trazer a chave repetida (reenvio
        // do agente), e sem isso o bulkCreate inseriria a linha duas vezes.
        jaGravados.add(marca);
        inserir.push({ indice, valores });
      }
    } catch (error) {
      rejeitados.push({ indice, erro: descreveErro(error) });
    }
  });

  if (inserir.length) {
    try {
      await model.bulkCreate(inserir.map((item) => item.valores));
      inserir.forEach((item) => {
        aceitos.push(item.indice);
        inseridos.push(item.indice);
      });
    } catch (error) {
      // Uma linha ruim invalida o INSERT em bloco inteiro. Refaz uma a uma
      // para que so ela seja recusada e o restante do lote suba.
      for (const item of inserir) {
        try {
          await model.create(item.valores);
          aceitos.push(item.indice);
          inseridos.push(item.indice);
        } catch (erroItem) {
          rejeitados.push({ indice: item.indice, erro: descreveErro(erroItem) });
        }
      }
    }
  }

  for (const item of atualizar) {
    try {
      await model.update(item.valores, { where: { tenant_id, ...item.chave } });
      aceitos.push(item.indice);
    } catch (error) {
      rejeitados.push({ indice: item.indice, erro: descreveErro(error) });
    }
  }

  aceitos.sort((a, b) => a - b);
  inseridos.sort((a, b) => a - b);
  rejeitados.sort((a, b) => a.indice - b.indice);

  return { message: "SINCRONIZADO", aceitos, rejeitados, inseridos };
}
