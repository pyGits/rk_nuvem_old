import { v4 as uuidv4 } from "uuid";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import DatabaseConnection from "./DatabaseConnection";

export default interface ContaReceberRecebimentoRepository {
  insertByTitulo(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  estornarByTitulo(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  getByCliente(clienteCodigo: string, tenant_id: number): Promise<any[]>;
}

export class ContaReceberRecebimentoRepositoryPG implements ContaReceberRecebimentoRepository {
  // Grava so os recebimentos novos - os que ja tem id vieram do banco.
  async insertByTitulo(titulo: ContaReceberTitulo, tenant_id: number): Promise<void> {
    for (const recebimento of titulo.recebimentos) {
      if (recebimento.id) continue;

      await DatabaseConnection.query(
        `insert into conta_receber_recebimento (id,tenant_id,conta_receber_id,data_pagamento,forma_pagamento,
          valor,valor_juros,valor_multa,valor_desconto,origem,usuario,estornado)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9,'WEB',$10,0)`,
        [uuidv4(), tenant_id, titulo.id, recebimento.dataPagamento, recebimento.formaPagamento, recebimento.valor, recebimento.juros, recebimento.multa, recebimento.desconto, recebimento.usuario]
      );
    }
  }

  async estornarByTitulo(titulo: ContaReceberTitulo, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update conta_receber_recebimento set estornado = 1, updated_at = now() where conta_receber_id = $1 and tenant_id = $2", [titulo.id, tenant_id]);
  }

  async getByCliente(clienteCodigo: string, tenant_id: number): Promise<any[]> {
    return await DatabaseConnection.queryAll(
      `select r.*, c.codigo as titulo_codigo, c.data_vencimento, c.prestacao
         from conta_receber_recebimento r
         join conta_receber c on c.id = r.conta_receber_id and c.tenant_id = r.tenant_id
        where r.tenant_id = $1 and c.cliente_codigo = $2 and r.estornado = 0
        order by r.data_pagamento`,
      [tenant_id, clienteCodigo]
    );
  }
}
