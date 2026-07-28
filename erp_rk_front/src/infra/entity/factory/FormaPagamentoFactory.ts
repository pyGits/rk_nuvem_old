import FormaPagamento from "../FormaPagamento";

export default class FormaPagamentoFactory {
  static create(body: any) {
    return new FormaPagamento(body.codigo, body.nome);
  }
  static createList(list: any[]): FormaPagamento[] {
    return list.map((categoria) => {
      return new FormaPagamento(categoria.codigo, categoria.nome);
    });
  }
}
