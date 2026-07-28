import { Associacao, COFINS, ICMS, Imposto, IPI, NotaFiscalItem, PIS } from "../NotaFiscalItem";
import { NotaFiscalItemEfetivo, NotaFiscalItemEfetivoList } from "../NotaFiscalItemEfetivo";

export default class NotaFiscalItemFactory {
  static createFromNotaFiscalItemEfetivoList(data: NotaFiscalItemEfetivoList) {
    return data.itens().map((item: NotaFiscalItemEfetivo) => {
      return this.createFromNotaFiscalItemEfetivo(item);
    });
  }
  static createFromNotaFiscalItemEfetivo(data: NotaFiscalItemEfetivo) {
    return new NotaFiscalItem(
      data.seq,
      "",
      data.produto.descricao,
      data.produto.codigo_barras,
      data.produto.ncm,
      data.produto.cest,
      Number(data.tributacao.cfop),
      "",
      "",
      data.produto.unidade,
      data.valor_unitario,
      data.produto.unidade,
      data.produto.codigo_barras,
      data.qtd,
      data.qtd,
      data.valor_unitario,
      0,
      0,
      "",
      "",
      "",
      "",
      data.total,
      new Imposto(new ICMS(data.tributacao.cst, 0, data.tributacao.icms, 0, 0, 0, 0, "", data.tributacao.csosn, 0, "", 0, 0, 0, 0, 0, 0, 0, 0, 0), new IPI(), new PIS(), new COFINS()),
      new Associacao(data.produto.codigo, undefined, undefined, undefined, data.itens_embalagem, true),
      data.produto,
      data.produto.codigo
    );
  }
}
