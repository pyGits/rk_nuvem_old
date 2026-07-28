import Preco from "../Preco";
import Produto from "../Produto";

export default class ProdutoFactory {
  static fromRKList(data: any, lojaId: string) {
    let list = [];
    for (const indice in data) {
      const produto = data[indice];
      const codigo = Number(produto.CODIGO).toString();
      const codigo_barras = Number(produto.CODIGO_BARRAS).toString();
      const descricao = String(produto.DESCRICAO).substring(0, 80);
      const secao = Number(produto.GRUPO).toString();
      const grupo = Number(produto.SUBGRUPO).toString();
      const unidade = String(produto.UNIDADE);
      const forma_venda = String(produto.FRACIONADO);
      const ncm = String(produto.NCM);
      const cest = String(produto.CEST);
      const tributacao = this.tributacaoAdapter(produto.TRIBUTACAO);
      const balanca = this.balancaRKAdapter(String(produto.BALANCA));
      const balanca_validade = Number(produto.VALIDADE);
      const diversos = "N";

      const precos = [new Preco(lojaId, produto.PRECO, produto.CUSTO, 0, produto.MARGEM, undefined, codigo)];
      const produto_adapter = new Produto(codigo, codigo_barras, descricao, secao, undefined, grupo, undefined, unidade, forma_venda, ncm, cest, tributacao, balanca, balanca_validade, diversos, "S", undefined, precos, undefined);
      list.push(produto_adapter);
    }
    return list;
  }

  static fromSyspdvList(data: any) {
    let list = [];
    for (const indice in data) {
      const produto = data[indice];
      const codigo = produto.PROCODINT;
      const codigo_barras = Number(produto.PROCOD).toString();
      const descricao = String(produto.PRODES).substring(0, 80);
      const secao = Number(produto.SECCOD).toString();
      const unidade = String(produto.PROUNID);
      const forma_venda = String(produto.PROPESVAR);
      const ncm = String(produto.PRONCM);
      const cest = String(produto.PROCEST);
      const tributacao = this.tributacaoAdapter(produto.TRBID);
      const balanca = String(produto.PROENVBAL);
      const balanca_validade = Number(produto.PROVLD);
      const diversos = "N";

      const produto_adapter = new Produto(codigo, codigo_barras, descricao, secao, undefined, undefined, undefined, unidade, forma_venda, ncm, cest, tributacao, balanca, balanca_validade, diversos, "S", undefined, undefined, undefined);
      list.push(produto_adapter);
    }
    return list;
  }

  private static balancaRKAdapter(balanca: string) {
    if (balanca === "1") {
      return "S";
    } else {
      return "N";
    }
  }

  private static tributacaoAdapter(trb: string) {
    if (trb === "F00") {
      return "1";
    } else if (trb === "I00") {
      return "2";
    } else if (trb === "T18") {
      return "3";
    } else if (trb === "T12") {
      return "4";
    } else if (trb === "T07") {
      return "5";
    } else {
      return "1";
    }
  }
}
