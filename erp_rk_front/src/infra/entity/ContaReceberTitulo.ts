import RecebimentoTitulo from "./RecebimentoTitulo";

type Status = "ABERTO" | "LIQUIDADO" | "CANCELADO";

// Um título é uma parcela: é assim que o crediário nasce no PDV (uma linha por
// parcela) e é assim que a tela lista e recebe.
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
    public dataEmissao = "",
    public dataVencimento = "",
    public valor = 0,
    public descricao = "",
    public origem = "PDV",
    public cancelado = 0,
    public status: Status = "ABERTO",
    public recebimentos: RecebimentoTitulo[] = [],
    // Vem resolvido do backend. Antes o nome era montado no navegador a partir
    // do store de clientes, o que não funciona para cliente que só existe no PDV.
    public clienteNome = ""
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

  vencido(): boolean {
    if (this.status !== "ABERTO" || !this.dataVencimento) return false;
    return String(this.dataVencimento).substring(0, 10) < new Date().toISOString().substring(0, 10);
  }

  diasAtraso(): number {
    if (!this.vencido()) return 0;
    const vencimento = new Date(`${String(this.dataVencimento).substring(0, 10)}T00:00:00`).getTime();
    return Math.floor((Date.now() - vencimento) / (1000 * 60 * 60 * 24));
  }
}
