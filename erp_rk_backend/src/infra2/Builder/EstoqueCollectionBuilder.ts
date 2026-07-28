import EstoqueCollectionModel from "../../../../erp_rk_shared/Entity/EstoqueCollectionModel";
import EstoqueModel from "../../../../erp_rk_shared/Entity/EstoqueModel";
import LojaModel from "../../../../erp_rk_shared/Entity/LojaModel";

export default class EstoqueCollectionBuilder {
  private estoques: EstoqueCollectionModel;
  private lojas: LojaModel[];
  withEstoques(estoques: EstoqueCollectionModel): this {
    this.estoques = estoques;
    return this;
  }
  withLojas(lojas: LojaModel[]): this {
    this.lojas = lojas;
    return this;
  }

  build(): EstoqueCollectionModel {
    if (!this.estoques) {
      throw new Error("Estoques é obrigatório");
    }
    if (!this.lojas) {
      throw new Error("Lojas é obrigatório");
    }

    const items = this.lojas.map((loja) => {
      const estoqueExistente = this.estoques.items.find((p) => String(p.loja.codigo) === String(loja.codigo));

      if (estoqueExistente) {
        estoqueExistente.loja = loja;
        return estoqueExistente;
      }

      return new EstoqueModel();
    });

    return new EstoqueCollectionModel(items);
  }
}
