import PagamentoTitulo from "./PagamentoTitulo";

type Status = "ABERTO" | "LIQUIDADO" | "CANCELADO";
export default class ContaPagarTitulo {
  constructor(
    public seq = 0,
    public vencimento = new Date(),
    public valor = 0,
    public valorPago = 0,
    public descricao = "",
    public numeroDocumento = "",
    public fornecedorId = "",
    public lojaId = "",
    public categoriaFinanceiraId = "",
    public subCategoriaFinanceiraId = "",
    public id = "",
    public status: Status = "ABERTO",
    public pagamentos: PagamentoTitulo[] = []
  ) {}
  estornar() {
    this.valorPago = 0;
    this.status = "ABERTO";
  }
  cancelar() {
    this.status = "CANCELADO";
  }
  atualizarStatus() {
    if (this.valorAPagar() <= 0) {
      this.status = "LIQUIDADO";
      return;
    }

    this.status = "ABERTO";
  }

  registrarPagamento(pagamento: PagamentoTitulo) {
    this.pagamentos.push(pagamento); // Presumindo que existe um array this.pagamentos
    this.valorPago += pagamento.valor;
  }

  valorAPagar(): number {
    return this.valor - this.valorPago;
  }
}
