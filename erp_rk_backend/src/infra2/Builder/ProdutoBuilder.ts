import PrecoCollectionModel from "../../../../erp_rk_shared/Entity/PrecoCollectionModel";
import PrecoModel from "../../../../erp_rk_shared/Entity/PrecoModel";
import LojaModel from "../../../../erp_rk_shared/Entity/LojaModel";
import ProdutoModel from "../../../../erp_rk_shared/Entity/ProdutoModel";
import TributacaoModel from "../../../../erp_rk_shared/Entity/TributacaoModel";
import EstoqueCollectionModel from "../../../../erp_rk_shared/Entity/EstoqueCollectionModel";
import EstoqueModel from "../../../../erp_rk_shared/Entity/EstoqueModel";
import NCMModel from "../../../../erp_rk_shared/Entity/NCMModel";
import CESTModel from "../../../../erp_rk_shared/Entity/CESTModel";

export default class ProdutoBuilder {
  private produto!: ProdutoModel;
  private lojas: LojaModel[] = [];
  private precos?: PrecoCollectionModel;
  private estoques?: EstoqueCollectionModel;

  withProduto(produto: ProdutoModel): this {
    this.produto = produto;
    return this;
  }
  withPrecos(precos: PrecoCollectionModel): this {
    this.precos = precos;
    return this;
  }
  withEstoques(estoques: EstoqueCollectionModel): this {
    this.estoques = estoques;
    return this;
  }

  withLojas(lojas: LojaModel[]): this {
    this.lojas = lojas;
    return this;
  }
  withTributacao(tributacao: TributacaoModel): this {
    this.produto.tributacao = tributacao;
    return this;
  }

  withNCM(ncm: NCMModel): this {
    this.produto.ncm = ncm;
    return this;
  }

  withCEST(cest: CESTModel): this {
    this.produto.cest = cest;
    return this;
  }

  build(): ProdutoModel {
    if (!this.produto) {
      throw new Error("ProdutoModel é obrigatório");
    }

    this.produto.precos = this.precos;
    this.produto.estoques = this.estoques;

    return this.produto;
  }
}
