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

// Filtros de venda do painel. Sobem uma vez no topo da tela e valem para todas
// as abas: as agregadas (Lojas, Caixas, Produtos, Seção, Finalizadora) somam no
// banco, então quem os aplica é a consulta, não o front.
//
// Pares [param da query, coluna de vendas]. Todos casam por "contém", que é a
// semântica que a aba Cupom sempre teve quando filtrava na tela.
const CAMPOS_VENDA: Array<[string, string]> = [
  ["numero", "numero"],
  ["caixa", "caixa"],
  ["cpfConsumidor", "cpf_consumidor"],
  ["vendedor", "vendedor"],
  ["valorTotal", "valor_total"],
  ["xmlVenda", "xml_venda"],
];

function texto(query: any, param: string): string {
  const valor = query[param];
  return valor === undefined || valor === null ? "" : String(valor).trim();
}

// O restante deste arquivo interpola os parâmetros direto no SQL. Os filtros
// abaixo vêm digitados pelo usuário, então passam por escape.
function escapar(valor: string): string {
  return sequelize.escape(valor);
}

// CPF do cupom e CNPJ/CPF do cadastro podem estar com ou sem máscara.
function soDigitos(expr: string): string {
  return `regexp_replace(coalesce(${expr}, ''), '[^0-9]', '', 'g')`;
}

/** Condições de texto sobre a tabela vendas, no alias informado. */
function condicoesVenda(query: any, alias: string): string {
  return CAMPOS_VENDA.map(([param, coluna]) => {
    const valor = texto(query, param);
    if (!valor) return "";
    return ` and cast(${alias}.${coluna} as text) ilike ${escapar(`%${valor}%`)}`;
  }).join("");
}

/**
 * Filtro de cliente. O cupom pode apontar para o cadastro pelo código ou só
 * trazer o CPF do consumidor, então os dois caminhos valem.
 */
function condicaoCliente(query: any, tenant_id: number, alias: string): string {
  const cliente = texto(query, "cliente");
  if (!cliente) return "";
  return ` and exists (select 1 from clientes cfil
    where cfil.tenant_id = ${tenant_id} and cfil.codigo = ${escapar(cliente)}
      and (${alias}.codigo_cliente = cfil.codigo
        or (coalesce(${alias}.cpf_consumidor, '') <> ''
            and ${soDigitos(`${alias}.cpf_consumidor`)} = ${soDigitos("cfil.cnpjcpf")})))`;
}

/**
 * Situação: "" todos, "0" normais, "1" cancelados. Nas tabelas filhas o alias
 * aponta para o item ou para a forma de pagamento, que é onde essas consultas
 * já filtravam cancelamento.
 */
function condicaoSituacao(query: any, alias: string): string {
  const cancelado = texto(query, "cancelado");
  if (cancelado === "0") return ` and ${alias}.cancelado = 0`;
  if (cancelado === "1") return ` and ${alias}.cancelado = 1`;
  return "";
}

/** Cupons com ao menos uma forma de pagamento na finalizadora escolhida. */
function condicaoFinalizadora(query: any, tenant_id: number, alias: string, campoCupom: string): string {
  const finalizadora = texto(query, "finalizadora");
  if (!finalizadora) return "";
  return ` and exists (select 1 from venda_formas vffil
    where vffil.tenant_id = ${tenant_id}
      and vffil.data = ${alias}.data and vffil.caixa = ${alias}.caixa
      and vffil.loja = ${alias}.loja and vffil.codigo_cupom = ${alias}.${campoCupom}
      and vffil.finalizadora = ${escapar(finalizadora)})`;
}

/** Filtros de venda para consultas que rodam sobre a própria tabela vendas. */
function filtrosVenda(query: any, tenant_id: number, alias: string): string {
  return (
    condicoesVenda(query, alias) +
    condicaoCliente(query, tenant_id, alias) +
    condicaoSituacao(query, alias) +
    condicaoFinalizadora(query, tenant_id, alias, "codigo")
  );
}

/**
 * Os mesmos filtros para venda_items/venda_formas, que só guardam a chave do
 * cupom: o que é coluna de vendas vira um EXISTS.
 *
 * A situação, por padrão, continua sendo lida da própria linha — é o que essas
 * consultas sempre fizeram, e trocar por cancelamento de cupom mudaria os
 * totais das abas agregadas. No analítico, onde a linha é o detalhe de um
 * cupom já filtrado e o item cancelado aparece marcado na tela, ela vale no
 * nível do cupom (situacaoNoCupom).
 */
