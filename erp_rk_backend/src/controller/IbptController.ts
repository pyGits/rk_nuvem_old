import multer, { Multer } from "multer";
import iconv from "iconv-lite";
import { Op, QueryTypes } from "sequelize";
import { Request, Response } from "express";
import db from "../database/config";
import Ibpt from "../models/Ibpt";
import IbptCarga from "../models/IbptCarga";
import IbptSugestaoIa from "../models/IbptSugestaoIa";
import GtinSefaz from "../models/GtinSefaz";
import SefazCertificado from "../models/SefazCertificado";
import SefazService from "../infra/service/sefaz/SefazService";
import { certificadoDisponivel, consultarGTIN, gtinConsultavel } from "../infra/service/sefaz/ConsultaGTIN";
import { escolherNCM, iaDisponivel, modeloConfigurado, PerguntaIA } from "../infra/service/IbptSugestaoIA";

// O arquivo do IBPT sai em ANSI (cp1252), nao em UTF-8. Ler como UTF-8 corrompe
// toda descricao acentuada - e sao milhares.
const ENCODING_ARQUIVO = "win1252";

const TAMANHO_MAXIMO = 20 * 1024 * 1024; // o arquivo de referencia tem ~2 MB
const LOTE_INSERCAO = 1000;
const LIMITE_BUSCA = 50;
const DIGITOS_NCM = 8;
const LIMITE_SUGESTAO = 10;
// Regex de 'nao-digito' para o Postgres. Em template literal do TS, uma barra
// so seria engolida (\D vira D), entao a fonte carrega duas.
const RX = "'\\D'";
// Sem inquilino escolhido a conferencia traz todos os clientes. O teto existe
// so como protecao contra uma base absurda: ele nunca deveria ser atingido, e
// quando for, a tela avisa e o filtro por inquilino resolve.
const LIMITE_CONFERENCIA = 5000;
// Produtos por chamada a IA. Lote grande economiza requisicao, mas resposta
// longa demais o modelo trunca - e ai a metade final volta sem escolha.
// O gargalo do plano gratuito e REQUISICAO POR MINUTO (20), nao o tamanho de
// cada uma. Lote pequeno multiplica requisicoes sem ganhar nada - e como a cota
// e contada em REQUISICOES (por dia no plano gratuito, por minuto no pago), o
// tamanho do lote e o que decide quantos produtos cabem nela: com 8 por lote
// sao 160 produtos, com 30 sao 600. O teto pratico e a resposta ficar longa a
// ponto de o modelo truncar - 30 respostas curtas estao longe disso.
const LOTE_IA = 30;

// Candidatos enviados por produto. Eram 10, quando a IA era obrigada a escolher
// entre eles; agora ela responde livre e eles sao so pista, entao 5 bastam - e
// com lote de 30 isso e a diferenca entre um prompt de 300 e de 150 linhas.
const CANDIDATOS_POR_PRODUTO = 5;
// Teto por execucao do botao, para nao estourar a cota do plano gratuito num
// clique so. O que sobrar fica para a proxima rodada.
const LIMITE_IA = 300;

// Pausa entre lotes, que so tem efeito em plano pago.
//
// ATENCAO ao "limit: 20" que aparece no erro: NAO e por minuto, e POR DIA. O
// quotaId confirma - GenerateRequestsPerDayPerProjectPerModel-FreeTier. No
// plano gratuito nenhuma pausa resolve: sao 20 requisicoes por dia por modelo,
// e o volume de um parque inteiro levaria semanas. Ativar o faturamento no
// projeto do Google e o unico caminho para rodar tudo de uma vez.
//
// Com faturamento ativo o teto volta a ser por minuto, e ai esta pausa segura o
// ritmo abaixo dele.
const PAUSA_ENTRE_LOTES_MS = 3200;

// NCM usado quando nada e encontrado. Decisao de negocio: e melhor um padrao
// conhecido do que deixar o produto sem NCM.
const NCM_PADRAO = "19059090";

// Embalagem, unidade e palavras genericas. As genericas sao o que mais
// atrapalha: "ANTIMOFO DIA A DIA" casava com "envelopes de primeiro DIA" e
// sugeria selo postal.
const RUIDO = new Set([
  "kg", "gr", "ml", "lt", "und", "uni", "pct", "cx", "fd", "sc", "dz", "mg", "cm", "mt",
  "pacote", "caixa", "unidade", "com", "para", "sem", "tipo", "dia", "casa", "lar",
  "novo", "nova", "linha", "super", "master", "premium", "special", "the", "and",
]);

// Monta os termos de busca a partir da descricao do produto.
//
// Tira acento de proposito: as descricoes do arquivo do IBPT sao todas sem
// acento ("Acucar", "Feijao"), entao normalizar os dois lados faz a busca casar
// sem depender da extensao unaccent no Postgres.
export function termosDaDescricao(texto: string): string[] {
  const palavras = String(texto || "")
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    // Numero e pontuacao viram separador: "REFRIG. 2L" nao ajuda a achar NCM.
    .replace(/[^a-z]+/g, " ")
    .split(" ")
    .filter((palavra) => palavra.length >= 3 && !RUIDO.has(palavra));

  // As primeiras palavras sao as que nomeiam o produto; o resto e marca e
  // embalagem, que nunca aparecem no IBPT.
  return Array.from(new Set(palavras)).slice(0, 6);
}

// Em memoria: o arquivo e pequeno, e processado numa unica requisicao e nao
// precisa sobreviver a ela - o que vale e a tabela, nao o CSV.
const storage: Multer = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: TAMANHO_MAXIMO },
  fileFilter: (req, file, cb) => {
    if (file.originalname.toLowerCase().endsWith(".csv")) {
      cb(null, true);
    } else {
      cb(new Error("Formato inválido. Envie o arquivo .csv do IBPT."));
    }
  },
});

// Upload do certificado A1. Limite pequeno de proposito: um .pfx real tem
// poucos KB, e aceitar arquivo grande aqui so abriria espaco para engano.
const TAMANHO_CERTIFICADO = 512 * 1024;

const storageCertificado: Multer = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: TAMANHO_CERTIFICADO },
  fileFilter: (req, file, cb) => {
    const nome = file.originalname.toLowerCase();
    if (nome.endsWith(".pfx") || nome.endsWith(".p12")) {
      cb(null, true);
    } else {
      cb(new Error("Formato inválido. Envie o certificado A1 (.pfx ou .p12)."));
    }
  },
});

const COLUNAS = ["codigo", "ex", "tipo", "descricao", "nacionalfederal", "importadosfederal", "estadual", "municipal", "vigenciainicio", "vigenciafim", "chave", "versao", "fonte"];

type LinhaIbpt = {
  codigo: string;
  ex: string;
  tipo: number;
  descricao: string;
  nacional_federal: number;
  importado_federal: number;
  estadual: number;
  municipal: number;
  vigencia_inicio: string | null;
  vigencia_fim: string | null;
  chave: string;
  versao: string;
  fonte: string;
};

// Separador ';' com descricao entre aspas, que pode conter ';' dentro.
function separarCampos(linha: string): string[] {
  const campos: string[] = [];
  let atual = "";
  let dentroDeAspas = false;

  for (const caractere of linha) {
    if (caractere === '"') {
      dentroDeAspas = !dentroDeAspas;
      continue;
    }
    if (caractere === ";" && !dentroDeAspas) {
      campos.push(atual);
      atual = "";
      continue;
    }
    atual += caractere;
  }
  campos.push(atual);

  return campos.map((campo) => campo.trim());
}

// O arquivo traz dd/mm/aaaa; o Postgres quer aaaa-mm-dd.
function data(valor: string): string | null {
  const partes = String(valor || "").split("/");
  if (partes.length !== 3) return null;

  const [dia, mes, ano] = partes;
  return `${ano}-${mes.padStart(2, "0")}-${dia.padStart(2, "0")}`;
}

