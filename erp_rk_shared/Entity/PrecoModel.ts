import LojaModel from "./LojaModel";

export default class PrecoModel {
  codigo_produto: string;
  preco: number;
  markup: number;
  custo: number;
  sugestao: number;
  margemPraticada: number;
  markDown: number;
  oferta: number;
  preco2: number;
  preco2_qtd: number;
  loja: LojaModel;

  constructor(
    codigo_produto: string = "",
    preco: number = 0,
    markup: number = 0,
    custo: number = 0,
    sugestao: number = 0,
    margemPraticada: number = 0,
    markDown: number = 0,
    oferta: number = 0,
    preco2: number = 0,
    preco2_qtd: number = 0,
    loja: LojaModel = new LojaModel()
  ) {
    this.codigo_produto = codigo_produto;
    this.preco = preco;
    this.markup = markup;
    this.custo = custo;
    this.sugestao = sugestao;
    this.margemPraticada = margemPraticada;
    this.markDown = markDown;
    this.oferta = oferta;
    this.preco2 = preco2;
    this.preco2_qtd = preco2_qtd;
    this.loja = loja;
  }
  aceitarSugestao() {
    this.preco = this.sugestao;
  }
  calculate() {
    this.margemPraticada = this.calculateMargemPraticada();
    this.markDown = this.calculateMarkDown();
    this.sugestao = this.calculateSugestao();
  }

  calculateSugestao(): number {
    const margemValor = (this.markup * this.custo) / 100;
    return margemValor + this.custo;
  }

  calculateMargemPraticada(): number {
    if (this.custo === 0) return 0;

    const basePreco = this.oferta > 0 ? this.oferta : this.preco;
    const margem = ((basePreco - this.custo) / this.custo) * 100;
    return Number(margem.toFixed(2)) || 0;
  }

  calculateMarkDown(): number {
    if (this.oferta > 0) {
      const margem = ((this.oferta - this.custo) / this.oferta) * 100;
      return Number(margem.toFixed(2)) || 0;
    }

    if (this.preco > 0) {
      const margem = ((this.preco - this.custo) / this.preco) * 100;
      return Number(margem.toFixed(2)) || 0;
    }

    return 0;
  }

  validate(): void {
    if (this.preco === 0) {
      throw new Error("Preço de venda não pode ser zero");
    }
  }
}
