import Produto from "../models/Produto";
import ProdutoCodigoBarras from "../models/ProdutoCodigoBarras";
import db from "../database/config";
import { getNextCodigoProduto } from "./UtilsController";
import { ProdutoRepositoryPG } from "../infra/repository/ProdutoRepository";

// ✅ função fora (resolve o erro do this)
function normalizarCodigoBarras(valor: any): string {
  return (
    String(valor || "")
      .trim()
      .replace(/^0+/, "") || "0"
  );
}

// Normaliza, valida o formato e remove duplicados/vazios da lista de códigos
// auxiliares, garantindo que nenhum colida com o código de barras principal.
// Lança erro com mensagem amigável em caso de problema de formato.
function prepararCodigosAuxiliares(codigos: any, codigoBarrasPrincipal: string): string[] {
  if (!Array.isArray(codigos)) return [];

  const vistos = new Set<string>();
  const resultado: string[] = [];

  for (const bruto of codigos) {
    const codigo = normalizarCodigoBarras(bruto);
    if (codigo === "" || codigo === "0") continue; // ignora linhas em branco

    if (!/^\d+$/.test(codigo)) {
      throw new Error(`Código auxiliar "${bruto}" deve conter apenas números!`);
    }
    if (codigo.length > 14) {
      throw new Error(`Código auxiliar "${codigo}" não pode ter mais que 14 dígitos!`);
    }
    if (codigo === codigoBarrasPrincipal) {
      throw new Error(`O código auxiliar "${codigo}" é igual ao código de barras principal!`);
    }
    if (vistos.has(codigo)) {
      throw new Error(`O código auxiliar "${codigo}" está duplicado na lista!`);
    }

    vistos.add(codigo);
    resultado.push(codigo);
  }

  return resultado;
}

// Procura o primeiro código (principal ou auxiliar) que já esteja em uso por
// OUTRO produto do mesmo tenant, seja como código principal ou como auxiliar.
// Retorna o código conflitante ou null se estiver tudo livre.
async function encontrarConflitoCodigos(codigos: string[], codigoProdutoAtual: any, tenant_id: number): Promise<string | null> {
  const atual = String(codigoProdutoAtual ?? "");

  for (const codigo of codigos) {
    const produtoComMesmoBarras = await Produto.findOne({
      where: { codigo_barras: codigo, tenant_id },
    });
    if (produtoComMesmoBarras && String(produtoComMesmoBarras.getDataValue("codigo")) !== atual) {
      return codigo;
    }

    const auxComMesmoBarras = await ProdutoCodigoBarras.findOne({
      where: { codigo_barras: codigo, tenant_id },
    });
    if (auxComMesmoBarras && String(auxComMesmoBarras.getDataValue("codigo_produto")) !== atual) {
      return codigo;
    }
  }

  return null;
}

// Regrava (substitui) a lista de códigos auxiliares de um produto dentro de uma
// transação já aberta.
async function regravarCodigosAuxiliares(codigoProduto: string, auxiliares: string[], tenant_id: number, transaction: any) {
  await ProdutoCodigoBarras.destroy({
    where: { codigo_produto: codigoProduto, tenant_id },
    transaction,
  });

  if (auxiliares.length > 0) {
    await ProdutoCodigoBarras.bulkCreate(
      auxiliares.map((codigo_barras) => ({ codigo_produto: codigoProduto, codigo_barras, tenant_id })),
      { transaction }
    );
  }
}