function numero(valor: string): number {
  const convertido = Number(String(valor || "").replace(",", "."));
  return Number.isFinite(convertido) ? convertido : 0;
}

// Alem do NCM, o arquivo do IBPT tras NBS (9 digitos, servicos) e LC116 (4
// digitos, servicos municipais). Esta tabela e catalogo de NCM de PRODUTO,
// entao so entra o que tem 8 digitos - descartado na leitura, e nao filtrado
// depois: a garantia fica num lugar so.
export function converterCSV(conteudo: string): { registros: LinhaIbpt[]; ignorados: number } {
  const linhas = conteudo.split(/\r?\n/).filter((linha) => linha.trim() !== "");
  if (linhas.length === 0) throw new Error("Arquivo vazio !");

  const cabecalho = separarCampos(linhas[0]).map((coluna) => coluna.toLowerCase());
  const faltando = COLUNAS.filter((coluna) => !cabecalho.includes(coluna));
  if (faltando.length > 0) {
    throw new Error(`Arquivo não parece ser a tabela do IBPT. Faltam as colunas: ${faltando.join(", ")}`);
  }

  const indice = (coluna: string) => cabecalho.indexOf(coluna);
  const registros: LinhaIbpt[] = [];
  let ignorados = 0;
  // O mesmo (codigo, ex) repetido no arquivo violaria a unique da tabela e
  // derrubaria a carga inteira no meio; fica a ultima ocorrencia.
  const vistos = new Map<string, number>();

  for (let i = 1; i < linhas.length; i++) {
    const campos = separarCampos(linhas[i]);
    const codigo = String(campos[indice("codigo")] || "").replace(/\D/g, "");
    if (!codigo) continue;

    if (codigo.length !== DIGITOS_NCM) {
      ignorados++;
      continue;
    }

    const registro: LinhaIbpt = {
      codigo,
      ex: campos[indice("ex")] || "",
      tipo: Math.trunc(numero(campos[indice("tipo")])),
      descricao: campos[indice("descricao")] || "",
      nacional_federal: numero(campos[indice("nacionalfederal")]),
      importado_federal: numero(campos[indice("importadosfederal")]),
      estadual: numero(campos[indice("estadual")]),
      municipal: numero(campos[indice("municipal")]),
      vigencia_inicio: data(campos[indice("vigenciainicio")]),
      vigencia_fim: data(campos[indice("vigenciafim")]),
      chave: campos[indice("chave")] || "",
      versao: campos[indice("versao")] || "",
      fonte: campos[indice("fonte")] || "",
    };

    const chave = `${registro.codigo}|${registro.ex}`;
    if (vistos.has(chave)) {
      registros[vistos.get(chave)] = registro;
    } else {
      vistos.set(chave, registros.length);
      registros.push(registro);
    }
  }

  if (registros.length === 0) throw new Error("Nenhum NCM encontrado no arquivo !");

  return { registros, ignorados };
}

// Estado do mutirao da IA. Vive na memoria do processo de proposito: o que
// importa preservar - a resposta de cada descricao - ja vai para a tabela a
// cada lote. Se o backend reiniciar no meio, basta iniciar de novo: as
// descricoes ja respondidas sao puladas e ele continua de onde parou.
const mutirao = {
  rodando: false,
  parar: false,
  total: 0,
  processados: 0,
  comSugestao: 0,
  tentativas: 0,
  ultimoErro: "",
  cotaDiaria: false,
  iniciadoEm: null as Date | null,
  terminadoEm: null as Date | null,
};

// Espera em fatias, conferindo o pedido de parada entre elas. Dormir os 41
// segundos que o Google pede de uma vez so deixava o botao Parar sem efeito por
// todo esse tempo - parecia travado.
async function esperar(ms: number): Promise<void> {
  const FATIA = 500;

  for (let restante = ms; restante > 0 && !mutirao.parar; restante -= FATIA) {
    await new Promise((resolve) => setTimeout(resolve, Math.min(FATIA, restante)));
  }
}

// Descricoes que ainda precisam de resposta: produto com NCM irregular e sem
// nada gravado no cache. Sai do banco, nao do navegador - o mutirao roda com a
// tela fechada.
async function descricoesPendentes(): Promise<string[]> {
  const linhas: any[] = await db.query(
    `with produto_ncm as (
       select p.descricao,
              nullif(regexp_replace(coalesce(p.ncm, ''), ${RX}, '', 'g'), '') as ncm_limpo
         from produtos p
        where coalesce(p.ativo, 'S') = 'S' and coalesce(p.descricao, '') <> ''
     )
     select distinct p.descricao
       from produto_ncm p
      where (p.ncm_limpo is null
             or length(p.ncm_limpo) <> ${DIGITOS_NCM}
             or not exists (select 1 from ibpt i where i.codigo = p.ncm_limpo))
        and not exists (select 1 from ibpt_sugestao_ia s where s.descricao = p.descricao)
      order by p.descricao`,
    { type: QueryTypes.SELECT }
  );

  return linhas.map((linha: any) => linha.descricao);
}

// Roda ate acabar. Erro temporario nao interrompe: espera e tenta o mesmo lote
// de novo, quantas vezes precisar - e para isso que o mutirao existe.
async function rodarMutirao(): Promise<void> {
  try {
    const pendentes = await descricoesPendentes();

    mutirao.total = pendentes.length;
    mutirao.processados = 0;
    mutirao.comSugestao = 0;

    for (let i = 0; i < pendentes.length && !mutirao.parar; ) {
      const lote = pendentes.slice(i, i + LOTE_IA);

      const perguntas: PerguntaIA[] = [];
      for (const descricao of lote) {
        if (mutirao.parar) break;
        perguntas.push({ descricao, candidatos: await candidatosPara(descricao) });
      }

      if (mutirao.parar) break;

      try {
        const respostas = await escolherNCM(perguntas);

        for (const resposta of respostas) {
          const registro: any = resposta.ncm ? await Ibpt.findOne({ where: { codigo: resposta.ncm } }) : null;
          if (registro) mutirao.comSugestao++;

          await IbptSugestaoIa.upsert({
            descricao: resposta.descricao,
            ncm: registro ? registro.codigo : null,
            ncm_descricao: registro ? registro.descricao : null,
            modelo: modeloConfigurado(),
          } as any);
        }

        mutirao.processados += lote.length;
        mutirao.ultimoErro = "";
        mutirao.tentativas = 0;
        i += LOTE_IA;

        await esperar(PAUSA_ENTRE_LOTES_MS);
      } catch (erro: any) {
        // NAO avanca o indice: o mesmo lote sera tentado de novo.
        mutirao.tentativas++;
        mutirao.ultimoErro = erro?.message || "falha ao consultar";

        // O tempo que o Google pediu vem junto do erro. Respeitar exatamente
        // ele e melhor que escalonar por conta: menos volta a falhar, mais
        // desperdica a janela. Um segundo de folga para a contagem virar.
        // Cota diaria nao adianta esperar: o Google pede ~49s tambem nesse
        // caso, e obedecer isso deixa o mutirao repetindo ate a virada do dia
        // sem gravar nada. Para e diz quantos ficaram - o que ja foi respondido
        // esta na tabela, entao amanha ele continua daqui.
        if (erro?.cotaDiariaEsgotada) {
          mutirao.cotaDiaria = true;
          break;
        }

        const pedido = Number(erro?.retryEmSegundos || 0);

        await esperar(pedido > 0 ? (pedido + 1) * 1000 : Math.min(15000 * mutirao.tentativas, 120000));
      }
    }
  } catch (erro: any) {
    mutirao.ultimoErro = erro?.message || "falha inesperada";
  } finally {
    mutirao.rodando = false;
    mutirao.parar = false;
    mutirao.terminadoEm = new Date();
  }
}


