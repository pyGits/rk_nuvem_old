import ContaReceber from "../entity/ContaReceber";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberTituloList from "../entity/ContaReceberTituloList";
import ContaReceberTituloListFactory from "../entity/factory/ContaReceberTituloListFactory";
import RecebimentoTitulo from "../entity/RecebimentoTitulo";
import Connection from "./Connection";

export default interface ContaReceberRepository {
  getAll(filtro: any): Promise<ContaReceberTituloList>;
  getExtrato(filtro: any): Promise<any>;
  insert(contaReceber: ContaReceber): Promise<void>;
  receber(titulos: ContaReceberTituloList, recebimento: RecebimentoTitulo): Promise<void>;
  estornar(titulos: ContaReceberTituloList): Promise<void>;
  cancelar(titulos: ContaReceberTituloList): Promise<void>;
  update(titulo: ContaReceberTitulo): Promise<void>;
}

export class ContaReceberRepositoryApi implements ContaReceberRepository {
  async getAll(filtro: any): Promise<ContaReceberTituloList> {
    const res = await Connection.get("/v2/contaReceber/titulos", { params: filtro });
    return ContaReceberTituloListFactory.createList(res.data);
  }

  async getExtrato(filtro: any): Promise<any> {
    const res = await Connection.get("/v2/contaReceber/extrato", { params: filtro });
    return {
      titulos: ContaReceberTituloListFactory.createList(res.data.titulos),
      totais: res.data.totais,
    };
  }

  async insert(contaReceber: ContaReceber): Promise<void> {
    await Connection.post("/v2/contaReceber", contaReceber);
  }

  // Só os ids sobem: o saldo e o rateio entre os títulos são resolvidos no
  // backend, a partir do que está gravado.
  async receber(titulos: ContaReceberTituloList, recebimento: RecebimentoTitulo): Promise<void> {
    await Connection.post("/v2/contaReceber/receber", { ids: titulos.ids(), recebimento });
  }

  async estornar(titulos: ContaReceberTituloList): Promise<void> {
    await Connection.post("/v2/contaReceber/estornar", { ids: titulos.ids() });
  }

  async cancelar(titulos: ContaReceberTituloList): Promise<void> {
    await Connection.post("/v2/contaReceber/cancelar", { ids: titulos.ids() });
  }

  async update(titulo: ContaReceberTitulo): Promise<void> {
    await Connection.put("/v2/contaReceber/titulo", {
      id: titulo.id,
      valor: titulo.valor,
      dataVencimento: titulo.dataVencimento,
      descricao: titulo.descricao,
    });
  }
}
