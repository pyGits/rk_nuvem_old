import ContaPagar from "../ContaPagar";
import ContaPagarTituloListFactory from "./ContaPagarTituloListFactory";

export default class ContaPagarFactory {
  static create(data: any) {
    const titulos = ContaPagarTituloListFactory.createList(data.titulos);
    const conta = new ContaPagar(
      data.lojaId,
      data.fornecedorId,
      data.numeroDocumento,
      new Date(data.dataVencimento),
      Number(data.valorNominal),
      Number(data.acrescimo),
      Number(data.desconto),
      Number(data.parcelas),
      Number(data.intervalo),
      titulos,
      data.descricao,
      data.tipoIntervalo,
      data.codigo,
      new Date(data.dataEmissao),
      undefined,
      data.categoriaFinanceiraList
    );
    return conta;
  }
}
