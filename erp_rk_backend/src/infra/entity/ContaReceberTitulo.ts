import RecebimentoTitulo from "./RecebimentoTitulo";

type Status = "ABERTO" | "LIQUIDADO" | "CANCELADO";

// Um titulo e uma parcela. Vem assim do PDV (uma linha por parcela em
// CUPOM_CREDIARIO) e e assim que a tela lista e recebe.
export default class ContaReceberTitulo {
  constructor(
    public id = "",
    public codigo = "",
    public lojaId = 0,
    public clienteCodigo = "",
    public clienteCpf = "",
    public codigoCupom = "",
    public numero = "",
    public prestacao = 1,
    public caixa = "",
    public vendedor = "",
    // Datas trafegam como 'YYYY-MM-DD': o Postgres grava date e o axios nao
    // converte para UTC no caminho de volta, que e onde o dia vira o anterior.
    public dataEmissao = "",
    public dataVencimento = "",
    public valor = 0,
    public descricao = "",
    public origem = "PDV",
    public cancelado = 0,
    public status: Status = "ABERTO",
    public recebimentos: RecebimentoTitulo[] = []
  ) {}

  recebimentosValidos(): RecebimentoTitulo[] {
    return this.recebimentos.filter((recebimento) => recebimento.estornado !== 1);
  }

  valorRecebido(): number {
    return this.recebimentosValidos().reduce((total, recebimento) => total + Number(recebimento.valor || 0), 0);
  }

  valorDesconto(): number {
    return this.recebimentosValidos().reduce((total, recebimento) => total + Number(recebimento.desconto || 0), 0);
  }

  valorAcrescimo(): number {
    return this.recebimentosValidos().reduce((total, recebimento) => total + Number(recebimento.juros || 0) + Number(recebimento.multa || 0), 0);
  }

  valorAReceber(): number {
    if (this.cancelado === 1) return 0;
    const saldo = Number(this.valor) - this.valorRecebido() - this.valorDesconto();
    return saldo > 0 ? saldo : 0;
  }

  registrarRecebimento(recebimento: RecebimentoTitulo) {
    this.recebimentos.push(recebimento);
  }

  atualizarStatus() {
    if (this.cancelado === 1) {
      this.status = "CANCELADO";
      return;
    }
    this.status = this.valorAReceber() <= 0 ? "LIQUIDADO" : "ABERTO";
  }

  estornar() {
    this.recebimentos.forEach((recebimento) => (recebimento.estornado = 1));
    this.atualizarStatus();
  }

  cancelar() {
    this.cancelado = 1;
    this.status = "CANCELADO";
  }

  validarRecebimento() {
    if (this.cancelado === 1) throw new Error(`Título ${this.codigo} está cancelado !`);
    if (this.valorAReceber() <= 0) throw new Error(`Título ${this.codigo} já está liquidado !`);
  }
}