// ---------- Normalizacao em massa ----------
//
// Antes isto era uma requisicao so, com a lista inteira no corpo e um loop que
// fazia DUAS queries por produto (um count no IBPT + o update) dentro de uma
// unica transacao. Com 5.000 itens eram 10.000 queries numa requisicao: batia
// timeout, a transacao voltava atras e NADA era gravado - parecia que o botao
// nao funcionava.
//
// E, pior, "todos" nunca era todos: a tela carrega no maximo LIMITE_CONFERENCIA
// produtos, entao o que ia no corpo era o pedaco visivel, nao a base.
//
// Agora o servidor monta o alvo por conta propria, sobre a base INTEIRA, e
// aplica em blocos com progresso - a tela pode ser fechada.

const LOTE_NORMALIZACAO = 500;

export type OrigemNcm = "sefaz" | "tabela" | "ia";

const normalizacao = {
  rodando: false,
  parar: false,
  origem: "" as string,
  total: 0,
  processados: 0,
  alterados: 0,
  ultimoErro: "",
  iniciadoEm: null as Date | null,
  terminadoEm: null as Date | null,
};

// Produtos com NCM irregular, com os mesmos filtros da conferencia.
function sqlIrregular(onde: string): string {
  return `with produto_ncm as (
     select p.tenant_id, p.codigo, p.codigo_barras, p.descricao, p.ncm,
            nullif(regexp_replace(coalesce(p.ncm, ''), ${RX}, '', 'g'), '') as ncm_limpo
       from produtos p
      where 1 = 1 ${onde}
   ),
   irregular as (
     select * from produto_ncm p
      where p.ncm_limpo is null
         or length(p.ncm_limpo) <> ${DIGITOS_NCM}
         or not exists (select 1 from ibpt i where i.codigo = p.ncm_limpo)
   )`;
}

// Alvos por origem: (tenant_id, codigo, codigo_barras, ncm_novo).
//
// Todas as origens conferem o NCM contra a tabela do IBPT antes de entregar -
// e a mesma garantia do caminho manual, e sem ela a normalizacao poderia
// gravar um codigo que a conferencia do dia seguinte acusaria de novo.
function sqlAlvos(origem: OrigemNcm, onde: string): string {
  const base = sqlIrregular(onde);

  if (origem === "sefaz") {
    return `${base}
     select r.tenant_id, r.codigo, r.codigo_barras, g.ncm as ncm_novo
       from irregular r
       join gtin_sefaz g
         on g.gtin = nullif(regexp_replace(coalesce(r.codigo_barras, ''), ${RX}, '', 'g'), '')
      where g.ncm is not null
        and exists (select 1 from ibpt i where i.codigo = g.ncm)`;
  }

  if (origem === "ia") {
    return `${base}
     select r.tenant_id, r.codigo, r.codigo_barras, s.ncm as ncm_novo
       from irregular r
       join ibpt_sugestao_ia s on s.descricao = r.descricao
      where s.ncm is not null
        and exists (select 1 from ibpt i where i.codigo = s.ncm)`;
  }

  // Hierarquia da propria tabela. Mesma logica de anexarSugestaoPrefixo - ver
  // o comentario de la para o porque de cada criterio de ordenacao. O ambiguo
  // fica DE FORA: em massa, uma leitura duvidosa vira erro em escala.
  return `${base},
   distintos as (
     select distinct left(regexp_replace(coalesce(r.ncm, ''), ${RX}, '', 'g'), ${DIGITOS_NCM}) as d
       from irregular r
   ),
   norm as (
     select d, lpad(d, ${DIGITOS_NCM}, '0') as pad from distintos where d <> ''
   ),
   cand as (
     select n.d, g.i as dropados, p.prefixo, length(p.prefixo) as tam
       from norm n
       cross join generate_series(0, ${DIGITOS_NCM - 1}) as g(i)
       cross join lateral (
         select * from (values
           (left(substr(n.pad, g.i + 1), 6)),
           (left(substr(n.pad, g.i + 1), 4))
         ) as t(prefixo)
       ) p
      where (g.i = 0 or left(n.pad, g.i) ~ '^0+$')
        and length(p.prefixo) >= 4
   ),
   casou as (
     select c.d, c.dropados, c.prefixo, c.tam, i.codigo, left(i.codigo, 2) as capitulo
       from cand c
       join ibpt i on i.codigo like c.prefixo || '%'
      where i.codigo !~ '^0+$'
   ),
   escolha as (
     select distinct on (x.d) x.d, x.codigo, x.tam, x.capitulo
       from casou x
      order by x.d, x.tam desc, x.dropados, x.codigo desc
   ),
   confiavel as (
     select e.d, e.codigo
       from escolha e
      where not exists (
        select 1 from casou c
         where c.d = e.d and c.capitulo <> e.capitulo and c.tam >= e.tam - 1
      )
   )
   select r.tenant_id, r.codigo, r.codigo_barras, f.codigo as ncm_novo
     from irregular r
     join confiavel f
       on f.d = left(regexp_replace(coalesce(r.ncm, ''), ${RX}, '', 'g'), ${DIGITOS_NCM})`;
}

function filtrosConferencia(query: any): { onde: string; parametros: any } {
  const filtros: string[] = [];
  const parametros: any = {};

  if (query.tenant_id) {
    filtros.push("p.tenant_id = :tenant_id");
    parametros.tenant_id = Number(query.tenant_id);
  }
  if (String(query.incluirInativos || "0") !== "1") {
    filtros.push("coalesce(p.ativo, 'S') = 'S'");
  }

  return { onde: filtros.length > 0 ? `and ${filtros.join(" and ")}` : "", parametros };
}

// Quantos produtos cada origem resolveria na base inteira - nao so no pedaco
// carregado. E o numero que os botoes de "todos" precisam mostrar.
async function contarAlvos(query: any): Promise<{ sefaz: number; tabela: number; ia: number }> {
  const { onde, parametros } = filtrosConferencia(query);

  const contar = async (origem: OrigemNcm): Promise<number> => {
    const linhas: any[] = await db.query(`select count(*) as total from (${sqlAlvos(origem, onde)}) alvo`, {
      replacements: parametros,
      type: QueryTypes.SELECT,
    });
    return Number(linhas[0]?.total || 0);
  };

  return { sefaz: await contar("sefaz"), tabela: await contar("tabela"), ia: await contar("ia") };
}

async function rodarNormalizacao(origem: OrigemNcm, query: any): Promise<void> {
  try {
    const { onde, parametros } = filtrosConferencia(query);

    const alvos: any[] = await db.query(sqlAlvos(origem, onde), { replacements: parametros, type: QueryTypes.SELECT });

    normalizacao.total = alvos.length;
    normalizacao.processados = 0;
    normalizacao.alterados = 0;

    for (let i = 0; i < alvos.length && !normalizacao.parar; i += LOTE_NORMALIZACAO) {
      const lote = alvos.slice(i, i + LOTE_NORMALIZACAO);

      // Um UPDATE por lote, nao um por produto. Os arrays vao por bind: com
      // replacements o Sequelize expandiria como lista de virgulas e quebraria
      // o ::text[].
      const [, afetados] = await db.query(
        `update produtos p
            set ncm = v.ncm, updated_at = now()
           from (select unnest($1::int[]) as tenant_id,
                        unnest($2::text[]) as codigo,
                        unnest($3::text[]) as codigo_barras,
                        unnest($4::text[]) as ncm) v
          where p.tenant_id = v.tenant_id
            and p.codigo = v.codigo
            -- codigo_barras pode ser nulo, e "= null" nunca casa.
            and p.codigo_barras is not distinct from nullif(v.codigo_barras, '')`,
        {
          bind: [
            lote.map((a: any) => Number(a.tenant_id)),
            lote.map((a: any) => String(a.codigo)),
            lote.map((a: any) => (a.codigo_barras === null ? "" : String(a.codigo_barras))),
            lote.map((a: any) => String(a.ncm_novo)),
          ],
          type: QueryTypes.UPDATE,
        }
      );

      normalizacao.alterados += Number(afetados || 0);
      normalizacao.processados += lote.length;
    }
  } catch (erro: any) {
    normalizacao.ultimoErro = erro?.message || "falha ao normalizar";
  } finally {
    normalizacao.rodando = false;
    normalizacao.parar = false;
    normalizacao.terminadoEm = new Date();
  }
}

