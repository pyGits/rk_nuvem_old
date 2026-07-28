export enum TipoCategoria {
  DESPESA = "DESPESA",
  RECEITA = "RECEITA",
}

export default class SubCategoriaFinanceira {
  constructor(public codigo: string = "", public codigo_categoria: string = "", public nome: string = "", public tipo: TipoCategoria = TipoCategoria.DESPESA) {}
}
