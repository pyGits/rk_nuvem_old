import SubCategoriaFinanceira from "../SubCategoriaFinanceira";

export default class SubCategoriaFinanceiraFactory {
  static create(body: any) {
    return new SubCategoriaFinanceira(body.codigo, body.codigo_categoria, body.nome, body.tipo);
  }
}
