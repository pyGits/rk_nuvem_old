export default class SecaoModel {
    codigo: string;
    nome: string;
    margem: number;
    constructor(
        codigo: string = "",
        nome: string = "",
        margem: number = 0,
    ) {
        this.codigo = codigo;
        this.nome = nome;
        this.margem = margem;
    }
}