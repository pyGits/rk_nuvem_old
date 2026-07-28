export default class ImpostosFederais {
  constructor(public codigo = "", public nome = "", public cst_entrada = 0, public cst_saida = 0, public pis = 0, public cofins = 0) {}
  static create(data: any) {
    return new ImpostosFederais(data.codigo, data.nome, data.cst_entrada, data.cst_saida, data.pis, data.cofins);
  }
}
