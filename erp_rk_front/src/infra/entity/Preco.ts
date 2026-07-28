import { CustomError } from "./CustomError";
import Loja from "./Loja";

export default class Preco {
  constructor(public lojaId = "", public preco = 0, public custo = 0, public oferta = 0, public markup = 0, public loja = new Loja()) {}

  validate() {
    // const error = new CustomError();
    // if (this.preco <= 0) error.add({ field: "preco", message: "Preço não pode ser 0 ou negativo!" });
    // throw error;
  }
  margemPraticada() {
    if (this.custo === 0) {
      return 0;
    }
    if (this.oferta > 0) {
      const margemPraticada = ((this.oferta - this.custo) / this.custo) * 100;
      return Number(margemPraticada.toFixed(2)) || 0;
    } else {
      const margemPraticada = ((this.preco - this.custo) / this.custo) * 100;
      return Number(margemPraticada.toFixed(2)) || 0;
    }
  }
  markDown() {
    if (this.oferta > 0) {
      const margemPraticada = ((this.oferta - this.custo) / this.oferta) * 100;
      return Number(margemPraticada.toFixed(2)) || 0;
    } else if (this.preco > 0) {
      const margemPraticada = ((this.preco - this.custo) / this.preco) * 100;
      return Number(margemPraticada.toFixed(2)) || 0;
    } else {
      return 0;
    }
  }

  sugestao() {
    const vlrMargem = (Number(this.markup) * Number(this.custo)) / 100;
    const vlrVenda = Number(vlrMargem) + Number(this.custo);
    return Number(vlrVenda);
  }

  aceitarSugestao() {
    this.preco = this.sugestao();
  }
}
