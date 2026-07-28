import EstoqueModel from "./EstoqueModel";

export default class EstoqueCollectionModel {
  items: EstoqueModel[];
  constructor(estoques: EstoqueModel[] = []) {
    this.items = estoques;
  }
  atualizarEstoque(estoque: EstoqueModel) {
    this.items
      .find((e) => e.loja.codigo === estoque.loja.codigo)
      ?.atualizar(estoque);
  }
  static fromDatabase(estoques: any[]): EstoqueCollectionModel {
    return new EstoqueCollectionModel(
      estoques.map((e) => EstoqueModel.fromDatabase(e))
    );
  }
}
