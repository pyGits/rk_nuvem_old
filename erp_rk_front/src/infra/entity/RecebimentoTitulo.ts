// Uma baixa do título. Juros e multa são cobrados a mais do cliente (entram em
// caixa mas não abatem o título); o desconto abate o saldo sem entrar em caixa.
export default class RecebimentoTitulo {
  constructor(
    public valor = 0,
    public formaPagamento = "",
    public juros = 0,
    public multa = 0,
    public desconto = 0,
    public dataPagamento = "",
    public id = "",
    public usuario = "",
    public estornado = 0,
    // Vem resolvido do backend: a coluna guarda o código ("01"), que não diz
    // nada para quem lê a tela.
    public formaPagamentoNome = ""
  ) {}

  valorEmCaixa(): number {
    return Number(this.valor) + Number(this.juros) + Number(this.multa);
  }

  abatimento(): number {
    return Number(this.valor) + Number(this.desconto);
  }
}
