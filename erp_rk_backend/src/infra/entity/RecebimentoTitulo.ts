// Uma baixa lancada no titulo. Juros e multa sao cobrados a mais do cliente
// (entram em caixa mas nao abatem o titulo); o desconto abate o saldo sem
// entrar em caixa.
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
    // Resolvido na leitura a partir de forma_pagamento. A coluna guarda o
    // codigo ("01"), que nao diz nada para quem le a tela ou o recibo.
    public formaPagamentoNome = ""
  ) {}

  // Quanto o cliente efetivamente pagou.
  valorEmCaixa(): number {
    return this.valor + this.juros + this.multa;
  }

  // Quanto saiu do saldo devedor do titulo.
  abatimento(): number {
    return this.valor + this.desconto;
  }
}
