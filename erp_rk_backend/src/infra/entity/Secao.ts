export default class Secao {
  constructor(public codigo = "", public nome = "", public margem = 0) {}
  static create(data: any) {
    return new Secao(data.codigo, data.nome, data.margem);
  }
}
