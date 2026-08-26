import ContaReceberTitulo from "./ContaReceberTitulo";
import RecebimentoTitulo from "./RecebimentoTitulo";

function arredondar(valor: number): number {
  return Number(valor.toFixed(2));
}

export default class ContaReceberTituloList {
  public readonly items: ContaReceberTitulo[] = [];

  adicionarTitulo(titulo: ContaReceberTitulo): void {
    this.items.push(titulo);
  }

  limpar() {
    this.items.length = 0;
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

  estornarTitulos() {
    this.items.forEach((titulo) => titulo.estornar());
  }

  cancelarTitulos() {
    this.items.forEach((titulo) => titulo.cancelar());
  }

  validarReceber() {
    if (this.items.length === 0) throw new Error("Nenhum título selecionado !");
    this.items.forEach((titulo) => titulo.validarRecebimento());
  }

  // O abatimento (valor recebido + desconto concedido) e consumido titulo a
  // titulo, na ordem em que vieram - vencimento mais antigo primeiro. Desconto,
  // juros e multa sao rateados na mesma proporcao do que cada titulo absorveu,
  // para a soma dos recebimentos gravados fechar com o que foi digitado.
  registrarRecebimento(recebimento: RecebimentoTitulo) {
    this.validarReceber();
    if (recebimento.valor <= 0) throw new Error("Valor do recebimento não pode ser 0 ou negativo !");

    const abatimentoTotal = recebimento.abatimento();
    if (arredondar(abatimentoTotal) > arredondar(this.valorReceber())) throw new Error("Valor recebido maior que o saldo dos títulos !");

    let restante = abatimentoTotal;

    for (const titulo of this.items) {
      if (restante <= 0) break;

      const saldo = titulo.valorAReceber();
      if (saldo <= 0) continue;

      const abatimentoTitulo = Math.min(saldo, restante);
      const proporcao = abatimentoTitulo / abatimentoTotal;
      const desconto = arredondar(recebimento.desconto * proporcao);

      titulo.registrarRecebimento(
        new RecebimentoTitulo(
          arredondar(abatimentoTitulo - desconto),
          recebimento.formaPagamento,
          arredondar(recebimento.juros * proporcao),
          arredondar(recebimento.multa * proporcao),
          desconto,
          recebimento.dataPagamento,
          "",
          recebimento.usuario
        )
      );
      titulo.atualizarStatus();

      restante -= abatimentoTitulo;
    }
  }
}
