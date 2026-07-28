export default class GrupoModel {
    codigo: string;
    nome: string;
    secaoId: string;
    constructor(
        codigo: string = "",
        nome: string = "",
        secaoId: string = ""
    ) {
        this.codigo = codigo;
        this.nome = nome;
        this.secaoId = secaoId;
    }

}   