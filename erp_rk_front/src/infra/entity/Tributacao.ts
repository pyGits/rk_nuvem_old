export default class Tributacao {
  constructor(public codigo = "", public nome = "", public cst = "", public cfop = "", public csosn = "", public icms = 0) {}

  static create(data: any) {
    return new Tributacao(data.codigo, data.nome, data.cst, data.cfop, data.csosn, data.icms);
  }
}
