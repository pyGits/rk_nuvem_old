import sequelize from "../database/config";
import { QueryTypes, Sequelize } from "sequelize";
import Loja from "../models/Loja";

export default {
  async relPainelLoja(req: any, res: any) {
    const { tenant_id } = req;
    const lojas = await Loja.findAll({ where: { tenant_id: tenant_id } });
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

    if (!dtInicio || !dtFim) {
      res.status(400).json({ error: "data início e fim são obrigatórios" });
      return;
    }

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
  },

  async relPainelProduto(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

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

GROUP BY p.descricao, v.codigo_produto, p.codigo_barras;

    `);

    res.status(200).json(result[0]);
  },
  async relPainelCaixa(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

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
    GROUP BY l.codigo,l.nome, v.caixa;

    `);

    res.status(200).json(result[0]);
  },
  async relPainelFinalizadora(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

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

    group by (f.codigo,f.nome,l.codigo,
    l.nome)


    `);

    res.status(200).json(result[0]);
  },

  async relPainelSecoes(req: any, res: any) {
    const { tenant_id } = req;

    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

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
    GROUP BY s.codigo, s.nome;



    `);

    res.status(200).json(result[0]);
  },
  async relPainelCupom(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

    const result = await sequelize.query(`select * from vendas v 
    where v.tenant_id = ${tenant_id}
    and v.data >= '${dtInicio}'
    and v.data <= '${dtFim}'    
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
};
