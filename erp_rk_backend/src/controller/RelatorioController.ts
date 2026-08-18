import sequelize from "../database/config";
import { QueryTypes, Sequelize } from "sequelize";
import Loja from "../models/Loja";

/**
 * Lê o filtro de loja da query string do painel de vendas.
 * Vazio, 0 ou ausente significam "todas as lojas".
 * Retorna número para poder ser interpolado sem risco de injeção.
 */
function lojaFiltro(query: any): number | null {
  const loja = Number(query.loja);
  return Number.isInteger(loja) && loja > 0 ? loja : null;
}

export default {
  async relPainelLoja(req: any, res: any) {
    const { tenant_id } = req;
    const filtroLoja = lojaFiltro(req.query);
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

    if (!dtInicio || !dtFim) {
      res.status(400).json({ error: "data início e fim são obrigatórios" });
      return;
    }

    // Sem try/catch, uma falha aqui vira unhandledRejection e derruba o
    // processo inteiro — o que já aconteceu em produção.
    try {
      // lojas.codigo é varchar: comparar com número faz o Postgres abortar com
      // "operator does not exist: character varying = integer".
      const lojas = await Loja.findAll({
        where: filtroLoja ? { tenant_id, codigo: String(filtroLoja) } : { tenant_id },
      });

      let result: any[] = [];

      await Promise.all(
        lojas.map(async (loja: any) => {
          const results: any = await sequelize.query(
            `
          SELECT
            CONCAT(${loja.codigo}, ' - ', '${loja.nome}') as loja,
            COUNT(*) as qtd_clientes,
            COALESCE(SUM(valor_total), 0) as venda,
            COALESCE(SUM(valor_custo), 0) as venda_custo,
            COALESCE(SUM(valor_total) / COUNT(*), 0) as ticket_medio
          FROM vendas
          WHERE
            tenant_id = ${tenant_id}
            AND cancelado = 0
            AND loja = ${loja.codigo}
            AND data >= '${dtInicio}'
            AND data <= '${dtFim}'
          `,
            {
              type: QueryTypes.SELECT,
            }
          );

          const formattedResult = {
            loja: results[0].loja,
            qtd_clientes: parseInt(results[0].qtd_clientes) || 0,
            venda: results[0].venda || 0,
            venda_custo: results[0].venda_custo || 0,
            ticket_medio: results[0].ticket_medio || 0,
          };

          result.push(formattedResult);
        })
      );

      res.status(200).json(result);
    } catch (error: any) {
      res.status(400).json({ message: error.message });
    }
  },

  async relPainelProduto(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `AND v.loja = ${loja}` : "";

    const result = await sequelize.query(`SELECT
    p.descricao AS nome_produto,
    p.codigo_barras AS barras_produto,
    SUM(v.qtde) AS qtde,
    SUM(v.valor_total) AS venda_total,
    SUM(v.valor_custo_total) AS custo_total,
    CAST(SUM(v.valor_total - v.valor_custo_total) AS numeric(10,2)) AS venda_liquida,
    CASE
        WHEN SUM(v.valor_custo_total) = 0 THEN 0 -- Define o valor de markup como 0 se o custo total for zero
        ELSE CAST((SUM(v.valor_total - v.valor_custo_total) / SUM(v.valor_custo_total)) * 100 AS decimal(10, 2))
    END AS markup,
    v.codigo_produto
    FROM venda_items v
    JOIN produtos p ON v.codigo_produto = p.codigo
    WHERE v.cancelado = 0
    AND v.tenant_id = ${tenant_id}
    AND p.tenant_id = ${tenant_id}
    AND data >= '${dtInicio}'
    AND data <= '${dtFim}'
    ${filtroLoja}

GROUP BY p.descricao, v.codigo_produto, p.codigo_barras;

    `);

    res.status(200).json(result[0]);
  },
  async relPainelCaixa(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `AND v.loja = ${loja}` : "";

    const result = await sequelize.query(`
    SELECT l.codigo,l.nome AS nome_loja, v.caixa, 
    COUNT(*) as qtd_clientes,
    COALESCE(SUM(v.valor_total), 0) as venda,
    COALESCE(SUM(v.valor_custo), 0) as venda_custo,
    CAST(SUM(v.valor_total - v.valor_custo) AS numeric(10,2)) AS venda_liquida
    FROM vendas v
    JOIN lojas l ON v.loja = cast(l.codigo as integer)
    where l.tenant_id=${tenant_id} and v.tenant_id=${tenant_id} and v.cancelado=0
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    ${filtroLoja}
    GROUP BY l.codigo,l.nome, v.caixa;

    `);

    res.status(200).json(result[0]);
  },
  async relPainelFinalizadora(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `AND v.loja = ${loja}` : "";

    const result = await sequelize.query(`
    select 
    f.codigo as codigo_finalizadora,
    f.nome as nome_finalizadora,
    l.codigo as codigo_loja,
    l.nome as nome_loja,
    count(*) as qtd_finalizacoes,
    sum(v.valor) as venda_total ,
    sum(v.valor_troco) as venda_troco,
    (SUM(v.valor) - SUM(v.valor_troco)) AS diferenca_venda
    from venda_formas v
    left join lojas l on cast(l.codigo as integer) = v.loja
    left join finalizadoras f on f.codigo = v.finalizadora

    where l.tenant_id = ${tenant_id} and f.tenant_id = ${tenant_id} and v.tenant_id=${tenant_id}
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    and cancelado = 0
    ${filtroLoja}

    group by (f.codigo,f.nome,l.codigo,
    l.nome)


    `);

    res.status(200).json(result[0]);
  },

  async relPainelSecoes(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `AND v.loja = ${loja}` : "";

    const result = await sequelize.query(`
  SELECT
    s.codigo,
    s.nome,
    SUM(v.qtde) AS qtde,
    SUM(v.valor_total) AS venda_total,
    SUM(v.valor_custo_total) AS custo_total,
    CAST(SUM(v.valor_total - v.valor_custo_total) AS numeric(10, 2)) AS venda_liquida,
    CASE
        WHEN SUM(v.valor_custo_total) = 0 THEN 0 -- Define o valor de markup como 0 se o custo total for zero
        ELSE CAST((SUM(v.valor_total - v.valor_custo_total) / SUM(v.valor_custo_total)) * 100 AS decimal(10, 2))
    END AS markup
    FROM venda_items v
    JOIN produtos p ON p.codigo = v.codigo_produto
    JOIN secaos s ON p.secao = s.codigo
    WHERE s.tenant_id = ${tenant_id}
    AND p.tenant_id = ${tenant_id}
    AND v.tenant_id = ${tenant_id}
    AND v.cancelado = 0
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    ${filtroLoja}
    GROUP BY s.codigo, s.nome;



    `);

    res.status(200).json(result[0]);
  },
  async relPainelCupom(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `and v.loja = ${loja}` : "";

    const result = await sequelize.query(`select * from vendas v
    where v.tenant_id = ${tenant_id}
    and v.data >= '${dtInicio}'
    and v.data <= '${dtFim}'
    ${filtroLoja}
    `);
    res.status(200).json(result[0]);
  },

  async relPainelSaldoEstoque(req: any, res: any) {
    const { tenant_id } = req;
    const { positivo, negativo, zerado, reposicao } = req.query;
    const { loja, fornecedor, unidade, secao, grupo } = req.query;
    let filtroLoja = "";
    let filtroFornecedor = "";
    let filtroQtdEstoque = "";
    let filtroReposicao = "";
    let filtroUnidade = "";
    let filtroSecao = "";
    let filtroGrupo = "";

    if (secao != 0 && secao) {
      filtroSecao = `and p.secao = '${secao}'`;
    }
    if (grupo != 0 && grupo) {
      filtroGrupo = `and p.secao = '${secao}' and p.grupo = '${grupo}'`;
    }

    if (loja != 0 && loja) {
      filtroLoja = `and e.loja = ${loja}`;
    }
    if (fornecedor != 0 && fornecedor) {
      filtroFornecedor = `and p.fornecedor = '${fornecedor}'`;
    }
    if (unidade) {
      filtroUnidade = `and p.unidade = '${unidade}'`;
    }

    if (reposicao === "true") {
      filtroReposicao = `and e.estoque_minimo > e.estoque`;
    }

    // somente positivo
    if (positivo === "true" && negativo === "false" && zerado === "false") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) > 0";
    }

    // positivo e negativo
    if (positivo === "true" && negativo === "true" && zerado === "false") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) <> 0";
    }
    // positivo e zerado
    if (positivo === "true" && negativo === "false" && zerado === "true") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) >= 0";
    }

    // positivo, negativo e zerado
    if (positivo === "true" && negativo === "true" && zerado === "true") {
      filtroQtdEstoque = "";
    }

    // somente negativo
    if (positivo === "false" && negativo === "true" && zerado === "false") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) < 0";
    }

    // negativo e zerado
    if (positivo === "false" && negativo === "true" && zerado === "true") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) <= 0";
    }

    // somente zerado
    if (positivo === "false" && negativo === "false" && zerado === "true") {
      filtroQtdEstoque = "HAVING SUM(e.estoque) = 0";
    }

    const result = await sequelize.query(`
    select p.codigo,p.codigo_barras,p.descricao,sum(e.estoque) as saldo_estoque
      from produtos p
      join estoques e
      on p.codigo = e.codigo_produto
      where p.tenant_id = ${tenant_id} and e.tenant_id = ${tenant_id}
      ${filtroLoja}
      ${filtroFornecedor}
      ${filtroReposicao}
      ${filtroUnidade}
      ${filtroSecao}
      ${filtroGrupo}
      
      group by p.codigo,p.descricao,p.codigo_barras   
       ${filtroQtdEstoque}
      `);

    res.status(200).json(result[0]);
  },
  async relCupomUnico(req: any, res: any) {
    const { tenant_id } = req;
    const { data, codigo, caixa, loja } = req.query;
    // const venda = await VendaItem.findAll({
    //   where: { tenant_id, data, codigo_cupom: codigo, caixa, loja },
    // });

    const venda = await sequelize.query(`
    select vi.item,p.codigo_barras,p.descricao,
    vi.unidade,vi.qtde,vi.valor_unitario,vi.valor_desconto,vi.valor_acrescimo,vi.valor_total,
    vi.cancelado
    from venda_items vi
    join produtos p on vi.codigo_produto = p.codigo
    where p.tenant_id=${tenant_id} and vi.tenant_id=${tenant_id}
    and vi.data='${data}' and vi.codigo_cupom='${codigo}'
    and vi.caixa='${caixa}' and vi.loja='${loja}'
    `);

    if (!venda) {
      res.status(400).json({ message: "Venda não encontrada" });
    }
    res.status(200).json(venda[0]);
  },

  // Relatório: listagem de produtos cadastrados, com filtros de seção, grupo,
  // fornecedor, unidade e, opcionalmente, por loja (necessária para ver
  // preço/oferta/preço2, que são valores por loja). Usa bind parameters
  // (replacements nomeados) em vez de interpolação, diferente do restante
  // deste arquivo, para não expor os filtros a SQL injection.
  async relProdutoListagem(req: any, res: any) {
    const { tenant_id } = req;
    const { secao, grupo, fornecedor, unidade, ativo, descricao, codigoBarras } = req.query;
    const loja = lojaFiltro(req.query);
    const comOferta = req.query.comOferta === "true";
    const comPreco2 = req.query.comPreco2 === "true";

    const where: string[] = ["p.tenant_id = :tenant_id"];
    const replacements: any = { tenant_id };

    if (secao) {
      where.push("p.secao = :secao");
      replacements.secao = secao;
    }
    if (grupo) {
      where.push("p.grupo = :grupo");
      replacements.grupo = grupo;
    }
    if (fornecedor) {
      where.push("p.fornecedor = :fornecedor");
      replacements.fornecedor = fornecedor;
    }
    if (unidade) {
      where.push("p.unidade = :unidade");
      replacements.unidade = unidade;
    }
    if (ativo) {
      where.push("p.ativo = :ativo");
      replacements.ativo = ativo;
    }
    if (descricao) {
      where.push("p.descricao ILIKE :descricao");
      replacements.descricao = `%${descricao}%`;
    }
    if (codigoBarras) {
      where.push("p.codigo_barras ILIKE :codigoBarras");
      replacements.codigoBarras = `%${codigoBarras}%`;
    }

    // Sem loja selecionada não há como exibir um único preço/oferta por
    // produto (o valor varia por loja), então o join só traz valores quando
    // uma loja específica é informada.
    let precoJoin = "LEFT JOIN precos pr ON pr.codigo_produto = p.codigo AND pr.tenant_id = p.tenant_id";
    if (loja) {
      precoJoin += " AND pr.loja = :loja";
      replacements.loja = loja;
    } else {
      precoJoin += " AND false";
    }

    if (comOferta) {
      let sub = "EXISTS (SELECT 1 FROM precos peo WHERE peo.codigo_produto = p.codigo AND peo.tenant_id = p.tenant_id AND peo.oferta > 0";
      if (loja) sub += " AND peo.loja = :loja";
      sub += ")";
      where.push(sub);
    }
    if (comPreco2) {
      let sub = "EXISTS (SELECT 1 FROM precos pep WHERE pep.codigo_produto = p.codigo AND pep.tenant_id = p.tenant_id AND pep.preco2 > 0";
      if (loja) sub += " AND pep.loja = :loja";
      sub += ")";
      where.push(sub);
    }

    const sql = `
      SELECT
        p.codigo, p.codigo_barras, p.descricao, p.unidade,
        p.secao, s.nome AS secao_nome,
        p.grupo, g.nome AS grupo_nome,
        p.fornecedor, f.nome AS fornecedor_nome,
        p.ativo,
        pr.preco, pr.oferta, pr.preco2, pr.preco2_qtd
      FROM produtos p
      LEFT JOIN secaos s ON s.codigo = p.secao AND s.tenant_id = p.tenant_id
      LEFT JOIN grupos g ON g.codigo = p.grupo AND g.codigo_secao = p.secao AND g.tenant_id = p.tenant_id
      LEFT JOIN fornecedors f ON f.codigo = p.fornecedor AND f.tenant_id = p.tenant_id
      ${precoJoin}
      WHERE ${where.join(" AND ")}
      ORDER BY p.codigo ASC
    `;

    try {
      const result = await sequelize.query(sql, { replacements, type: QueryTypes.SELECT });
      res.status(200).json(result);
    } catch (error: any) {
      res.status(400).json({ message: "Erro ao gerar relatório de produtos! " + error.message });
    }
  },
};
