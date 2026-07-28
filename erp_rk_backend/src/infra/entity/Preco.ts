import Loja from "./Loja";
import { NotaFiscalItem } from "./NotaFiscalItem";

export default class Preco {
  constructor(public lojaId = "", public preco = 0, public custo = 0, public oferta = 0, public markup = 0, public loja = new Loja(), public codigo_produto = "", public ultimo_custo = 0) {}

  atualizarCustoPorItemNota(item: NotaFiscalItem, rateioFrete: number, rateioDesconto: number) {
    // Custo = valorProdutos
    //     + valorFrete
    //     + valorIPI (se não recuperável)
    //     + valorOutrasDespesas
    //     + valorIcmsST (se não recuperável)
    //     - valorDesconto
    // O valor unitário e os encargos referem-se à unidade comercial da nota (ex.: a caixa).
    // Quando o produto entra em embalagem (caixa, fardo, etc.), o estoque é dado em unidades
    // (quantidadeEstoque = quantidadeComercial * qtd_fornecedor), então o custo precisa ser
    // rateado pela quantidade de itens que vêm na embalagem para refletir o custo por unidade.
    const itensPorEmbalagem = item.associacao.qtd_fornecedor > 0 ? item.associacao.qtd_fornecedor : 1;
    const custoEmbalagem = item.valorUnitario + item.valorOutrasDespesas + item.imposto.icms.valorIcmsST + rateioFrete - rateioDesconto;
    this.custo = custoEmbalagem / itensPorEmbalagem;
  }
}
