import SubCategoriaFinanceira from "../SubCategoriaFinanceira";

export default class SubCategoriaFinanceiraFactory {
  static create(body: any) {
    return new SubCategoriaFinanceira(body.codigo, body.codigo_categoria, body.nome);
  }
  static createList(list: any[]): SubCategoriaFinanceira[] {
    return list.map((categoria) => {
      return new SubCategoriaFinanceira(categoria.codigo, categoria.codigo_categoria, categoria.nome, categoria.tipo);
    });
  }
}
