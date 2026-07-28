import CategoriaFinanceira from "../CategoriaFinanceira";

export default class CategoriaFinanceiraFactory {
  static create(body: any) {
    return new CategoriaFinanceira(body.codigo, body.nome);
  }
  static createList(list: any[]): CategoriaFinanceira[] {
    return list.map((categoria) => {
      return new CategoriaFinanceira(categoria.codigo, categoria.nome);
    });
  }
}
