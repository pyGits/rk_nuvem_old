import CategoriaFinanceira from "../CategoriaFinanceira";

export default class CategoriaFinanceiraFactory {
  static create(body: any) {
    return new CategoriaFinanceira(body.codigo, body.nome);
  }
}
