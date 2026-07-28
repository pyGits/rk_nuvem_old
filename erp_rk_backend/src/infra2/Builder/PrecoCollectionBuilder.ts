import PrecoCollectionModel from "../../../../erp_rk_shared/Entity/PrecoCollectionModel";
import PrecoModel from "../../../../erp_rk_shared/Entity/PrecoModel";
import LojaModel from "../../../../erp_rk_shared/Entity/LojaModel";

export default class PrecoCollectionBuilder {
  private precos: PrecoCollectionModel;
  private lojas: LojaModel[];
  withPrecos(precos: PrecoCollectionModel): this {
    this.precos = precos;
    return this;
  }
  withLojas(lojas: LojaModel[]): this {
    this.lojas = lojas;
    return this;
  }

  build(): PrecoCollectionModel {
    if (!this.precos) {
      throw new Error("Precos é obrigatório");
    }
    if (!this.lojas) {
      throw new Error("Lojas é obrigatório");
    }

    const codigoProduto = this.precos.items.length > 0 ? this.precos.items[0].codigo_produto : "";

    const items = this.lojas.map((loja) => {
      const precoExistente = this.precos.items.find((p) => String(p.loja.codigo) === String(loja.codigo));

      if (precoExistente) {
        precoExistente.loja = loja;
        return precoExistente;
      }

      return new PrecoModel(codigoProduto, 0, 0, 0, 0, 0, 0, 0, 0, 0, loja);
    });

    return new PrecoCollectionModel(items);
  }
}