// ---------- Mutirao da SEFAZ (consulta por codigo de barras) ----------

// Pausa entre consultas. A SEFAZ recusa por "consumo indevido" (cStat 656) quem
// consulta rapido demais, e o bloqueio vale por cerca de uma hora PARA O CNPJ do
// certificado - que aqui e de um cliente real. A pausa protege esse cliente.
const PAUSA_SEFAZ_MS = Number(process.env.SEFAZ_GTIN_PAUSA_MS || 500);

const mutiraoSefaz = {
  rodando: false,
  parar: false,
  total: 0,
  processados: 0,
  comNcm: 0,
  ultimoErro: "",
  bloqueado: false,
  iniciadoEm: null as Date | null,
  terminadoEm: null as Date | null,
};

async function esperarSefaz(ms: number): Promise<void> {
  const FATIA = 500;

  for (let restante = ms; restante > 0 && !mutiraoSefaz.parar; restante -= FATIA) {
    await new Promise((resolve) => setTimeout(resolve, Math.min(FATIA, restante)));
  }
}

// GTIN que vale consultar: de produto com NCM irregular, da GS1 Brasil
// (789/790, o unico atendido pelo CCG) e ainda sem nada no cache - inclusive
// sem resposta negativa, senao o mutirao repetiria sempre os que nunca voltam.
async function gtinsPendentes(): Promise<string[]> {
  const linhas: any[] = await db.query(
    `with produto_gtin as (
       select nullif(regexp_replace(coalesce(p.codigo_barras, ''), ${RX}, '', 'g'), '') as gtin,
              nullif(regexp_replace(coalesce(p.ncm, ''), ${RX}, '', 'g'), '') as ncm_limpo
         from produtos p
        where coalesce(p.ativo, 'S') = 'S'
     )
     select distinct g.gtin
       from produto_gtin g
      where (g.ncm_limpo is null
             or length(g.ncm_limpo) <> ${DIGITOS_NCM}
             or not exists (select 1 from ibpt i where i.codigo = g.ncm_limpo))
        and g.gtin is not null
        and length(g.gtin) in (8, 12, 13, 14)
        and (lpad(g.gtin, 13, '0') like '789%' or lpad(g.gtin, 13, '0') like '790%')
        and not exists (select 1 from gtin_sefaz s where s.gtin = g.gtin)
      order by g.gtin`,
    { type: QueryTypes.SELECT }
  );

  return linhas.map((linha: any) => linha.gtin);
}

async function rodarMutiraoSefaz(): Promise<void> {
  try {
    const loja = await certificadoDisponivel();
    if (!loja) throw new Error("Nenhuma loja com certificado digital valido cadastrado.");

    const pendentes = await gtinsPendentes();

    mutiraoSefaz.total = pendentes.length;
    mutiraoSefaz.processados = 0;
    mutiraoSefaz.comNcm = 0;

    for (const gtin of pendentes) {
      if (mutiraoSefaz.parar) break;

      try {
        const resposta = await consultarGTIN(gtin, loja);

        if (resposta.bloqueado) {
          mutiraoSefaz.bloqueado = true;
          mutiraoSefaz.ultimoErro =
            `A SEFAZ bloqueou temporariamente as consultas por consumo indevido (${resposta.xMotivo}). ` +
            `O bloqueio dura cerca de uma hora. O que ja foi consultado esta gravado - ao recomecar, ` +
            `ele continua de onde parou.`;
          break;
        }

        // Grava tambem a resposta negativa: "a SEFAZ nao tem este GTIN" e
        // definitivo o bastante para nao perguntar de novo toda rodada.
        await GtinSefaz.upsert({
          gtin,
          ncm: resposta.ncm,
          cest: resposta.cest,
          xprod: resposta.xProd,
          cstat: resposta.cStat,
          xmotivo: resposta.xMotivo,
        } as any);

        if (resposta.ncm) mutiraoSefaz.comNcm++;
        mutiraoSefaz.ultimoErro = "";
      } catch (erro: any) {
        // Falha num GTIN nao derruba o mutirao: fica sem cache e volta na
        // proxima rodada. Parar tudo por causa de um seria pior.
        mutiraoSefaz.ultimoErro = erro?.message || "falha ao consultar a SEFAZ";
      }

      mutiraoSefaz.processados++;
      await esperarSefaz(PAUSA_SEFAZ_MS);
    }
  } catch (erro: any) {
    mutiraoSefaz.ultimoErro = erro?.message || "falha inesperada";
  } finally {
    mutiraoSefaz.rodando = false;
    mutiraoSefaz.parar = false;
    mutiraoSefaz.terminadoEm = new Date();
  }
}

