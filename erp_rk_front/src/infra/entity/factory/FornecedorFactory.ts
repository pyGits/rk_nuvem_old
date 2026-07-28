import Fornecedor from "../Fornecedor";

export default class FornecedorFactory {
  static create(data: any) {
    return new Fornecedor(data.codigo, data.cnpjcpf, data.nome, data.nome_fantasia, data.ierg, data.uf, data.im, data.telefone, data.telefone2, data.celular, data.email, data.observacao, data.cep, data.logradouro, data.cidade, data.bairro, data.complemento, data.codigoIbge);
  }
}
