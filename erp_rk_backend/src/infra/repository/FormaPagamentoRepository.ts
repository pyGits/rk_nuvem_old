import FormaPagamento from "../entity/FormaPagamento";
import DatabaseConnection from "./DatabaseConnection";

export default interface FormaPagamentoRepository {
  getAll(tenant_id: number): Promise<FormaPagamento[]>;
  insert(formaPagamento: FormaPagamento, tenant_id: number): Promise<void>;
  update(formaPagamento: FormaPagamento, tenant_id: number): Promise<void>;
  delete(codigo: string, tenant_id: number): Promise<void>;
}
export class FormaPagamentoRepositoryPG implements FormaPagamentoRepository {
  async delete(codigo: string, tenant_id: number): Promise<void> {
    if (codigo.trim() === "") throw new Error("Forma Pagamento sem código");
  }
  async insert(formaPagamento: FormaPagamento, tenant_id: number): Promise<void> {
    if (formaPagamento.codigo.trim() === "") throw new Error("Forma Pagamento sem código");
    await DatabaseConnection.query("insert into forma_pagamento(codigo,nome,tenant_id) values ($1,$2,$3)", [formaPagamento.codigo, formaPagamento.nome, tenant_id]);
  }
  async update(formaPagamento: FormaPagamento, tenant_id: number): Promise<void> {
    if (formaPagamento.codigo.trim() === "") throw new Error("Forma Pagamento sem código");
    await DatabaseConnection.query("update forma_pagamento set nome = $1 where codigo =$2 and tenant_id = $3", [formaPagamento.nome, formaPagamento.codigo, tenant_id]);
  }
  async getAll(tenant_id: number): Promise<FormaPagamento[]> {
    const data = await DatabaseConnection.queryAll("select * from forma_pagamento where tenant_id = $1", [tenant_id]);

    return data;
  }
}
