export default class NCMModel {
  codigo: string;
  nome: string;
  constructor(codigo: string = "", nome: string = "") {
    this.codigo = codigo;
    this.nome = nome;
  }

  validate() {
    if (!this.codigo || this.codigo.trim() === "") {
      throw new Error("Código do NCM é obrigatório.");
    }
  }
}
