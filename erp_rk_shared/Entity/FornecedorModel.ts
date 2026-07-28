export class FornecedorModel {
  codigo: string;
  cnpjcpf: string;
  nome: string;
  nome_fantasia: string;
  ierg: string;
  uf: string;
  im: string;
  telefone: string;
  telefone2: string;
  celular: string;
  email: string;
  observacao: string;
  cep: string;
  logradouro: string;
  cidade: string;
  bairro: string;
  complemento: string;
  codigoIbge: number;

  constructor(codigo: string = "", cnpjcpf: string = "", nome: string = "", nome_fantasia: string = "", ierg: string = "", uf: string = "", im: string = "", telefone: string = "", telefone2: string = "", celular: string = "", email: string = "", observacao: string = "", cep: string = "", logradouro: string = "", cidade: string = "", bairro: string = "", complemento: string = "", codigoIbge: number = 0) {
    this.codigo = codigo;
    this.cnpjcpf = cnpjcpf;
    this.nome = nome;
    this.nome_fantasia = nome_fantasia;
    this.ierg = ierg;
    this.uf = uf;
    this.im = im;
    this.telefone = telefone;
    this.telefone2 = telefone2;
    this.celular = celular;
    this.email = email;
    this.observacao = observacao;
    this.cep = cep;
    this.logradouro = logradouro;
    this.cidade = cidade;
    this.bairro = bairro;
    this.complemento = complemento;
    this.codigoIbge = codigoIbge;
  }
}