export default {
  // ---------- Painel administrativo ----------

  publicar: [
    storage.single("arquivo"),
    async (req: Request, res: Response) => {
      try {
        const arquivo = (req as any).file;
        if (!arquivo) return res.status(400).json({ message: "Envie o arquivo .csv do IBPT." });

        const { registros, ignorados } = converterCSV(iconv.decode(arquivo.buffer, ENCODING_ARQUIVO));

        // Substituicao atomica: enquanto a carga roda, a consulta de NCM
        // continua vendo a tabela anterior inteira. Sem transacao, um erro no
        // meio deixaria o sistema sem NCM nenhum.
        await db.transaction(async (transaction) => {
          await Ibpt.destroy({ where: {}, transaction });

          for (let i = 0; i < registros.length; i += LOTE_INSERCAO) {
            await Ibpt.bulkCreate(registros.slice(i, i + LOTE_INSERCAO) as any, { transaction });
          }

          await IbptCarga.create(
            {
              arquivo_original: arquivo.originalname,
              versao: registros[0].versao,
              vigencia_inicio: registros[0].vigencia_inicio,
              vigencia_fim: registros[0].vigencia_fim,
              registros: registros.length,
            } as any,
            { transaction }
          );
        });

        res.status(201).json({
          message: "Tabela IBPT atualizada com sucesso !",
          registros: registros.length,
          // Codigos de servico do arquivo, que nao sao NCM de produto.
          ignorados,
          versao: registros[0].versao,
        });
      } catch (error: any) {
        res.status(400).json({ message: error.message || "Erro ao processar o arquivo do IBPT." });
      }
    },
  ],

  async situacao(req: Request, res: Response) {
    const carga: any = await IbptCarga.findOne({ order: [["created_at", "DESC"]] });
    const total = await Ibpt.count();

    res.status(200).json({
      // null = nunca foi carregado; o painel mostra o aviso em vez da versao.
      carga: carga
        ? {
            arquivo: carga.arquivo_original,
            versao: carga.versao,
            vigenciaInicio: carga.vigencia_inicio,
            vigenciaFim: carga.vigencia_fim,
            registros: carga.registros,
            carregadoEm: carga.created_at,
          }
        : null,
      total,
    });
  },

  // Produtos de todos os clientes cujo NCM nao existe na tabela IBPT carregada.
  //
  // Nao e so "nao achou": NCM em branco e NCM com menos de 8 digitos entram
  // tambem, porque na pratica sao o mesmo problema - produto que vai sair na
  // nota com NCM que a SEFAZ nao reconhece.
  //
  // Cuidado deliberado com o NCM em branco: normalizado ele viraria '00000000',
  // que EXISTE no arquivo do IBPT ("PRODUTO NAO ESPECIFICADO NA LISTA DE NCM"),
  // e o produto sem NCM passaria despercebido justamente na auditoria feita
  // para encontra-lo.
  async produtosSemNcm(req: Request, res: Response) {
    const total = await Ibpt.count();
    if (total === 0) {
      return res.status(200).json({
        // Sem tabela carregada todo produto apareceria como irregular, o que
        // seria uma lista falsa de 100% dos produtos.
        message: "Carregue a tabela do IBPT antes de conferir os NCM.",
        tabelaCarregada: false,
        produtos: [],
        totais: { produtos: 0, clientes: 0 },
      });
    }

    const filtros: string[] = [];
    const parametros: any = {};

    if (req.query.tenant_id) {
      filtros.push("p.tenant_id = :tenant_id");
      parametros.tenant_id = Number(req.query.tenant_id);
    }
    // Por padrao so produto ativo: produto desativado com NCM errado nao sai
    // em nota e so faria ruido na lista.
    if (String(req.query.incluirInativos || "0") !== "1") {
      filtros.push("coalesce(p.ativo, 'S') = 'S'");
    }

    const onde = filtros.length > 0 ? `and ${filtros.join(" and ")}` : "";

    const produtos = await db.query(
      `with produto_ncm as (
         select p.tenant_id, p.codigo, p.codigo_barras, p.descricao, p.ncm,
                nullif(regexp_replace(coalesce(p.ncm, ''), '\\D', '', 'g'), '') as ncm_limpo
           from produtos p
          where 1 = 1 ${onde}
       )
       select p.tenant_id, t.name as cliente, t.cnpjcpf,
              p.codigo, p.codigo_barras, p.descricao, p.ncm,
              case
                when p.ncm_limpo is null then 'NCM em branco'
                when length(p.ncm_limpo) <> 8 then 'NCM com ' || length(p.ncm_limpo) || ' digito(s)'
                else 'NCM nao existe na tabela IBPT'
              end as motivo
         from produto_ncm p
         left join tenants t on t.id = p.tenant_id
        where p.ncm_limpo is null
           or length(p.ncm_limpo) <> 8
           or not exists (select 1 from ibpt i where i.codigo = p.ncm_limpo )
        order by t.name nulls last, p.descricao
        limit ${LIMITE_CONFERENCIA + 1}`,
      { replacements: parametros, type: QueryTypes.SELECT }
    );

    const truncado = produtos.length > LIMITE_CONFERENCIA;
    const lista = truncado ? produtos.slice(0, LIMITE_CONFERENCIA) : produtos;

    // Só a sugestão da IA: a busca por texto acertava pouco (para "ANEL DE
    // OURO" oferecia po de ouro) e virava ruído ao lado de uma resposta boa.
    await anexarSugestoesIA(lista as any[]);
    await anexarSefaz(lista as any[]);
    await anexarSugestaoPrefixo(lista as any[]);

    // Totais da BASE INTEIRA, nao do pedaco carregado: e o numero que os
    // botoes de "aplicar em todos" precisam mostrar, senao prometem menos do
    // que fazem.
    const totaisGerais = await contarAlvos(req.query);

    res.status(200).json({
      tabelaCarregada: true,
      produtos: lista,
      totaisGerais,
      // O front avisa que ha mais: normalizar "todos" so pode valer para o que
      // esta na tela, senao alteraria em massa o que ninguem viu.
      truncado,
      limite: LIMITE_CONFERENCIA,
      totais: {
        produtos: lista.length,
        clientes: new Set(lista.map((linha: any) => linha.tenant_id)).size,
      },
    });
  },

  // Grava o NCM escolhido nos produtos indicados. Recebe a lista explicita, e
  // nao um "faz tudo": alteracao em massa de dado fiscal de cliente precisa
  // passar pelo que o operador viu na tela.
  async normalizar(req: Request, res: Response) {
    const itens = Array.isArray(req.body?.produtos) ? req.body.produtos : [];
    if (itens.length === 0) throw new Error("Nenhum produto informado !");

    let alterados = 0;
    const rejeitados: { codigo: string; erro: string }[] = [];

    // Uma consulta ao IBPT para a lista toda, em vez de um count por produto.
    // Era o gargalo: com centenas de itens selecionados, o count por item
    // dominava o tempo da requisicao.
    const pedidos = Array.from(
      new Set(itens.map((item: any) => String(item.ncm || "").replace(/[^0-9]/g, "")).filter((n: string) => n.length === DIGITOS_NCM))
    );
    const encontrados: any[] = pedidos.length > 0 ? await Ibpt.findAll({ where: { codigo: pedidos }, attributes: ["codigo"] }) : [];
    const validos = new Set(encontrados.map((linha: any) => linha.codigo));

    await db.transaction(async (transaction) => {
      for (const item of itens) {
        const ncm = String(item.ncm || "").replace(/[^0-9]/g, "");

        if (ncm.length !== DIGITOS_NCM) {
          rejeitados.push({ codigo: item.codigo, erro: "NCM deve ter 8 dígitos" });
          continue;
        }

        // Confere na tabela: sem isto a normalizacao poderia gravar um NCM que
        // a propria conferencia acusaria como irregular no dia seguinte.
        if (!validos.has(ncm)) {
          rejeitados.push({ codigo: item.codigo, erro: "NCM não existe na tabela IBPT" });
          continue;
        }

        const resultado: any = await db.query(
          "update produtos set ncm = :ncm, updated_at = now() where tenant_id = :tenant_id and codigo = :codigo and codigo_barras = :codigo_barras",
          { replacements: { ncm, tenant_id: Number(item.tenant_id), codigo: item.codigo, codigo_barras: item.codigo_barras }, type: QueryTypes.UPDATE, transaction }
        );

        // QueryTypes.UPDATE no Postgres devolve [linhas, rowCount] - e num
        // UPDATE `linhas` vem VAZIO. Ler o primeiro elemento dava
        // Number([]) === 0, entao a tela sempre relatava "0 produto(s)
        // atualizado(s)" mesmo tendo gravado tudo. O contador esta no segundo.
        alterados += Array.isArray(resultado) ? Number(resultado[1] || 0) : 0;
      }
    });

    res.status(200).json({ alterados, rejeitados });
  },

  // Corrige o zero a esquerda perdido. E deterministico: o NCM tem 8 digitos
  // por definicao, entao "4039000" so pode ser "04039000". Nao ha palpite, e por
  // isso esta funcao roda sobre TODOS os produtos, sem o teto da conferencia.
  //
  // O PDV guarda o NCM em campo numerico, o que come o zero da frente. E o caso
  // mais comum da conferencia - iogurte (04039000) e frango (02071411) inteiros
  // aparecem como irregulares so por isso.
  async zeroAEsquerda(req: Request, res: Response) {
    const tenant = req.query.tenant_id || req.body?.tenant_id;

    const filtroTenant = tenant ? " and tenant_id = :tenant_id" : "";
    const parametros: any = tenant ? { tenant_id: Number(tenant) } : {};

    const alvo = `length(regexp_replace(coalesce(ncm, ''), ${RX}, '', 'g')) between 1 and ${DIGITOS_NCM - 1}`;

    // GET so conta, para o botao dizer quantos serao alterados antes do clique.
    if (req.method === "GET") {
      const linha: any = await db.query(`select count(*) as total from produtos where ${alvo}${filtroTenant}`, { replacements: parametros, type: QueryTypes.SELECT, plain: true });

      return res.status(200).json({ total: Number(linha?.total || 0) });
    }

    const [, alterados] = await db.query(
      `update produtos
          set ncm = lpad(regexp_replace(coalesce(ncm, ''), ${RX}, '', 'g'), ${DIGITOS_NCM}, '0'),
              updated_at = now()
        where ${alvo}${filtroTenant}`,
      { replacements: parametros, type: QueryTypes.UPDATE }
    );

    res.status(200).json({ alterados: Number(alterados || 0) });
  },

  // Consulta a IA para os produtos que ainda nao tem resposta gravada, e grava.
  //
  // Roda sob demanda, nunca junto da conferencia: a conferencia e usada o tempo
  // todo e nao pode ficar presa numa chamada externa.
  async buscarComIA(req: Request, res: Response) {
    if (!iaDisponivel()) throw new Error("Configure GEMINI_API_KEY no servidor para usar a busca por IA.");

    const total = await Ibpt.count();
    if (total === 0) throw new Error("Carregue a tabela do IBPT antes de usar a busca por IA.");

    const itens = Array.isArray(req.body?.produtos) ? req.body.produtos : [];
    if (itens.length === 0) throw new Error("Nenhum produto informado !");

    // Descricao repetida vira uma pergunta so - e o que faz o mesmo item em
    // varios clientes custar uma chamada, e nao uma por cliente.
    const descricoes: string[] = Array.from(new Set(itens.map((item: any) => String(item.descricao || "")))).filter((d) => !!d) as string[];

    // Reconsultar: apaga as respostas vazias antes de perguntar de novo. Serve
    // quando o motivo do "nao soube dizer" foi corrigido - foi o caso quando a
    // IA era obrigada a escolher entre os candidatos da busca textual e, numa
    // joalheria, nenhum candidato continha a resposta.
    if (String(req.body?.reconsultarVazios || "") === "1") {
      await IbptSugestaoIa.destroy({ where: { descricao: descricoes, ncm: null } });
    }

    const jaRespondidas: any[] = await IbptSugestaoIa.findAll({ where: { descricao: descricoes }, attributes: ["descricao"] });
    const conhecidas = new Set(jaRespondidas.map((linha: any) => linha.descricao));

    const pendentes = descricoes.filter((descricao) => !conhecidas.has(descricao)).slice(0, LIMITE_IA);

    if (pendentes.length === 0) {
      return res.status(200).json({ consultados: 0, comSugestao: 0, restantes: 0, message: "Todos os produtos selecionados já tinham resposta da IA." });
    }

    // Os candidatos saem da propria tabela do IBPT: a IA escolhe, nao inventa.
    const perguntas: PerguntaIA[] = [];
    for (const descricao of pendentes) {
      perguntas.push({ descricao, candidatos: await candidatosPara(descricao) });
    }

    let comSugestao = 0;
    let falharam = 0;
    let ultimoErro = "";

    for (let i = 0; i < perguntas.length; i += LOTE_IA) {
      const lote = perguntas.slice(i, i + LOTE_IA);

      let respostas;
      try {
        respostas = await escolherNCM(lote);
      } catch (erro: any) {
        // Um lote que falha nao pode levar junto o que ja foi respondido: o que
        // deu certo ja esta gravado, e este segue para o proximo. O operador
        // repete o botao depois e so o que faltou e consultado de novo.
        falharam += lote.length;
        ultimoErro = erro?.message || "falha ao consultar";
        continue;
      }

      for (const resposta of respostas) {
        // Segunda conferencia, agora contra o banco: mesmo escolhendo entre as
        // opcoes, nada entra sem existir na tabela.
        const registro: any = resposta.ncm ? await Ibpt.findOne({ where: { codigo: resposta.ncm } }) : null;
        if (registro) comSugestao++;

        await IbptSugestaoIa.upsert({
          descricao: resposta.descricao,
          ncm: registro ? registro.codigo : null,
          ncm_descricao: registro ? registro.descricao : null,
          modelo: modeloConfigurado(),
        } as any);
      }
    }

    res.status(200).json({
      consultados: pendentes.length - falharam,
      comSugestao,
      falharam,
      // Quando falha por sobrecarga, o texto do Google explica melhor que
      // qualquer resumo meu - e diz se e para tentar de novo agora ou depois.
      erro: falharam ? ultimoErro : "",
      restantes: descricoes.filter((d) => !conhecidas.has(d)).length - pendentes.length,
    });
  },

  // Mutirao: roda no servidor ate terminar. A tela pode ser fechada.
  async iniciarMutiraoIA(req: Request, res: Response) {
    if (!iaDisponivel()) throw new Error("Configure GEMINI_API_KEY no servidor para usar a busca por IA.");
    if ((await Ibpt.count()) === 0) throw new Error("Carregue a tabela do IBPT antes de usar a busca por IA.");
    if (mutirao.rodando) throw new Error("O mutirão já está rodando.");

    if (String(req.body?.reconsultarVazios || "") === "1") {
      await IbptSugestaoIa.destroy({ where: { ncm: null } });
    }

    mutirao.rodando = true;
    mutirao.parar = false;
    mutirao.tentativas = 0;
    mutirao.ultimoErro = "";
    mutirao.cotaDiaria = false;
    mutirao.iniciadoEm = new Date();
    mutirao.terminadoEm = null;

    // Sem await: a resposta volta agora e o trabalho segue no servidor.
    rodarMutirao();

    res.status(200).json({ iniciado: true });
  },

  async situacaoMutiraoIA(req: Request, res: Response) {
    res.status(200).json({ ...mutirao });
  },

  async pararMutiraoIA(req: Request, res: Response) {
    mutirao.parar = true;
    res.status(200).json({ parando: mutirao.rodando });
  },

  // ---------- Busca pela SEFAZ ----------

  async iniciarMutiraoSefaz(req: Request, res: Response) {
    if ((await Ibpt.count()) === 0) throw new Error("Carregue a tabela do IBPT antes de buscar pela SEFAZ.");
    if (mutiraoSefaz.rodando) throw new Error("A busca pela SEFAZ ja esta rodando.");

    // Falha aqui, e nao la dentro: sem certificado o mutirao rodaria so para
    // terminar em erro, e o operador nao saberia por que.
    const loja = await certificadoDisponivel();
    if (!loja) {
      throw new Error(
        "Nenhuma loja com certificado digital valido cadastrado. A consulta ao Cadastro Centralizado " +
          "de GTIN exige certificado A1 de um emitente de NF-e/NFC-e."
      );
    }

    mutiraoSefaz.rodando = true;
    mutiraoSefaz.parar = false;
    mutiraoSefaz.bloqueado = false;
    mutiraoSefaz.ultimoErro = "";
    mutiraoSefaz.iniciadoEm = new Date();
    mutiraoSefaz.terminadoEm = null;

    // Sem await: a resposta volta agora e o trabalho segue no servidor.
    rodarMutiraoSefaz();

    res.status(200).json({ iniciado: true });
  },

  async situacaoMutiraoSefaz(req: Request, res: Response) {
    res.status(200).json({ ...mutiraoSefaz });
  },

  async pararMutiraoSefaz(req: Request, res: Response) {
    mutiraoSefaz.parar = true;
    res.status(200).json({ parando: mutiraoSefaz.rodando });
  },

  // ---------- Normalizacao em massa, sobre a base inteira ----------

  async iniciarNormalizacao(req: Request, res: Response) {
    const origem = String(req.body?.origem || "") as OrigemNcm;
    if (!["sefaz", "tabela", "ia"].includes(origem)) throw new Error("Origem inválida.");
    if (normalizacao.rodando) throw new Error("Já existe uma normalização em andamento.");

    normalizacao.rodando = true;
    normalizacao.parar = false;
    normalizacao.origem = origem;
    normalizacao.total = 0;
    normalizacao.processados = 0;
    normalizacao.alterados = 0;
    normalizacao.ultimoErro = "";
    normalizacao.iniciadoEm = new Date();
    normalizacao.terminadoEm = null;

    // Sem await: a resposta volta agora e o trabalho segue no servidor.
    rodarNormalizacao(origem, req.body || {});

    res.status(200).json({ iniciado: true });
  },

  async situacaoNormalizacao(req: Request, res: Response) {
    res.status(200).json({ ...normalizacao });
  },

  async pararNormalizacao(req: Request, res: Response) {
    normalizacao.parar = true;
    res.status(200).json({ parando: normalizacao.rodando });
  },

  // ---------- Certificado digital do painel ----------

  // Nunca devolve o certificado nem a senha - so o que identifica quem esta
  // assinando as consultas.
  async situacaoCertificado(req: Request, res: Response) {
    const proprio: any = await SefazCertificado.findOne({ order: [["id", "DESC"]] });

    // Mostra tambem o plano B, para o operador saber com qual CNPJ as consultas
    // sairiam se ele nao subir um certificado proprio.
    const emUso = await certificadoDisponivel();

    res.status(200).json({
      temProprio: !!proprio,
      titular: proprio?.titular || null,
      documento: proprio?.documento || null,
      validade: proprio?.validade || null,
      vencido: proprio?.validade ? new Date(proprio.validade) < new Date() : false,
      emUso: emUso ? { origem: emUso.origem, titular: emUso.titular, documento: emUso.cnpjcpf } : null,
    });
  },

  enviarCertificado: [
    storageCertificado.single("arquivo"),
    async (req: Request, res: Response) => {
      try {
        const arquivo = (req as any).file;
        if (!arquivo) return res.status(400).json({ message: "Envie o certificado A1 (.pfx ou .p12)." });

        const senha = String(req.body?.senha || "");
        if (senha === "") return res.status(400).json({ message: "Informe a senha do certificado." });

        const base64 = arquivo.buffer.toString("base64");

        // Abre o .pfx aqui: senha errada ou certificado vencido tem que falhar
        // no upload, e nao no meio de uma varredura de horas.
        const info = SefazService.validarCertificado(base64, senha);

        // Uma linha so: o novo substitui o anterior.
        await db.transaction(async (transaction) => {
          await SefazCertificado.destroy({ where: {}, transaction });
          await SefazCertificado.create(
            {
              certificado: base64,
              senha,
              titular: info.titular,
              documento: info.documento,
              validade: info.validade,
            } as any,
            { transaction }
          );
        });

        res.status(201).json({
          message: "Certificado cadastrado com sucesso !",
          titular: info.titular,
          documento: info.documento,
          validade: info.validade,
        });
      } catch (error: any) {
        res.status(400).json({ message: error.message || "Erro ao ler o certificado." });
      }
    },
  ],

  async removerCertificado(req: Request, res: Response) {
    if (mutiraoSefaz.rodando) throw new Error("Pare a busca pela SEFAZ antes de remover o certificado.");

    await SefazCertificado.destroy({ where: {} });
    res.status(200).json({ message: "Certificado removido." });
  },

  // Consulta UM GTIN de verdade e devolve a resposta crua da SEFAZ.
  //
  // Serve para validar a integracao antes de disparar a varredura inteira: o
  // namespace do wsdl nao pode ser confirmado sem certificado (o WSDL responde
  // 403), entao este botao e o primeiro teste real possivel.
  async testarSefaz(req: Request, res: Response) {
    const gtin = String(req.body?.gtin || "").replace(/[^0-9]/g, "");
    if (![8, 12, 13, 14].includes(gtin.length)) throw new Error("Informe um GTIN de 8, 12, 13 ou 14 dígitos.");

    const loja = await certificadoDisponivel();
    if (!loja) throw new Error("Cadastre um certificado digital antes de testar.");

    const resposta = await consultarGTIN(gtin, loja);

    res.status(200).json({
      ...resposta,
      // Confere na tabela: NCM que a SEFAZ devolve mas o IBPT nao tem seria
      // recusado na hora de gravar, e e melhor descobrir isso no teste.
      noIbpt: resposta.ncm ? (await Ibpt.count({ where: { codigo: resposta.ncm } })) > 0 : false,
      certificado: { origem: loja.origem, titular: loja.titular, documento: loja.cnpjcpf },
      // Sem GTIN consultavel a resposta vem vazia por regra do servico, nao por
      // erro nosso - dizer isso evita caca a bug inexistente.
      consultavel: gtinConsultavel(gtin),
    });
  },

  // ---------- Clientes ----------

  // Sugere NCM parecidos com a descricao do produto. Existe porque escolher NCM
  // na mao, em 11 mil linhas, e o que produz justamente os NCM errados que a
  // conferencia do painel encontra depois.
  async sugerir(req: Request, res: Response) {
    const termos = termosDaDescricao(String(req.query.descricao || ""));
    if (termos.length === 0) return res.status(200).json([]);

    // A primeira palavra e a que nomeia o produto e por isso e obrigatoria; as
    // demais so ordenam. Com OR puro, uma palavra generica da descricao casava
    // com qualquer coisa ("ANTIMOFO DIA A DIA" sugeria selo postal, por causa
    // de "envelopes de primeiro dia").
    const primeiro = termos[0];
    const consulta = termos.join(" | ");

    const registros = await db.query(
      `select codigo, descricao,
              ts_rank(to_tsvector('portuguese', descricao), to_tsquery('portuguese', :consulta)) as score
         from ibpt
        where to_tsvector('portuguese', descricao) @@ to_tsquery('portuguese', :primeiro)
        order by
          -- item cuja descricao COMECA pelo termo vem antes da mencao de passagem
          case when lower(descricao) like lower(:primeiro) || '%' then 0 else 1 end,
          score desc,
          length(descricao),
          codigo
        limit ${LIMITE_SUGESTAO}`,
      { replacements: { consulta, primeiro }, type: QueryTypes.SELECT }
    );

    // Nada encontrado: devolve o padrao, marcado, para quem escolhe saber que
    // e um padrao e nao uma correspondencia.
    if ((registros as any[]).length === 0) {
      const padrao: any = await Ibpt.findOne({ where: { codigo: NCM_PADRAO } });
      if (!padrao) return res.status(200).json([]);

      return res.status(200).json([{ codigo: padrao.codigo, descricao: padrao.descricao, score: 0, padrao: true }]);
    }

    res.status(200).json(
      (registros as any[]).map((registro) => ({
        codigo: registro.codigo,
        descricao: registro.descricao,
        score: Number(registro.score),
      }))
    );
  },

  // Busca do modal de NCM: por codigo ou por trecho da descricao. Antes a lista
  // inteira ia no bundle do front (4 MB) e o filtro era em memoria.
  async buscar(req: Request, res: Response) {
    const termo = String(req.query.q || "").trim();
    if (termo.length < 2) return res.status(200).json([]);

    const somenteDigitos = termo.replace(/\D/g, "");

    const registros = await Ibpt.findAll({
      where: {
        [Op.or]: [...(somenteDigitos ? [{ codigo: { [Op.like]: `${somenteDigitos}%` } }] : []), { descricao: { [Op.iLike]: `%${termo}%` } }],
      },
      order: [["codigo", "ASC"]],
      limit: LIMITE_BUSCA,
    });

    res.status(200).json(registros.map(serializar));
  },

  async porCodigo(req: Request, res: Response) {
    const codigo = String(req.params.codigo || "").replace(/\D/g, "").padStart(8, "0");

    const registro: any = await Ibpt.findOne({ where: { codigo }, order: [["ex", "ASC"]] });
    if (!registro) return res.status(200).json(null);

    res.status(200).json(serializar(registro));
  },
};


