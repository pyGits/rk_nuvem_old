import Produto from "./Produto";
import Tributacao from "./Tributacao";

export class NotaFiscalItemEfetivo {
  constructor(
    public seq = 0,
    public produto = new Produto(),
    public tributacao = new Tributacao(),
    public valor_unitario = 1,
    public unidade = "UN",
    public itens_embalagem = 1,
    public qtd = 1,
    public desconto = 0,
    public frete = 0,
    public outras_despesas = 0,
    public total = 1
  ) {}

  calcular() {
    this.total = this.qtd * this.valor_unitario;
  }
}

export class NotaFiscalItemEfetivoList {
  constructor(protected list: NotaFiscalItemEfetivo[] = []) {}

  adicionar(item: NotaFiscalItemEfetivo) {
    if (item.produto.codigo.trim() === "") throw new Error("Selecione um Produto !");
    if (item.tributacao.codigo.trim() === "") throw new Error("Selecione uma tributação");
    if (item.qtd <= 0) throw new Error("Quantidade não pode ser 0 ou negativo");
    if (item.valor_unitario <= 0) throw new Error("Valor unitário não pode ser 0 ou negativo");
    if (item.total <= 0) throw new Error("Total não pode ser 0 ou negativo");
    item.seq = this.list.length + 1;
    this.list.push(item);
  }
  excluir(item: NotaFiscalItemEfetivo) {
    this.list = this.list.filter((i) => i.seq !== item.seq);
    // Reajusta a numeração após excluir
    this.list.forEach((i, index) => {
      i.seq = index + 1;
    });
  }

  itens() {
    return this.list;
  }
}
