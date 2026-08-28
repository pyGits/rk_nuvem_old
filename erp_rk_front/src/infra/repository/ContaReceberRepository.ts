import ContaReceber from "../entity/ContaReceber";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberTituloList from "../entity/ContaReceberTituloList";
import ContaReceberTituloListFactory from "../entity/factory/ContaReceberTituloListFactory";
import RecebimentoTitulo from "../entity/RecebimentoTitulo";
import Connection from "./Connection";

export default interface ContaReceberRepository {
  getAll(filtro: any): Promise<ContaReceberTituloList>;
  getExtrato(filtro: any): Promise<any>;
  getSaldoClientes(filtro: any): Promise<any>;
  getRecibos(filtro: any): Promise<any[]>;
  gerarRecibo(reciboId: string): Promise<any>;
  estornarRecibo(reciboId: string): Promise<void>;
  insert(contaReceber: ContaReceber): Promise<void>;
  receber(titulos: ContaReceberTituloList, recebimento: RecebimentoTitulo): Promise<any>;
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

  // Posição de todos os clientes: uma linha por cliente, somada no banco.
  async getSaldoClientes(filtro: any): Promise<any> {
    const res = await Connection.get("/v2/contaReceber/saldoClientes", { params: filtro });
    return res.data;
  }

  // Recibos: o que já foi liquidado, e a 2ª via em PDF.
  async getRecibos(filtro: any): Promise<any[]> {
    const res = await Connection.get("/v2/contaReceber/recibos", { params: filtro });
    return res.data || [];
  }

  async gerarRecibo(reciboId: string): Promise<any> {
    const res = await Connection.get("/v2/contaReceber/recibo", { params: { reciboId } });
    return res.data;
  }

  async estornarRecibo(reciboId: string): Promise<void> {
    await Connection.post("/v2/contaReceber/estornarRecibo", { reciboId });
  }

  async insert(contaReceber: ContaReceber): Promise<void> {
    await Connection.post("/v2/contaReceber", contaReceber);
  }

  // Só os ids sobem: o saldo e o rateio entre os títulos são resolvidos no
  // backend, a partir do que está gravado.
  // Devolve o recibo criado para a tela poder abrir o comprovante na hora.
  async receber(titulos: ContaReceberTituloList, recebimento: RecebimentoTitulo): Promise<any> {
    const res = await Connection.post("/v2/contaReceber/receber", { ids: titulos.ids(), recebimento });
    return res.data;
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
