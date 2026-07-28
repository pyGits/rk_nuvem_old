import Connection from "./Connection";
import FormaPagamento from "../entity/FormaPagamento";
import FormaPagamentoFactory from "../entity/factory/FormaPagamentoFactory";

export default interface FormaPagamentoRepository {
  insert(formaPagamento: FormaPagamento): Promise<void>;
  delete(formaPagamento: FormaPagamento): Promise<void>;
  update(formaPagamento: FormaPagamento): Promise<void>;
  getAll(): Promise<FormaPagamento[]>;
  getByCodigo(codigo: string): Promise<FormaPagamento>;
}
export class FormaPagamentoRepositoryApi implements FormaPagamentoRepository {
  async delete(formaPagamento: FormaPagamento): Promise<void> {
    await Connection.delete(`/v2/forma-pagamento/${formaPagamento.codigo}`);
  }
  async update(formaPagamento: FormaPagamento): Promise<void> {
    await Connection.put("/v2/forma-pagamento", formaPagamento);
  }
  async getByCodigo(codigo: string): Promise<FormaPagamento> {
    const res = await Connection.get(`/v2/forma-pagamento/${codigo}`);
    return FormaPagamentoFactory.create(res.data);
  }
  async insert(formaPagamento: FormaPagamento): Promise<void> {
    await Connection.post("/v2/forma-pagamento", formaPagamento);
  }
  async getAll(): Promise<FormaPagamento[]> {
    const res = await Connection.get("/v2/forma-pagamento");
    return FormaPagamentoFactory.createList(res.data);
  }
}
