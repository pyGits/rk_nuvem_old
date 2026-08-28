import multer, { Multer } from "multer";
import iconv from "iconv-lite";
import { Op, QueryTypes } from "sequelize";
import { Request, Response } from "express";
import db from "../database/config";
import Ibpt from "../models/Ibpt";
import IbptCarga from "../models/IbptCarga";
import IbptSugestaoIa from "../models/IbptSugestaoIa";
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
// Lote pequeno de proposito: quando o modelo esta sobrecarregado, o que se
// perde numa falha e um lote inteiro. Menor = menos retrabalho e resposta mais
// curta, que o modelo trunca com menos frequencia.
const LOTE_IA = 8;
// Teto por execucao do botao, para nao estourar a cota do plano gratuito num
// clique so. O que sobrar fica para a proxima rodada.
const LIMITE_IA = 300;

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
  iniciadoEm: null as Date | null,
  terminadoEm: null as Date | null,
};

function esperar(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
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
        perguntas.push({ descricao, candidatos: await candidatosPara(descricao) });
      }

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
        i += LOTE_IA;

        // Respiro entre lotes: o erro de sobrecarga vem de rajada, e insistir
        // sem pausa mantem o modelo ocupado com a nossa propria fila.
        await esperar(1500);
      } catch (erro: any) {
        // NAO avanca o indice: o mesmo lote sera tentado de novo.
        mutirao.tentativas++;
        mutirao.ultimoErro = erro?.message || "falha ao consultar";

        // Espera crescente ate 2 minutos - sobrecarga costuma passar nessa faixa.
        await esperar(Math.min(15000 * mutirao.tentativas, 120000));
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

    res.status(200).json({
      tabelaCarregada: true,
      produtos: lista,
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

    await db.transaction(async (transaction) => {
      for (const item of itens) {
        const ncm = String(item.ncm || "").replace(/[^0-9]/g, "");

        if (ncm.length !== DIGITOS_NCM) {
          rejeitados.push({ codigo: item.codigo, erro: "NCM deve ter 8 dígitos" });
          continue;
        }

        // Confere na tabela: sem isto a normalizacao poderia gravar um NCM que
        // a propria conferencia acusaria como irregular no dia seguinte.
        const existe = await Ibpt.count({ where: { codigo: ncm }, transaction });
        if (existe === 0) {
          rejeitados.push({ codigo: item.codigo, erro: "NCM não existe na tabela IBPT" });
          continue;
        }

        const [linhas] = await db.query(
          "update produtos set ncm = :ncm, updated_at = now() where tenant_id = :tenant_id and codigo = :codigo and codigo_barras = :codigo_barras",
          { replacements: { ncm, tenant_id: Number(item.tenant_id), codigo: item.codigo, codigo_barras: item.codigo_barras }, type: QueryTypes.UPDATE, transaction }
        );

        alterados += Number(linhas || 0);
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
      limit ${LIMITE_SUGESTAO}`,
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