// Candidatos do IBPT para uma descricao: e o que a IA recebe para escolher.
async function candidatosPara(descricao: string): Promise<{ codigo: string; descricao: string }[]> {
  const termos = termosDaDescricao(descricao);
  if (termos.length === 0) return [];

  // Aqui o filtro e mais solto que na sugestao por texto (OR, sem exigir a
  // primeira palavra): a IA sabe descartar o que nao serve, e um leque maior
  // aumenta a chance de a opcao certa estar entre as opcoes.
  const registros: any[] = await db.query(
    `select codigo, descricao
       from ibpt
      where to_tsvector('portuguese', descricao) @@ to_tsquery('portuguese', :consulta)
      order by ts_rank(to_tsvector('portuguese', descricao), to_tsquery('portuguese', :consulta)) desc, length(descricao)
      limit ${CANDIDATOS_POR_PRODUTO}`,
    { replacements: { consulta: termos.join(" | ") }, type: QueryTypes.SELECT }
  );

  return registros.map((registro: any) => ({ codigo: registro.codigo, descricao: registro.descricao }));
}

// Anexa o que a IA ja respondeu antes. So leitura: a conferencia e usada o
// tempo todo e nao pode depender de chamada externa - quem consulta a IA e o
// botao proprio, uma vez.
async function anexarSugestoesIA(produtos: any[]): Promise<void> {
  const descricoes = Array.from(new Set(produtos.map((p) => p.descricao).filter((d) => !!d)));
  if (descricoes.length === 0) return;

  const cache: any[] = await IbptSugestaoIa.findAll({ where: { descricao: descricoes } });

  const porDescricao = new Map<string, any>();
  cache.forEach((linha: any) => porDescricao.set(linha.descricao, linha));

  produtos.forEach((produto) => {
    const linha = porDescricao.get(produto.descricao);
    if (!linha) return;

    produto.ncm_ia = linha.ncm;
    produto.descricao_ia = linha.ncm_descricao;
    // Diferente de "sem cache": a IA ja foi consultada e nao soube dizer.
    produto.ia_consultada = true;
  });
}

