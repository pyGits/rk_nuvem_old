import ContaPagar from "../ContaPagar";
import Fornecedor from "../Fornecedor";
import { NotaFiscal } from "../NotaFiscal";
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
      data.categoriaFinanceiraId,
      data.subCategoriaFinanceiraId
    );
    return conta;
  }

  static createFromNota(nota: NotaFiscal) {
    const conta = new ContaPagar(
      nota.loja.codigo,
      nota.fornecedor.codigo,
      nota.protocolo.chave,
      undefined,
      nota.total.valorNota,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      "Nota Nr:" + nota.nrNota
    );
    return conta;
  }
}
