import Pessoa from "./Pessoa";

export default class Fornecedor extends Pessoa {
  codigo: string;
  observacao: string;

  constructor(codigo = "", cnpjcpf = "", nome = "", nome_fantasia = "", ierg = "", uf = "", im = "", telefone = "", telefone2 = "", celular = "", email = "", observacao = "", cep = "", logradouro = "", cidade = "", bairro = "", complemento = "", codigoIbge = 0) {
    super(cnpjcpf, nome, nome_fantasia, ierg, uf, im, telefone, telefone2, celular, email, cep, logradouro, cidade, bairro, complemento, codigoIbge);
    this.codigo = codigo;
    this.observacao = observacao;
  }
  toJson() {
    return {
      codigo: this.codigo,
      observacao: this.observacao,
      ...super.toJson(),
    };
  }
  static create(body: any) {
    return new Fornecedor(body.codigo, body.cnpjcpf, body.nome, body.nome_fantasia, body.ierg, body.uf, body.im, body.telefone, body.telefone2, body.celular, body.email, body.observacao, body.cep, body.logradouro, body.cidade, body.bairro, body.complemento, body.codigoIbge);
  }
}
