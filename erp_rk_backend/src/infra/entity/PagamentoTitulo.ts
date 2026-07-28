import FormaPagamento from "./FormaPagamento";

export default class PagamentoTitulo {
  constructor(public valor: number, public formaPagamento: FormaPagamento) {}
}