export default {
  async getProdutosWithPreco(req: any, res: any) {
    const produtoRepository = new ProdutoRepositoryPG();
    const { tenant_id } = req;

    const alterados = req.query.alterados;
    const loja = req.query.loja;

    const produtos = await produtoRepository.getAllWithPreco(tenant_id, loja, alterados);
    return res.status(200).json(produtos);
  },

  async getProdutos(req: any, res: any) {
    const { tenant_id } = req;
    const alterados = req.query.alterados;
    try {
      if (!alterados) {
        const produtos: any = await Produto.findAll({
          where: { tenant_id },
          order: [["codigo", "ASC"]],
          attributes: { exclude: ["tenant_id"] },
        });
        res.status(200).json(produtos);
      } else {
        const produtos: any = await Produto.findAll({
          where: { tenant_id, carga_pendente: true },
          order: [["codigo", "ASC"]],
          attributes: { exclude: ["tenant_id"] },
        });
        res.status(200).json(produtos);
      }
    } catch (error) {
      res.status(400).json({ error: error });
    }
  },

  // Verifica se um código de barras já está em uso por OUTRO produto do tenant
  // (seja como código principal ou como auxiliar). Usado pelo cadastro para
  // impedir a inclusão de um auxiliar que pertença a outro produto.
  async verificarCodigoBarras(req: any, res: any) {
    try {
      const { tenant_id } = req;
      const codigo = normalizarCodigoBarras(req.query.codigo);
      const ignorarCodigoProduto = req.query.ignorarCodigoProduto;

      if (codigo === "" || codigo === "0") {
        return res.status(200).json({ emUso: false });
      }

      const conflito = await encontrarConflitoCodigos([codigo], ignorarCodigoProduto, tenant_id);
      return res.status(200).json({ emUso: !!conflito, codigo: conflito });
    } catch (error: any) {
      return res.status(400).json({ message: error.message });
    }
  },

  async getProduto(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;
    try {
      if (codigo === "novo") {
        const novoCodigo = await getNextCodigoProduto(tenant_id);
        const produto = { codigo: novoCodigo, codigo_barras: novoCodigo, codigos_barras_auxiliares: [] };
        res.status(200).json(produto);
      } else {
        const produto = await Produto.findOne({
          where: { codigo, tenant_id },
          attributes: { exclude: ["tenant_id"] },
        });

        const auxiliares = await ProdutoCodigoBarras.findAll({
          where: { codigo_produto: codigo, tenant_id },
          attributes: ["codigo_barras"],
          order: [["id", "ASC"]],
        });

        const data = produto
          ? {
              ...produto.toJSON(),
              codigos_barras_auxiliares: auxiliares.map((a: any) => a.getDataValue("codigo_barras")),
            }
          : produto;

        res.status(200).json(data);
      }
    } catch (error: any) {
      res.status(404).send({ message: error.message });
    }
  },

  async insertProduto(req: any, res: any) {
    const { codigo: codigoBruto, codigo_barras, descricao, secao, fornecedor, grupo, subgrupo, unidade, formaVenda, tributacao, impfederal, ncm, cest, balanca, balanca_validade, ativo, diversos, codigos_barras_auxiliares } = req.body;

    // O frontend pode enviar o código como número. As colunas codigo/codigo_produto
    // são varchar, então normalizamos para string para evitar o erro do Postgres
    // "operator does not exist: character varying = integer" nas comparações (WHERE).
    const codigo = String(codigoBruto ?? "");
    const codigoBarras = normalizarCodigoBarras(codigo_barras);
    const { tenant_id } = req;

    let auxiliares: string[];
    try {
      auxiliares = prepararCodigosAuxiliares(codigos_barras_auxiliares, codigoBarras);
    } catch (error: any) {
      return res.status(400).json({ message: error.message });
    }

    const conflito = await encontrarConflitoCodigos([codigoBarras, ...auxiliares], codigo, tenant_id);
    if (conflito) {
      return res.status(409).json({ message: `O código de barras "${conflito}" já está em uso por outro produto!` });
    }

    try {
      await db.transaction(async (transaction: any) => {
        await Produto.create(
          {
            codigo,
            codigo_barras: codigoBarras, // 🔥 corrigido também aqui
            descricao,
            tenant_id,
            secao,
            fornecedor,
            grupo,
            subgrupo,
            unidade,
            formaVenda,
            tributacao,
            impfederal,
            ncm,
            cest,
            balanca,
            balanca_validade,
            ativo,
            diversos,
            carga_pendente: true,
          },
          { transaction }
        );

        await regravarCodigosAuxiliares(codigo, auxiliares, tenant_id, transaction);
      });

      res.status(201).json({ message: "Produto inserido com sucesso !" });
    } catch (error: any) {
      res.status(400).json({ message: "Erro ao inserir produto ! " + error.message });
    }
  },

  async updateProduto(req: any, res: any) {
    const { tenant_id } = req;

    const { codigo, codigo_barras, descricao, secao, fornecedor, grupo, subgrupo, unidade, formaVenda, tributacao, impfederal, ncm, cest, balanca, balanca_validade, ativo, diversos, codigos_barras_auxiliares } = req.body;

    const produto = await Produto.findOne({
      where: {
        codigo,
        tenant_id,
      },
    });

    if (!produto) {
      return res.status(404).json({ message: "Nenhum produto encontrado !" });
    }

    const codigoProduto = produto.getDataValue("codigo");
    const novoCodigoBarras = normalizarCodigoBarras(codigo_barras);

    let auxiliares: string[];
    try {
      auxiliares = prepararCodigosAuxiliares(codigos_barras_auxiliares, novoCodigoBarras);
    } catch (error: any) {
      return res.status(400).json({ message: error.message });
    }

    // Valida o principal e os auxiliares contra códigos de OUTROS produtos
    // (tanto principais quanto auxiliares), ignorando o próprio produto.
    const conflito = await encontrarConflitoCodigos([novoCodigoBarras, ...auxiliares], codigoProduto, tenant_id);
    if (conflito) {
      return res.status(409).json({ message: `O código de barras "${conflito}" já está em uso por outro produto!` });
    }

    try {
      await db.transaction(async (transaction: any) => {
        await Produto.update(
          {
            codigo,
            codigo_barras: novoCodigoBarras,
            descricao,
            secao,
            fornecedor,
            grupo,
            subgrupo,
            unidade,
            formaVenda,
            tributacao,
            impfederal,
            ncm,
            cest,
            balanca,
            balanca_validade,
            ativo,
            diversos,
            carga_pendente: true,
            updated_at: new Date(),
          },
          {
            where: {
              codigo: codigoProduto,
              tenant_id,
            },
            transaction,
          }
        );

        await regravarCodigosAuxiliares(codigoProduto, auxiliares, tenant_id, transaction);
      });
    } catch (error: any) {
      return res.status(400).json({ message: "Erro ao atualizar produto ! " + error.message });
    }

    return res.status(200).json({ message: "Produto atualizado com sucesso !" });
  },
};
