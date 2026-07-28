import ContaPagarTitulo from "./ContaPagarTitulo";
import PagamentoTitulo from "./PagamentoTitulo";

export default class ContaPagarTituloList {
  public readonly items: ContaPagarTitulo[] = [];

  adicionarTitulo(titulo: ContaPagarTitulo): void {
    this.items.push(titulo);
  }

  estornarTitulos() {
    this.items.map((titulo) => {
      titulo.estornar();
    });
  }
  estornar() {
    this.items.map((titulo) => {
      titulo.valorPago = 0;
    });
  }
  cancelarTitulos() {
    this.items.map((titulo) => {
      titulo.cancelar();
    });
  }

  limpar() {
    this.items.length = 0;
  }
  valorTotal(): number {
    return this.items.reduce((total, titulo) => total + titulo.valor, 0);
  }
  valorReceber(): number {
    return this.items.reduce((total, titulo) => total + titulo.valorAPagar(), 0);
  }
  valorPago(): number {
    return this.items.reduce((total, titulo) => total + titulo.valorPago, 0);
  }
  validarLiquidar() {
    if (this.valorTotal() <= 0) throw new Error("Valor total zerado !");
    if (this.valorReceber() <= 0) throw new Error("Valor a receber zerado !");
  }

  registrarPagamento(pagamento: PagamentoTitulo): void {
    if (pagamento.formaPagamento.codigo === "") throw new Error("Selecione a forma de pagamento !");
    if (!pagamento.formaPagamento) throw new Error("Selecione a Forma de pagamento !");
    if (pagamento.valor <= 0) throw new Error("Valor não pode ser 0 ou negativo !");
    if (pagamento.valor > this.valorReceber()) throw new Error("Valor Maior que A Receber");

    let valorRestante = pagamento.valor;

    for (const titulo of this.items) {
      if (valorRestante <= 0) break;

      const valorAPagar = titulo.valorAPagar();
      if (valorAPagar <= 0) continue;

      const valorAplicado = Math.min(valorRestante, valorAPagar);

      const pagamentoParcial = new PagamentoTitulo(valorAplicado, pagamento.formaPagamento);

      titulo.registrarPagamento(pagamentoParcial);
      titulo.atualizarStatus(); // Presumindo que essa função atualiza status para "LIQUIDADO" ou "ABERTO"

      valorRestante -= valorAplicado;
    }
  }
}
