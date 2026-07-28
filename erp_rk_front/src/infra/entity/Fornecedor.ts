import { validarCpfCnpj } from "../validate/validateCNPJCPF";
import { CustomError } from "./CustomError";
import Pessoa from "./Pessoa";

export default class Fornecedor extends Pessoa {
  codigo: string;
  observacao: string;

  constructor(codigo = "", cnpjcpf = "", nome = "", nome_fantasia = "", ierg = "", uf = "", im = "", telefone = "", telefone2 = "", celular = "", email = "", observacao = "", cep = "", logradouro = "", cidade = "", bairro = "", complemento = "", codigoIbge = 0) {
    super(cnpjcpf, nome, nome_fantasia, ierg, uf, im, telefone, telefone2, celular, email, cep, logradouro, cidade, bairro, complemento, codigoIbge);
    this.codigo = codigo;
    this.observacao = observacao;
  }

  validate() {
    const error = new CustomError();

    if (this.nome.trim() === "") error.add({ field: "fornecedor.nome", message: "Nome não pode estar em branco !" });

    if (!validarCpfCnpj(this.cnpjcpf)) error.add({ field: "fornecedor.cnpjcpf", message: "CNPJ/CPF Inválido !" });

    if (error.hasErrors()) throw error;
  }
  toJson() {
    return {
      codigo: this.codigo,
      observacao: this.observacao,
      ...super.toJson(),
    };
  }

  static create(data: any) {
    const { codigo, cnpjcpf, nome, nome_fantasia, ierg, uf, im, telefone, telefone2, celular, email, observacao, cep, logradouro, cidade, bairro, complemento, codigoIbge } = data;
    return new Fornecedor(codigo, cnpjcpf, nome, nome_fantasia, ierg, uf, im, telefone, telefone2, celular, email, observacao, cep, logradouro, cidade, bairro, complemento, codigoIbge);
  }
}
