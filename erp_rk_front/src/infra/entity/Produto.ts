import Preco from "./Preco";
import { CustomError } from "./CustomError";
import Estoque from "./Estoque";
import { NotaFiscalItem } from "./NotaFiscalItem";
export default class Produto {
  constructor(public codigo = "", public codigo_barras = "", public descricao = "", public secao = "", public fornecedor = "", public grupo = "", public subgrupo = "", public unidade = "UN", public forma_venda = "N", public ncm = "", public cest = "", public tributacao = "", public balanca = "", public balanca_validade = 0, public diversos = "", public ativo = "", public impfederal = "", public precos: Preco[] = [], public estoques: Estoque[] = []) {
    this.padronizar();
  }
  private padronizar() {
    this.codigo_barras = this.codigo_barras.replace(/\D+/g, "");
  }
  validate() {
    const error = new CustomError();
    if (this.codigo_barras.trim() === "") error.add({ field: "produto.codigo_barras", message: "Código de barras não pode estar em branco !" });
    if (!/^\d+$/.test(this.codigo_barras)) error.add({ field: "produto.codigo_barras", message: "Código de barras deve conter apenas números!" });
    if (this.codigo_barras.length > 14) error.add({ field: "produto.codigo_barras", message: "Código de barras não pode ter mais que 14 dígitos!" });

    if (this.descricao.trim() === "") error.add({ field: "produto.descricao", message: "Descrição do produto não pode estar em branco !" });
    if (this.ncm.trim().length !== 8) error.add({ field: "produto.ncm", message: "NCM do produto deve ter 8 dígitos" });

    for (const preco of this.precos) {
      if (preco.preco <= 0) error.add({ field: "produto.preco", message: "Preço do produto não pode ser 0,00 ou negativo" });
    }
    if (error.hasErrors()) throw error;
  }

  atualizarPrecos(valor: number) {
    this.precos.map((preco) => (preco.preco = valor));
  }

  atualizarPreco(precoAtualizado: Preco) {
    const index = this.precos.findIndex((preco) => preco.lojaId === precoAtualizado.lojaId);
    if (index !== -1) {
      this.precos[index] = precoAtualizado;
    }
  }

  atualizarDadosDaNota(item: NotaFiscalItem) {
    this.codigo_barras = item.ean;
    this.descricao = item.descricao;
    this.ncm = item.ncm;
    this.cest = item.cest;
    this.padronizar();
  }
}

export class ListaProdutos {
  constructor(public items: Produto[]) {}
  alterarMarkupGeral(markup: number) {
    this.items.map((produto: Produto) => {
      produto.precos.map((preco: Preco) => {
        preco.markup = markup;
      });
    });
  }

  aceitarTodasSugestoes() {
    this.items.map((produto: Produto) => {
      produto.precos.map((preco: Preco) => {
        preco.aceitarSugestao();
      });
    });
  }
}
