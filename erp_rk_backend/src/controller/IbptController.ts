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

export function converterCSV(conteudo: string): LinhaIbpt[] {
  const linhas = conteudo.split(/\r?\n/).filter((linha) => linha.trim() !== "");
  if (linhas.length === 0) throw new Error("Arquivo vazio !");

  const cabecalho = separarCampos(linhas[0]).map((coluna) => coluna.toLowerCase());
  const faltando = COLUNAS.filter((coluna) => !cabecalho.includes(coluna));
  if (faltando.length > 0) {
    throw new Error(`Arquivo não parece ser a tabela do IBPT. Faltam as colunas: ${faltando.join(", ")}`);
  }

  const indice = (coluna: string) => cabecalho.indexOf(coluna);
  const registros: LinhaIbpt[] = [];
  // O mesmo (codigo, ex) repetido no arquivo violaria a unique da tabela e
  // derrubaria a carga inteira no meio; fica a ultima ocorrencia.
  const vistos = new Map<string, number>();

  for (let i = 1; i < linhas.length; i++) {
    const campos = separarCampos(linhas[i]);
    const codigo = String(campos[indice("codigo")] || "").replace(/\D/g, "");
    if (!codigo) continue;

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

  return registros;
}

export default {
  // ---------- Painel administrativo ----------

  publicar: [
    storage.single("arquivo"),
    async (req: Request, res: Response) => {
      try {
        const arquivo = (req as any).file;
        if (!arquivo) return res.status(400).json({ message: "Envie o arquivo .csv do IBPT." });

        const registros = converterCSV(iconv.decode(arquivo.buffer, ENCODING_ARQUIVO));

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
           or not exists (select 1 from ibpt i where i.codigo = p.ncm_limpo)
        order by t.name nulls last, p.descricao`,
      { replacements: parametros, type: QueryTypes.SELECT }
    );

    res.status(200).json({
      tabelaCarregada: true,
      produtos,
      totais: {
        produtos: produtos.length,
        clientes: new Set(produtos.map((linha: any) => linha.tenant_id)).size,
      },
    });
  },

  // ---------- Clientes ----------

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