// Anexa o que a SEFAZ respondeu para o codigo de barras do produto. Vem do
// cache: a consulta em si roda no mutirao, nao a cada abertura da tela.
async function anexarSefaz(produtos: any[]): Promise<void> {
  const porGtin = new Map<string, any>();

  const gtins = Array.from(
    new Set(produtos.map((p) => String(p.codigo_barras || "").replace(/[^0-9]/g, "")).filter((g) => g.length > 0))
  );
  if (gtins.length === 0) return;

  const cache: any[] = await GtinSefaz.findAll({ where: { gtin: gtins } });
  cache.forEach((linha: any) => porGtin.set(linha.gtin, linha));

  produtos.forEach((produto) => {
    const gtin = String(produto.codigo_barras || "").replace(/[^0-9]/g, "");
    // Util na tela mesmo sem resposta: explica por que este produto nunca vai
    // ter NCM pela SEFAZ (codigo interno da loja, ou GTIN importado).
    produto.gtin_consultavel = gtinConsultavel(gtin);

    const linha = porGtin.get(gtin);
    if (!linha) return;

    produto.ncm_sefaz = linha.ncm;
    produto.descricao_sefaz = linha.xprod;
    produto.motivo_sefaz = linha.xmotivo;
    // Diferente de "sem consulta": a SEFAZ ja foi perguntada e nao tem o GTIN.
    produto.sefaz_consultada = true;
  });
}



