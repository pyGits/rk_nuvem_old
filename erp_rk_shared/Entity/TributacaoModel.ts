export default class TributacaoModel {
  codigo: string;
  nome: string;
  constructor(codigo: string = "", nome: string = "") {
    this.codigo = codigo;
    this.nome = nome;
  }

  static fromDatabase(row: any): TributacaoModel {
    return new TributacaoModel(row.codigo, row.nome);
  }
}
