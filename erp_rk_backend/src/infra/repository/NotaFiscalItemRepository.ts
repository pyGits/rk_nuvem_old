import { NotaFiscalItem } from "../entity/NotaFiscalItem";
import DatabaseConnection from "./DatabaseConnection";

export class NotaFiscalItemRepository {
  async get(chave_nota: string, nrItem: number, tenant_id: number) {
    const data = await DatabaseConnection.query("select * from nota_fiscal_entrada_itens where chave_nota = $1 and numero_item = $2 and tenant_id = $3", [chave_nota, nrItem, tenant_id]);
    return data;
  }
  async getByChave(chave_nota: string, tenant_id: number) {
    const data = await DatabaseConnection.queryAll("select * from nota_fiscal_entrada_itens where chave_nota = $1 and tenant_id = $2", [chave_nota, tenant_id]);
    const itens = data.map((row: any) =>
      Object.assign(new NotaFiscalItem(), {
        numeroItem: row.numero_item,
        codigo: row.codigo,
        descricao: row.descricao,
        ean: row.ean,
        ncm: row.ncm,
        cest: row.cest,
        cfop: row.cfop,
        codigoBeneficioFiscal: row.codigo_beneficio_fiscal,
        numeroFCI: row.numero_fci,
        unidadeComercial: row.unidade_comercial,
        valorUnitario: parseFloat(row.valor_unitario),
        unidadeTributavel: row.unidade_tributavel,
        eanTributavel: row.ean_tributavel,
        quantidadeTributavel: parseFloat(row.quantidade_tributavel),
        quantidadeComercial: parseFloat(row.quantidade_comercial),
        valorUnitarioTributavel: parseFloat(row.valor_unitario_tributavel),
        valorOutrasDespesas: parseFloat(row.valor_outras_despesas),
        indicadorTotal: row.indicador_total,
        codigoANP: row.codigo_anp,
        informacoesProduto: row.informacoes_produto,
        pedido: row.pedido,
        numeroItemPedido: row.numero_item_pedido,
        valorProdutos: parseFloat(row.valor_produtos),
        codigo_produto: row.codigo_produto,

        imposto: {
          icms: {
            cst: row.icms_cst,
            baseCalculo: parseFloat(row.icms_base_calculo),
            porcentagemIcms: parseFloat(row.icms_porcentagem_icms),
            porcentagemIcmsST: parseFloat(row.icms_porcentagem_icms_st),
            valorIcms: parseFloat(row.icms_valor_icms),
            baseCalculoIcmsST: parseFloat(row.icms_base_calculo_icms_st),
            valorIcmsST: parseFloat(row.icms_valor_icms_st),
            origem: row.icms_origem,
            csosn: row.icms_csosn,
            porcentagemMVAST: parseFloat(row.icms_porcentagem_mva_st),
            modalidadeBCST: row.icms_modalidade_bcst,
            valorFCP: parseFloat(row.icms_valor_fcp),
            valorFCPST: parseFloat(row.icms_valor_fcp_st),
            valorFCPSTRetido: parseFloat(row.icms_valor_fcpst_retido),
            porcentagemFCP: parseFloat(row.icms_porcentagem_fcp),
            porcentagemFCPST: parseFloat(row.icms_porcentagem_fcpst),
            porcentagemFCPSTRetido: parseFloat(row.icms_porcentagem_fcpst_retido),
            baseCalculoFCP: parseFloat(row.icms_base_calculo_fcp),
            baseCalculoFCPST: parseFloat(row.icms_base_calculo_fcpst),
            baseCalculoFCPSTRetido: parseFloat(row.icms_base_calculo_fcpst_retido),
          },
          ipi: {
            cst: row.ipi_cst,
            baseCalculo: parseFloat(row.ipi_base_calculo),
            valorIPI: parseFloat(row.ipi_valor_ipi),
            porcentagemIPI: parseFloat(row.ipi_porcentagem_ipi),
          },
          pis: {
            cst: row.pis_cst,
            baseCalculo: parseFloat(row.pis_base_calculo),
            valorPIS: parseFloat(row.pis_valor_pis),
            porcentagemPIS: parseFloat(row.pis_porcentagem_pis),
          },
          cofins: {
            cst: row.cofins_cst,
            baseCalculo: parseFloat(row.cofins_base_calculo),
            valorCOFINS: parseFloat(row.cofins_valor_cofins),
            porcentagemCOFINS: parseFloat(row.cofins_porcentagem_cofins),
          },
        },
      })
    );
    return itens;
  }
  async upinsert(item: NotaFiscalItem, chave_nota: string, tenant_id: number) {
    const query = `INSERT INTO nota_fiscal_entrada_itens (
    numero_item, codigo, descricao, ean, ncm, cest, cfop,
    codigo_beneficio_fiscal, numero_fci, unidade_comercial, valor_unitario,
    unidade_tributavel, ean_tributavel, quantidade_tributavel, quantidade_comercial,
    valor_unitario_tributavel, valor_outras_despesas, indicador_total, codigo_anp,
    informacoes_produto, pedido, numero_item_pedido, valor_produtos,

    icms_cst, icms_base_calculo, icms_porcentagem_icms, icms_porcentagem_icms_st,
    icms_valor_icms, icms_base_calculo_icms_st, icms_valor_icms_st, icms_origem,
    icms_csosn, icms_porcentagem_mva_st, icms_modalidade_bcst,
    icms_valor_fcp, icms_valor_fcp_st, icms_valor_fcpst_retido,
    icms_porcentagem_fcp, icms_porcentagem_fcpst, icms_porcentagem_fcpst_retido,
    icms_base_calculo_fcp, icms_base_calculo_fcpst, icms_base_calculo_fcpst_retido,

    ipi_cst, ipi_base_calculo, ipi_valor_ipi, ipi_porcentagem_ipi,

    pis_cst, pis_base_calculo, pis_valor_pis, pis_porcentagem_pis,

    cofins_cst, cofins_base_calculo, cofins_valor_cofins, cofins_porcentagem_cofins,
    tenant_id, chave_nota, codigo_produto
)
VALUES (
    $1,$2,$3,$4,$5,$6,$7,
    $8,$9,$10,$11,
    $12,$13,$14,$15,
    $16,$17,$18,$19,
    $20,$21,$22,$23,

    $24,$25,$26,$27,$28,

    $29,$30,$31,$32,
    $33,$34,$35,$36,
    $37,$38,$39,
    $40,$41,$42,
    $43,$44,$45,
    $46,$47,$48,

    $49,$50,$51,$52,

    $53,$54,$55,$56,$57,$58
)
ON CONFLICT (numero_item, chave_nota, tenant_id) DO UPDATE SET
    codigo = EXCLUDED.codigo,
    descricao = EXCLUDED.descricao,
    ean = EXCLUDED.ean,
    ncm = EXCLUDED.ncm,
    cest = EXCLUDED.cest,
    cfop = EXCLUDED.cfop,
    codigo_beneficio_fiscal = EXCLUDED.codigo_beneficio_fiscal,
    numero_fci = EXCLUDED.numero_fci,
    unidade_comercial = EXCLUDED.unidade_comercial,
    valor_unitario = EXCLUDED.valor_unitario,
    unidade_tributavel = EXCLUDED.unidade_tributavel,
    ean_tributavel = EXCLUDED.ean_tributavel,
    quantidade_tributavel = EXCLUDED.quantidade_tributavel,
    quantidade_comercial = EXCLUDED.quantidade_comercial,
    valor_unitario_tributavel = EXCLUDED.valor_unitario_tributavel,
    valor_outras_despesas = EXCLUDED.valor_outras_despesas,
    indicador_total = EXCLUDED.indicador_total,
    codigo_anp = EXCLUDED.codigo_anp,
    informacoes_produto = EXCLUDED.informacoes_produto,
    pedido = EXCLUDED.pedido,
    numero_item_pedido = EXCLUDED.numero_item_pedido,
    valor_produtos = EXCLUDED.valor_produtos,

    icms_cst = EXCLUDED.icms_cst,
    icms_base_calculo = EXCLUDED.icms_base_calculo,
    icms_porcentagem_icms = EXCLUDED.icms_porcentagem_icms,
    icms_porcentagem_icms_st = EXCLUDED.icms_porcentagem_icms_st,
    icms_valor_icms = EXCLUDED.icms_valor_icms,
    icms_base_calculo_icms_st = EXCLUDED.icms_base_calculo_icms_st,
    icms_valor_icms_st = EXCLUDED.icms_valor_icms_st,
    icms_origem = EXCLUDED.icms_origem,
    icms_csosn = EXCLUDED.icms_csosn,
    icms_porcentagem_mva_st = EXCLUDED.icms_porcentagem_mva_st,
    icms_modalidade_bcst = EXCLUDED.icms_modalidade_bcst,
    icms_valor_fcp = EXCLUDED.icms_valor_fcp,
    icms_valor_fcp_st = EXCLUDED.icms_valor_fcp_st,
    icms_valor_fcpst_retido = EXCLUDED.icms_valor_fcpst_retido,
    icms_porcentagem_fcp = EXCLUDED.icms_porcentagem_fcp,
    icms_porcentagem_fcpst = EXCLUDED.icms_porcentagem_fcpst,
    icms_porcentagem_fcpst_retido = EXCLUDED.icms_porcentagem_fcpst_retido,
    icms_base_calculo_fcp = EXCLUDED.icms_base_calculo_fcp,
    icms_base_calculo_fcpst = EXCLUDED.icms_base_calculo_fcpst,
    icms_base_calculo_fcpst_retido = EXCLUDED.icms_base_calculo_fcpst_retido,

    ipi_cst = EXCLUDED.ipi_cst,
    ipi_base_calculo = EXCLUDED.ipi_base_calculo,
    ipi_valor_ipi = EXCLUDED.ipi_valor_ipi,
    ipi_porcentagem_ipi = EXCLUDED.ipi_porcentagem_ipi,

    pis_cst = EXCLUDED.pis_cst,
    pis_base_calculo = EXCLUDED.pis_base_calculo,
    pis_valor_pis = EXCLUDED.pis_valor_pis,
    pis_porcentagem_pis = EXCLUDED.pis_porcentagem_pis,

    cofins_cst = EXCLUDED.cofins_cst,
    cofins_base_calculo = EXCLUDED.cofins_base_calculo,
    cofins_valor_cofins = EXCLUDED.cofins_valor_cofins,
    cofins_porcentagem_cofins = EXCLUDED.cofins_porcentagem_cofins,
    codigo_produto = EXCLUDED.codigo_produto
;`;

    const values = [
      Number(item.numeroItem) || 0,
      item.codigo || "",
      item.descricao || "",
      item.ean || "",
      item.ncm || "",
      item.cest || "",
      item.cfop || "",
      item.codigoBeneficioFiscal || "",
      item.numeroFCI || "",
      item.unidadeComercial || "",
      item.valorUnitario || 0,
      item.unidadeTributavel || "",
      item.eanTributavel || "",
      item.quantidadeTributavel || 0,
      item.quantidadeComercial || 0,
      item.valorUnitarioTributavel || 0,
      item.valorOutrasDespesas || 0,
      item.indicadorTotal || 0,
      item.codigoANP || "",
      item.informacoesProduto || "",
      item.pedido || "",
      item.numeroItemPedido || 0,
      item.valorProdutos || 0,

      item.imposto?.icms?.cst || "",
      item.imposto?.icms?.baseCalculo || 0,
      item.imposto?.icms?.porcentagemIcms || 0,
      item.imposto?.icms?.porcentagemIcmsST || 0,
      item.imposto?.icms?.valorIcms || 0,
      item.imposto?.icms?.baseCalculoIcmsST || 0,
      item.imposto?.icms?.valorIcmsST || 0,
      item.imposto?.icms?.origem || "",
      item.imposto?.icms?.csosn || "",
      item.imposto?.icms?.porcentagemMVAST || 0,
      item.imposto?.icms?.modalidadeBCST || "",
      item.imposto?.icms?.valorFCP || 0,
      item.imposto?.icms?.valorFCPST || 0,
      item.imposto?.icms?.valorFCPSTRetido || 0,
      item.imposto?.icms?.porcentagemFCP || 0,
      item.imposto?.icms?.porcentagemFCPST || 0,
      item.imposto?.icms?.porcentagemFCPSTRetido || 0,
      item.imposto?.icms?.baseCalculoFCP || 0,
      item.imposto?.icms?.baseCalculoFCPST || 0,
      item.imposto?.icms?.baseCalculoFCPSTRetido || 0,

      item.imposto?.ipi?.cst || "",
      item.imposto?.ipi?.baseCalculo || 0,
      item.imposto?.ipi?.valorIPI || 0,
      item.imposto?.ipi?.porcentagemIPI || 0,

      item.imposto?.pis?.cst || "",
      item.imposto?.pis?.baseCalculo || 0,
      item.imposto?.pis?.valorPIS || 0,
      item.imposto?.pis?.porcentagemPIS || 0,

      item.imposto?.cofins?.cst || "",
      item.imposto?.cofins?.baseCalculo || 0,
      item.imposto?.cofins?.valorCOFINS || 0,
      item.imposto?.cofins?.porcentagemCOFINS || 0,
      tenant_id,
      chave_nota,
      item.codigo_produto,
    ];
    await DatabaseConnection.query(query, values);
  }
}