// Sugestao a partir do NCM que o cliente JA digitou, subindo na hierarquia da
// propria NCM: 8 digitos = item, 6 = subposicao, 4 = posicao, 2 = capitulo.
// Se 30029091 nao existe, 300290 existe e tem um unico filho (30029000).
//
// Vale mais que adivinhar pela descricao porque aproveita a intencao de quem
// cadastrou - o codigo errado quase sempre erra no fim, nao no comeco.
//
// O PROBLEMA DOS ZEROS. Todo NCM na base tem 8 digitos, mas parte deles ganhou
// zeros a esquerda que nao sao do codigo: 00007113 e a posicao 7113 (joalharia)
// com quatro zeros posticos, enquanto 00910900 e 0910 (especiarias) com apenas
// um. Nao da para saber quantos zeros sao lixo olhando so o numero.
//
// Entao tenta TODAS as remocoes possiveis de zeros a esquerda e deixa a tabela
// decidir, ordenando por:
//   1. prefixo mais longo (6 digitos e subposicao, 4 e posicao);
//   2. menos zeros removidos, no empate - remocao e reparo, faca o minimo;
//   3. maior codigo do grupo. Pela convencao da NCM o residual "Outros" e o
//      maior (termina em 90/99), e e ele o certo quando a subposicao foi
//      desmembrada - caso do 08109000, que virou 08109011..17 mais 08109090.
//
// AMBIGUIDADE. Ha casos que nenhuma regra numerica resolve: 00910900 le tanto
// como 0910 (especiarias) quanto como 9109 (relojoaria), e so a descricao do
// produto desempata - era um cominho recebendo NCM de relojoaria. Quando existe
// leitura concorrente em OUTRO CAPITULO com especificidade parecida, a sugestao
// vai marcada como ambigua: aparece na tela, mas fica fora do "aplicar em
// todos". Sao 27 produtos em 11.782 - o resto e inequivoco.
//
// Piso de 4 digitos de proposito. Casar so o capitulo e vago demais para
// gravar: o capitulo 30 inteiro e "produtos farmaceuticos". Melhor nao sugerir
// do que sugerir mal.
async function anexarSugestaoPrefixo(produtos: any[]): Promise<void> {
  const chave = (ncm: any) => String(ncm || "").replace(/[^0-9]/g, "").substring(0, DIGITOS_NCM);

  const ncms = Array.from(new Set(produtos.map((p) => chave(p.ncm)).filter((n) => n.length >= 2)));
  if (ncms.length === 0) return;

  // bind, nao replacements: replacements expande array como lista separada por
  // virgula e quebra o ::text[].
  const linhas: any[] = await db.query(
    `with alvo as (
       select distinct left(regexp_replace(t.n, ${RX}, '', 'g'), ${DIGITOS_NCM}) as d
         from unnest($1::text[]) as t(n)
     ),
     norm as (
       select d, lpad(d, ${DIGITOS_NCM}, '0') as pad from alvo where d <> ''
     ),
     cand as (
       select n.d, g.i as dropados, p.prefixo, length(p.prefixo) as tam
         from norm n
         cross join generate_series(0, ${DIGITOS_NCM - 1}) as g(i)
         cross join lateral (
           select * from (values
             (left(substr(n.pad, g.i + 1), 6)),
             (left(substr(n.pad, g.i + 1), 4))
           ) as t(prefixo)
         ) p
        -- So remove zero: cortar um digito significativo inventaria um NCM.
        where (g.i = 0 or left(n.pad, g.i) ~ '^0+$')
          and length(p.prefixo) >= 4
     ),
     casou as (
       select c.d, c.dropados, c.prefixo, c.tam,
              i.codigo, i.descricao, left(i.codigo, 2) as capitulo
         from cand c
         join ibpt i on i.codigo like c.prefixo || '%'
        -- A tabela do IBPT traz um 00000000 "PRODUTO NAO ESPECIFICADO NA LISTA
        -- DE NCM". Ele casa com qualquer prefixo de zeros, e pior: passaria na
        -- validacao do normalizar, marcando o produto como resolvido sem dizer
        -- nada.
        where i.codigo !~ '^0+$'
     ),
     escolha as (
       select distinct on (x.d) x.d, x.prefixo, x.codigo, x.descricao, x.tam, x.capitulo
         from casou x
        order by x.d, x.tam desc, x.dropados, x.codigo desc
     )
     select e.d, e.prefixo, e.codigo, e.descricao,
            exists (
              select 1 from casou c
               where c.d = e.d and c.capitulo <> e.capitulo and c.tam >= e.tam - 1
            ) as ambiguo
       from escolha e`,
    { bind: [ncms], type: QueryTypes.SELECT }
  );

  const porNcm = new Map<string, any>();
  linhas.forEach((linha: any) => porNcm.set(linha.d, linha));

  produtos.forEach((produto) => {
    const linha = porNcm.get(chave(produto.ncm));
    if (!linha) return;

    produto.ncm_tabela = linha.codigo;
    produto.descricao_tabela = linha.descricao;
    // Quantos digitos casaram: 6 e bem mais confiavel que 4, e quem le precisa
    // saber disso antes de aplicar em massa.
    produto.prefixo_tabela = linha.prefixo;
    produto.ambiguo_tabela = linha.ambiguo === true;
  });
}

function serializar(registro: any) {
  return {
    codigo: registro.codigo,
    ex: registro.ex,
    tipo: registro.tipo,
    descricao: registro.descricao,
    nacionalFederal: Number(registro.nacional_federal),
    importadoFederal: Number(registro.importado_federal),
    estadual: Number(registro.estadual),
    municipal: Number(registro.municipal),
    vigenciaInicio: registro.vigencia_inicio,
    vigenciaFim: registro.vigencia_fim,
    versao: registro.versao,
  };
}
