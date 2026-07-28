import FormaPagamento from "./FormaPagamento";

export default class PagamentoTitulo {
  constructor(public valor = 0, public formaPagamento: FormaPagamento = new FormaPagamento()) {}
}
