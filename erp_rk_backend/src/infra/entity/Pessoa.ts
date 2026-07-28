export default class Pessoa {
  constructor(
    public cnpjcpf = "",
    public nome = "",
    public nome_fantasia = "",
    public ierg = "",
    public uf = "",
    public im = "",
    public telefone = "",
    public telefone2 = "",
    public celular = "",
    public email = "",
    public cep = "",
    public logradouro = "",
    public cidade = "",
    public bairro = "",
    public complemento = "",
    public codigoIbge = 0
  ) {}

  toJson() {
    return {
      cnpjcpf: this.cnpjcpf,
      nome: this.nome,
      nome_fantasia: this.nome_fantasia,
      ierg: this.ierg,
      uf: this.uf,
      im: this.im,
      telefone: this.telefone,
      telefone2: this.telefone2,
      celular: this.celular,
      email: this.email,
      cep: this.cep,
      logradouro: this.logradouro,
      cidade: this.cidade,
      bairro: this.bairro,
      complemento: this.complemento,
      codigoIbge: this.codigoIbge,
    };
  }
}
