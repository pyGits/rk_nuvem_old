import { v4 as uuidv4 } from "uuid";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import DatabaseConnection, { Queryable } from "./DatabaseConnection";

export default interface ContaReceberRecebimentoRepository {
  // db opcional: o padrao e a conexao solta de sempre, e quem precisa de
  // atomicidade passa o Queryable da transacao.
  insertByTitulo(titulo: ContaReceberTitulo, tenant_id: number, db?: Queryable, recibo?: Recibo): Promise<void>;
  proximoNumeroRecibo(tenant_id: number, db?: Queryable): Promise<number>;
  estornarByTitulo(titulo: ContaReceberTitulo, tenant_id: number, db?: Queryable): Promise<void>;
  getByCliente(clienteCodigo: string, tenant_id: number): Promise<any[]>;
}

// Identidade da operacao de recebimento: as N linhas geradas por uma mesma
// baixa compartilham as duas, e e o que permite reimprimir o comprovante.
export type Recibo = { id: string; numero: number };

export class ContaReceberRecebimentoRepositoryPG implements ContaReceberRecebimentoRepository {
  // max+1, mesmo idioma de proximoCodigoManual. A unique parcial transforma uma
  // colisao concorrente em erro 23505 em vez de dois recibos com o mesmo numero.
  async proximoNumeroRecibo(tenant_id: number, db: Queryable = DatabaseConnection): Promise<number> {
    const row = await db.queryFirst("select coalesce(max(recibo_numero), 0) + 1 as proximo from conta_receber_recebimento where tenant_id = $1", [tenant_id]);
    return Number(row?.proximo || 1);
  }

  // Grava so os recebimentos novos - os que ja tem id vieram do banco.
  async insertByTitulo(titulo: ContaReceberTitulo, tenant_id: number, db: Queryable = DatabaseConnection, recibo?: Recibo): Promise<void> {
    for (const recebimento of titulo.recebimentos) {
      if (recebimento.id) continue;

      await db.query(
        `insert into conta_receber_recebimento (id,tenant_id,conta_receber_id,data_pagamento,forma_pagamento,
          valor,valor_juros,valor_multa,valor_desconto,origem,usuario,estornado,recibo_id,recibo_numero)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9,'WEB',$10,0,$11,$12)`,
        [uuidv4(), tenant_id, titulo.id, recebimento.dataPagamento, recebimento.formaPagamento, recebimento.valor, recebimento.juros, recebimento.multa, recebimento.desconto, recebimento.usuario, recibo?.id || null, recibo?.numero || null]
      );
    }
  }

  async estornarByTitulo(titulo: ContaReceberTitulo, tenant_id: number, db: Queryable = DatabaseConnection): Promise<void> {
    await db.query("update conta_receber_recebimento set estornado = 1, updated_at = now() where conta_receber_id = $1 and tenant_id = $2", [titulo.id, tenant_id]);
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
