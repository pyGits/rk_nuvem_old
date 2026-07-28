export default class Grupo {
  constructor(public codigo = "", public codigo_secao = "", public nome = "", public margem = 0) {}
  static create(data: any) {
    return new Grupo(data.codigo, data.codigo_secao, data.nome, data.margem);
  }
}
