import { Connection } from "pg";
import ContaPagarTitulo from "../entity/ContaPagarTitulo";
import DatabaseConnection from "./DatabaseConnection";

export default interface ContaPagarTituloPagamentoRepository {
  insertByTitulo(titulo: ContaPagarTitulo, tenant_id: number): Promise<void>;
  estornarByTitulo(titulo: ContaPagarTitulo, tenant_id: number): Promise<void>;
}

export class ContaPagarTituloPagamentoRepositoryPG implements ContaPagarTituloPagamentoRepository {
  async insertByTitulo(titulo: ContaPagarTitulo, tenant_id: number): Promise<void> {
    for (const pagamento of titulo.pagamentos) {
      await DatabaseConnection.query("insert into conta_pagar_titulo_pagamento (titulo_id,valor,forma_pagamento_id,tenant_id,estornado) values ($1,$2,$3,$4,0)", [titulo.id, pagamento.valor, pagamento.formaPagamento.codigo, tenant_id]);
    }
  }
  async estornarByTitulo(titulo: ContaPagarTitulo, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update conta_pagar_titulo_pagamento set estornado = 1 where titulo_id = $1 and tenant_id =$2", [titulo.id, tenant_id]);
  }
}
