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
  validate() {
    if (this.id.trim() === "") throw new Error("Título sem ID");
    if (this.valor <= this.valorPago) throw new Error("Valor do Título não pode ser menor ou igual que valor pago, Liquide o Título");
  }
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
