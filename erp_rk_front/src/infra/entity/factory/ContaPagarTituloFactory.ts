import ContaPagarTitulo from "../ContaPagarTitulo";

export default class ContaPagarTituloFactory {
  static create(data: any) {
    return new ContaPagarTitulo(data.seq, data.vencimento, data.valor, data.valorPago, data.descricao, data.numeroDocumento, data.fornecedorId, data.lojaId, data.categoriaFinanceiraId, data.subCategoriaFinanceiraId, data.id, data.status, data.pagamentos);
  }
}
