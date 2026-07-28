import Estoque from "../Estoque";
import Preco from "../Preco";
import Produto from "../Produto";

export default class ProdutoFactory {
  static createFromNotaFiscalCompra(item_nota: any, lojas: any) {
    const codigo_barras = item_nota.ean;
    const descricao = item_nota.descricao;
    const unidade = "UN";
    const ncm = item_nota.ncm;
    const cest = item_nota.cest;
    const tributacao = this.createTributacaoFromNotaFiscal(item_nota.imposto.icms.porcentagemIcms);

    const precos = [];
    const estoques = [];
    for (const loja of lojas) {
      const preco = new Preco(loja.codigo, item_nota.valorUnitario, item_nota.valorUnitario, 0, 0, loja);
      const estoque = new Estoque(undefined, loja.codigo, undefined, 0, 0, undefined, loja);
      precos.push(preco);
      estoques.push(estoque);
    }

    const produto = new Produto(undefined, codigo_barras, descricao, undefined, undefined, undefined, undefined, unidade, undefined, ncm, cest, tributacao, undefined, undefined, undefined, undefined, undefined, precos, estoques);

    return produto;
  }

  private static createTributacaoFromNotaFiscal(porcentagemIcms: number) {
    if (porcentagemIcms === 18) return "3";
    else if (porcentagemIcms === 0) return "1";
    else if (porcentagemIcms === 12) return "4";
    else if (porcentagemIcms === 7) return "5";
  }

  static createFromApiList(data: any[]): Produto[] {
    return data.map((p: Produto) => {
      return new Produto(p.codigo, p.codigo_barras, p.descricao, p.secao, p.fornecedor, p.grupo, p.subgrupo, p.unidade, p.forma_venda, p.ncm, p.cest, p.tributacao, p.balanca, p.balanca_validade, p.diversos, p.ativo, p.impfederal, p.precos, p.estoques);
    });
  }
}
