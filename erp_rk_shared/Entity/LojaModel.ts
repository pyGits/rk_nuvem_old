export default class LojaModel {
  codigo: string;
  nome: string;
  cnpj: string;
  ativo: "S" | "N";

  constructor(
    codigo: string = "",
    nome: string = "",
    cnpj: string = "",
    ativo: "S" | "N" = "S"
  ) {
    this.codigo = codigo;
    this.nome = nome;
    this.cnpj = cnpj;
    this.ativo = ativo;
  }

  static fromDatabase(data: any) {
    return new LojaModel(
      String(data.codigo),
      data.nome,
      data.cnpjcpf,
      data.ativo
    );
  }
}
