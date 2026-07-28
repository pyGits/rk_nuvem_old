import Loja from "../Loja";
import { NotaFiscal } from "../NotaFiscal";
import { Associacao, Imposto, NotaFiscalItem } from "../NotaFiscalItem";
import Preco from "../Preco";
import Produto from "../Produto";

export default class NotaFiscalFactory {
  static createFromApi(data: any): NotaFiscal {
    const nota: NotaFiscal = Object.assign(new NotaFiscal(), data);

    nota.dataEmissao = new Date(data.dataEmissao);

    nota.loja = Object.assign(new Loja(), data.loja);

    nota.items = data.items.map((item: any) => {
      const notaItem = Object.assign(new NotaFiscalItem(), item);
      notaItem.produto = Object.assign(new Produto(), notaItem.produto);
      notaItem.produto.precos = notaItem.produto.precos.map((preco: any) => {
        return Object.assign(new Preco(), preco);
      });

      // Corrigir os objetos aninhados
      notaItem.associacao = Object.assign(new Associacao(), item.associacao);
      notaItem.imposto = Object.assign(new Imposto(), item.imposto); // Se tiver a classe Imposto

      return notaItem;
    });
    return nota;
  }
}
