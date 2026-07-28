import LojaModel from "./LojaModel";

export default class EstoqueModel {
  estoque_minimo: number;
  estoque_maximo: number;
  estoque: number;
  ultima_saida: Date;
  loja: LojaModel;
  constructor(
    estoque_minimo: number = 0,
    estoque_maximo: number = 0,
    estoque: number = 0,
    ultima_saida: Date = new Date(),
    loja: LojaModel = new LojaModel()
  ) {
    this.estoque_minimo = estoque_minimo;
    this.estoque_maximo = estoque_maximo;
    this.estoque = estoque;
    this.ultima_saida = ultima_saida;
    this.loja = loja;
  }
  atualizar(estoque: EstoqueModel) {
    if (estoque.estoque_minimo > estoque.estoque_maximo)
      throw new Error("Estoque Mínimo não pode ser maior que máximo !");

    this.estoque = estoque.estoque;
    this.estoque_minimo = estoque.estoque_minimo;
    this.estoque_maximo = estoque.estoque_maximo;
    this.ultima_saida = estoque.ultima_saida;
    this.loja = estoque.loja;
  }
  static fromDatabase(row: any): EstoqueModel {
    const loja = new LojaModel(row.loja);
    return new EstoqueModel(
      row.estoque_minimo,
      row.estoque_maximo,
      row.estoque,
      row.ultima_saida,
      loja
    );
  }
}
