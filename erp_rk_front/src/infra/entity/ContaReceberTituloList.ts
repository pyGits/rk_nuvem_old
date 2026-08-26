import ContaReceberTitulo from "./ContaReceberTitulo";
import RecebimentoTitulo from "./RecebimentoTitulo";

export default class ContaReceberTituloList {
  public items: ContaReceberTitulo[] = [];

  adicionarTitulo(titulo: ContaReceberTitulo): void {
    this.items.push(titulo);
  }

  limpar() {
    this.items = [];
  }

  ids(): string[] {
    return this.items.map((titulo) => titulo.id);
  }

  valorTotal(): number {
    return this.items.reduce((total, titulo) => total + Number(titulo.valor || 0), 0);
  }

  valorReceber(): number {
    return this.items.reduce((total, titulo) => total + titulo.valorAReceber(), 0);
  }

  valorRecebido(): number {
    return this.items.reduce((total, titulo) => total + titulo.valorRecebido(), 0);
  }

  // Mesmas validações do backend, aplicadas antes de chamar a API para o
  // usuário receber o erro na hora.
  validarReceber() {
    if (this.items.length === 0) throw new Error("Nenhum título selecionado !");
    const cancelado = this.items.find((titulo) => titulo.cancelado === 1);
    if (cancelado) throw new Error(`Título ${cancelado.codigo} está cancelado !`);
    if (this.valorReceber() <= 0) throw new Error("Títulos selecionados já estão liquidados !");
  }

  validarEstornar() {
    if (this.items.length === 0) throw new Error("Nenhum título selecionado !");
    if (this.valorRecebido() <= 0) throw new Error("Nenhum recebimento para estornar !");
  }

  validarCancelar() {
    if (this.items.length === 0) throw new Error("Nenhum título selecionado !");
  }

  validarRecebimento(recebimento: RecebimentoTitulo) {
    this.validarReceber();
    if (String(recebimento.formaPagamento || "").trim() === "") throw new Error("Selecione a forma de pagamento !");
    if (!recebimento.dataPagamento) throw new Error("Informe a data do recebimento !");
    if (recebimento.valor <= 0) throw new Error("Valor não pode ser 0 ou negativo !");
    if (Number(recebimento.abatimento().toFixed(2)) > Number(this.valorReceber().toFixed(2))) throw new Error("Valor recebido maior que o saldo dos títulos !");
  }
}
