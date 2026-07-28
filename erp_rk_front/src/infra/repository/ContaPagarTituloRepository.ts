import ContaPagarTitulo from "../entity/ContaPagarTitulo";
import ContaPagarTituloList from "../entity/ContaPagarTituloList";
import ContaPagarTituloListFactory from "../entity/factory/ContaPagarTituloListFactory";
import Connection from "./Connection";

export default interface ContaPagarTituloRepository {
  getAll(filtro: any): Promise<ContaPagarTituloList>;
  liquidar(titulos: ContaPagarTituloList): Promise<void>;
  estornar(titulos: ContaPagarTituloList): Promise<void>;
  cancelar(titulos: ContaPagarTituloList): Promise<void>;
  update(titulo: ContaPagarTitulo): Promise<void>;
}
export class ContaPagarTituloRepositoryApi implements ContaPagarTituloRepository {
  async update(titulo: ContaPagarTitulo): Promise<void> {
    await Connection.put(`/v2/contaPagar/titulo`, titulo);
  }
  async getAll(filtro: any): Promise<ContaPagarTituloList> {
    const res = await Connection.get("/v2/contaPagar/titulos", { params: filtro });
    return ContaPagarTituloListFactory.createList(res.data);
  }
  async liquidar(titulos: ContaPagarTituloList) {
    await Connection.post("/v2/contaPagar/liquidar", titulos);
  }
  async estornar(titulos: ContaPagarTituloList) {
    await Connection.post("/v2/contaPagar/estornar", titulos);
  }
  async cancelar(titulos: ContaPagarTituloList) {
    await Connection.post("/v2/contaPagar/cancelar", titulos);
  }
}
