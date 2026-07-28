import Pessoa from "./Pessoa";

export default class Loja extends Pessoa{
  constructor(public codigo = "", public nome = "", public fantasia = "", public cnpjcpf = "",public ierg='',public uf='',public im='',public telefone='',public telefone2='',public celular='',public email='',public cep='',public logradouro='',public cidade='',public bairro='',public complemento='',public codigoIbge=0,public certificado='') {
    super(cnpjcpf,nome,fantasia,ierg,uf,im,telefone,telefone2,celular,email,cep,logradouro,cidade,bairro,complemento,codigoIbge)
  }

  validate(){
    if(this.codigo.trim()==='') throw new Error("Código da loja não pode estar em branco ")
    if(this.cnpjcpf.trim()==='') throw new Error("CNPJ/CPF Da loja não pode estar em branco")
    if(this.nome.trim()==='') throw new Error("Nome não pode estar em branco")
        
  }
}
