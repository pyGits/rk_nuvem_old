import multer, { Multer } from "multer";
import iconv from "iconv-lite";
import { Op, QueryTypes } from "sequelize";
import { Request, Response } from "express";
import db from "../database/config";
import Ibpt from "../models/Ibpt";
import IbptCarga from "../models/IbptCarga";

// O arquivo do IBPT sai em ANSI (cp1252), nao em UTF-8. Ler como UTF-8 corrompe
// toda descricao acentuada - e sao milhares.
const ENCODING_ARQUIVO = "win1252";

const TAMANHO_MAXIMO = 20 * 1024 * 1024; // o arquivo de referencia tem ~2 MB
const LOTE_INSERCAO = 1000;
const LIMITE_BUSCA = 50;
const DIGITOS_NCM = 8;
const LIMITE_SUGESTAO = 10;
// Sem inquilino escolhido a conferencia traz todos os clientes. O teto existe
// so como protecao contra uma base absurda: ele nunca deveria ser atingido, e
// quando for, a tela avisa e o filtro por inquilino resolve.
const LIMITE_CONFERENCIA = 5000;

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

    await anexarSugestoes(lista as any[]);

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
        order by score desc, codigo
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

// Sugere um NCM para cada produto da lista, numa consulta so.
//
// O caminho obvio seria uma consulta por produto; com 500 produtos isso vira
// 500 idas ao banco. Aqui as consultas de texto vao juntas num array e o
// Postgres resolve todas com um LATERAL sobre o mesmo indice.
async function anexarSugestoes(produtos: any[]): Promise<void> {
  const primeiros: string[] = [];
  const consultas: string[] = [];
  const posicoes: number[] = [];

  produtos.forEach((produto, i) => {
    const termos = termosDaDescricao(produto.descricao);
    if (termos.length === 0) return;

    // A primeira palavra e a que nomeia o produto ("ARROZ tio joao"). Ela e
    // obrigatoria; as demais so ordenam. Sem essa exigencia, uma palavra
    // qualquer da descricao casa com qualquer coisa e a sugestao vira ruido.
    primeiros.push(termos[0]);
    consultas.push(termos.join(" | "));
    posicoes.push(i);
  });

  if (consultas.length === 0) return;

  // bind, e nao replacements: o replacements do Sequelize expande array como
  // lista "a','b" (para IN), o que aqui geraria SQL invalido. O bind vai pelo
  // driver, que converte JS array em array do Postgres de verdade.
  const achados: any[] = await db.query(
    `select entrada.idx, sugerido.codigo, sugerido.descricao
       from unnest($1::text[], $2::text[]) with ordinality as entrada(primeiro, consulta, idx)
       cross join lateral (
         select codigo, descricao
           from ibpt
          -- filtra pela primeira palavra, ordena pela descricao inteira
          where to_tsvector('portuguese', descricao) @@ to_tsquery('portuguese', entrada.primeiro)
          order by ts_rank(to_tsvector('portuguese', descricao), to_tsquery('portuguese', entrada.consulta)) desc, codigo
          limit 1
       ) sugerido`,
    { bind: [primeiros, consultas], type: QueryTypes.SELECT }
  );

  achados.forEach((achado: any) => {
    // ordinality comeca em 1
    const produto = produtos[posicoes[Number(achado.idx) - 1]];
    if (!produto) return;

    produto.ncm_sugerido = achado.codigo;
    produto.descricao_sugerida = achado.descricao;
  });

  // Sem correspondencia, cai no padrao - e marcado como tal, para a tela
  // mostrar diferente. Um palpite errado disfarcado de acerto e pior que
  // nenhuma sugestao.
  const padrao: any = await Ibpt.findOne({ where: { codigo: NCM_PADRAO } });

  produtos.forEach((produto) => {
    if (produto.ncm_sugerido) return;

    produto.ncm_sugerido = NCM_PADRAO;
    produto.descricao_sugerida = padrao ? padrao.descricao : "";
    produto.sugestao_padrao = true;
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