function filtrosVendaFilho(query: any, tenant_id: number, alias: string, opcoes: { situacaoNoCupom?: boolean } = {}): string {
  const doCupom =
    condicoesVenda(query, "vfil") +
    condicaoCliente(query, tenant_id, "vfil") +
    (opcoes.situacaoNoCupom ? condicaoSituacao(query, "vfil") : "");

  const existsVenda = doCupom
    ? ` and exists (select 1 from vendas vfil
    where vfil.tenant_id = ${tenant_id}
      and vfil.data = ${alias}.data and vfil.caixa = ${alias}.caixa
      and vfil.loja = ${alias}.loja and vfil.codigo = ${alias}.codigo_cupom
      ${doCupom})`
    : "";

  return (
    existsVenda +
    (opcoes.situacaoNoCupom ? "" : condicaoSituacao(query, alias)) +
    condicaoFinalizadora(query, tenant_id, alias, "codigo_cupom")
  );
}

/**
 * Cliente do cupom: pelo código gravado na venda ou, quando o PDV só registrou
 * o CPF do consumidor, pelo CNPJ/CPF do cadastro. LATERAL com limit 1 para um
 * cadastro duplicado não multiplicar a linha do cupom.
 */
function joinClienteDoCupom(tenant_id: number, alias: string): string {
  return `left join lateral (
      select c.codigo, c.nome, c.cnpjcpf
      from clientes c
      where c.tenant_id = ${tenant_id}
        and (
          (coalesce(${alias}.codigo_cliente, '') <> '' and c.codigo = ${alias}.codigo_cliente)
          or (coalesce(${alias}.codigo_cliente, '') = ''
              and coalesce(${alias}.cpf_consumidor, '') <> ''
              and ${soDigitos("c.cnpjcpf")} = ${soDigitos(`${alias}.cpf_consumidor`)})
        )
      limit 1
    ) cli on true`;
}

