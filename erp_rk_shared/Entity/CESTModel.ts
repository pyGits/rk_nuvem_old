export default class CESTModel {
  codigo: string;
  ncm: string;
  descricao: string;

  constructor(codigo: string = "", ncm: string = "", descricao: string = "") {
    this.codigo = codigo;
    this.ncm = ncm;
    this.descricao = descricao;
  }
}
