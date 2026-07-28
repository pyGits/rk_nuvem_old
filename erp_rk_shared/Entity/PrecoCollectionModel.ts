import LojaModel from "./LojaModel";
import PrecoModel from "./PrecoModel";

export default class PrecoCollectionModel {
  items: PrecoModel[];
  constructor(precos: PrecoModel[] = []) {
    this.items = precos;
  }
  private obterPreco(codigoLoja: string): PrecoModel | undefined {
    return this.items.find((p) => p.loja.codigo === codigoLoja);
  }

  atualizarPreco(preco: PrecoModel): void {
    const existente = this.obterPreco(preco.loja.codigo);

    if (!existente) return;

    Object.assign(existente, preco);
  }
  replicarPrecos(preco: PrecoModel): void {
    this.items.forEach((p) => {
      if (p.loja.codigo !== preco.loja.codigo) {
        p.custo = preco.custo;
        p.markup = preco.markup;
        p.preco = preco.preco;
        p.oferta = preco.oferta;
        p.preco2 = preco.preco2;
        p.preco2_qtd = preco.preco2_qtd;
      }
    });
  }

  aceitarSugestaoPreco(preco: PrecoModel): void {
    const existente = this.obterPreco(preco.loja.codigo);

    if (!existente) return;

    preco.aceitarSugestao();

    Object.assign(existente, preco);
  }

  static fromDatabase(rows: any[]): PrecoCollectionModel {
    const precos = rows.map((row) => {
      const preco = new PrecoModel(
        row.codigo_produto,
        row.preco ?? 0,
        row.markup ?? 0,
        row.custo ?? 0,
        0, // sugestao (calculada depois)
        0, // margemPraticada (calculada depois)
        0, // markDown (calculada depois)
        row.oferta ?? 0,
        row.preco2 ?? 0,
        row.preco2_qtd ?? 0,
        new LojaModel(String(row.loja))
      );

      // recalcula valores derivados
      preco.calculate();

      return preco;
    });

    return new PrecoCollectionModel(precos);
  }
}
