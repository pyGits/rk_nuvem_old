import Fornecedor from "../entity/Fornecedor";
import { NotaFiscal } from "../entity/NotaFiscal";
import { Associacao } from "../entity/NotaFiscalItem";
import DatabaseConnection from "./DatabaseConnection";

export default interface AssociacaoRepository {
  getAll(tenant_id: number): Promise<Associacao[]>;
  upinsert(associacao: Associacao, tenant_id: number): Promise<void>;
  getByNota(nota: NotaFiscal, fornecedor: Fornecedor, tenant_id: number): Promise<NotaFiscal>;
  get(ref_fornecedor: string, codigo_fornecedor: string, tenant_id: number): Promise<Associacao>;
}

export class AssociacaoRepositoryPG implements AssociacaoRepository {
  async get(ref_fornecedor: string, codigo_fornecedor: string, tenant_id: number): Promise<Associacao> {
    const data = await DatabaseConnection.queryFirst("select * from associacao where ref_fornecedor = $1 and codigo_fornecedor = $2 and tenant_id = $3", [ref_fornecedor, codigo_fornecedor, tenant_id]);
    if (!data) return null;
    return new Associacao(data.codigo_produto, data.codigo_fornecedor, data.ref_fornecedor, data.un_sistema, data.qtd_sistema);
  }

  async getByNota(nota: NotaFiscal, fornecedor: Fornecedor, tenant_id: number) {
    if (!fornecedor) return nota;
    const data = await DatabaseConnection.queryAll("select * from associacao where codigo_fornecedor = $1 and tenant_id = $2", [fornecedor.codigo, tenant_id]);

    data.map((row) => {
      const isItemExists = nota.items.find((item) => item.codigo === row.ref_fornecedor);
      if (isItemExists) {
        isItemExists.associacao = new Associacao(row.codigo_produto, row.codigo_fornecedor, row.ref_fornecedor, row.un_sistema, row.qtd_sistema);
      }
    });
    return nota;
  }

  async upinsert(associacao: Associacao, tenant_id: number): Promise<void> {
    await DatabaseConnection.query(
      `INSERT INTO associacao 
    (qtd_sistema, un_sistema, codigo_produto, codigo_fornecedor, ref_fornecedor, tenant_id)
   VALUES ($1, $2, $3, $4, $5, $6)
   ON CONFLICT (codigo_fornecedor, ref_fornecedor, tenant_id)
   DO UPDATE SET 
     qtd_sistema = EXCLUDED.qtd_sistema,
     un_sistema = EXCLUDED.un_sistema,
     codigo_produto = EXCLUDED.codigo_produto`,
      [associacao.qtd_fornecedor, associacao.unidade_fornecedor, associacao.codigo_produto, associacao.codigo_fornecedor, associacao.referencia_fornecedor, tenant_id]
    );
  }
  async getAll(tenant_id: number): Promise<Associacao[]> {
    const data = await DatabaseConnection.queryAll("select * from associacaos where tenant_id = $1", [tenant_id]);
    let associacaos = [];
    if (data.length == 0) return associacaos;

    data.map((associacao) => {
      associacaos.push(new Associacao(associacao.codigo_produto, associacao.codigo_fornecedor, associacao.ref_fornecedor, associacao.un_sistema, associacao.qtd_sistema));
    });

    return associacaos;
  }
}