export default {
  async relPainelLoja(req: any, res: any) {
    const { tenant_id } = req;
    const filtroLoja = lojaFiltro(req.query);
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const filtros = filtrosVenda(req.query, tenant_id, "v");

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
            COALESCE(SUM(v.valor_total), 0) as venda,
            COALESCE(SUM(v.valor_custo), 0) as venda_custo,
            COALESCE(SUM(v.valor_total) / COUNT(*), 0) as ticket_medio
          FROM vendas v
          WHERE
            v.tenant_id = ${tenant_id}
            AND v.loja = ${loja.codigo}
            AND v.data >= '${dtInicio}'
            AND v.data <= '${dtFim}'
            ${filtros}
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
    const filtros = filtrosVendaFilho(req.query, tenant_id, "v");

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
    WHERE v.tenant_id = ${tenant_id}
    AND p.tenant_id = ${tenant_id}
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    ${filtroLoja}
    ${filtros}

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
    const filtros = filtrosVenda(req.query, tenant_id, "v");

    const result = await sequelize.query(`
    SELECT l.codigo,l.nome AS nome_loja, v.caixa,
    COUNT(*) as qtd_clientes,
    COALESCE(SUM(v.valor_total), 0) as venda,
    COALESCE(SUM(v.valor_custo), 0) as venda_custo,
    CAST(SUM(v.valor_total - v.valor_custo) AS numeric(10,2)) AS venda_liquida
    FROM vendas v
    JOIN lojas l ON v.loja = cast(l.codigo as integer)
    where l.tenant_id=${tenant_id} and v.tenant_id=${tenant_id}
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    ${filtroLoja}
    ${filtros}
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
    const filtros = filtrosVendaFilho(req.query, tenant_id, "v");

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
    ${filtroLoja}
    ${filtros}

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
    const filtros = filtrosVendaFilho(req.query, tenant_id, "v");

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
    AND v.data >= '${dtInicio}'
    AND v.data <= '${dtFim}'
    ${filtroLoja}
    ${filtros}
    GROUP BY s.codigo, s.nome;



    `);

    res.status(200).json(result[0]);
  },
  // O cupom sai com o cliente resolvido (cliente_codigo/cliente_nome): quando o
  // PDV só gravou o CPF do consumidor, ele é casado com o cadastro pelo
  // CNPJ/CPF, para o relatório mostrar de quem é a compra.
  async relPainelCupom(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLoja = loja ? `and v.loja = ${loja}` : "";
    const filtros = filtrosVenda(req.query, tenant_id, "v");

    const result = await sequelize.query(`select v.*,
    cli.codigo as cliente_codigo,
    cli.nome as cliente_nome,
    cli.cnpjcpf as cliente_cnpjcpf
    from vendas v
    ${joinClienteDoCupom(tenant_id, "v")}
    where v.tenant_id = ${tenant_id}
    and v.data >= '${dtInicio}'
    and v.data <= '${dtFim}'
    ${filtroLoja}
    ${filtros}
    `);
    res.status(200).json(result[0]);
  },

  // Relatório analítico: itens e formas de pagamento de todos os cupons do
  // período, para montar o cupom a cupom na tela sem uma chamada por cupom.
  // O front agrupa pelo par (data, caixa, codigo_cupom, loja).
  async relPainelCupomAnalitico(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    const loja = lojaFiltro(req.query);
    const filtroLojaItens = loja ? `and vi.loja = ${loja}` : "";
    const filtroLojaFormas = loja ? `and vf.loja = ${loja}` : "";
    const filtrosItens = filtrosVendaFilho(req.query, tenant_id, "vi", { situacaoNoCupom: true });
    const filtrosFormas = filtrosVendaFilho(req.query, tenant_id, "vf", { situacaoNoCupom: true });

    const itens = await sequelize.query(`select vi.data, vi.codigo_cupom, vi.caixa, vi.loja,
    vi.item, p.codigo_barras, p.descricao,
    vi.unidade, vi.qtde, vi.valor_unitario, vi.valor_desconto, vi.valor_acrescimo, vi.valor_total,
    vi.cancelado
    from venda_items vi
    join produtos p on p.codigo = vi.codigo_produto and p.tenant_id = vi.tenant_id
    where vi.tenant_id = ${tenant_id}
    and vi.data >= '${dtInicio}'
    and vi.data <= '${dtFim}'
    ${filtroLojaItens}
    ${filtrosItens}
    order by vi.data, vi.caixa, vi.codigo_cupom, vi.item
    `);

    const formasPagamento = await sequelize.query(`select vf.data, vf.codigo_cupom, vf.caixa, vf.loja,
    vf.finalizadora as codigo_finalizadora, f.nome as descricao,
    vf.valor, vf.valor_troco, vf.prestacao, vf.cancelado
    from venda_formas vf
    left join finalizadoras f on f.codigo = vf.finalizadora and f.tenant_id = vf.tenant_id
    where vf.tenant_id = ${tenant_id}
    and vf.data >= '${dtInicio}'
    and vf.data <= '${dtFim}'
    ${filtroLojaFormas}
    ${filtrosFormas}
    order by vf.data, vf.caixa, vf.codigo_cupom, vf.prestacao
    `);

    res.status(200).json({ itens: itens[0], formasPagamento: formasPagamento[0] });
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
    const replacements = { tenant_id, data, codigo, caixa, loja };

    const venda = await sequelize.query(
      `
    select vi.item,p.codigo_barras,p.descricao,
    vi.unidade,vi.qtde,vi.valor_unitario,vi.valor_desconto,vi.valor_acrescimo,vi.valor_total,
    vi.cancelado
    from venda_items vi
    join produtos p on vi.codigo_produto = p.codigo
    where p.tenant_id=:tenant_id and vi.tenant_id=:tenant_id
    and vi.data=:data and vi.codigo_cupom=:codigo
    and vi.caixa=:caixa and vi.loja=:loja
    order by vi.item
    `,
      { replacements }
    );

    const formasPagamento = await sequelize.query(
      `
    select vf.finalizadora as codigo_finalizadora, f.nome as descricao,
    vf.valor, vf.valor_troco, vf.prestacao, vf.cancelado
    from venda_formas vf
    left join finalizadoras f on f.codigo = vf.finalizadora and f.tenant_id = :tenant_id
    where vf.tenant_id=:tenant_id
    and vf.data=:data and vf.codigo_cupom=:codigo
    and vf.caixa=:caixa and vf.loja=:loja
    order by vf.prestacao
    `,
      { replacements }
    );

    if (!venda) {
      res.status(400).json({ message: "Venda não encontrada" });
    }
    res.status(200).json({ itens: venda[0], formasPagamento: formasPagamento[0] });
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
