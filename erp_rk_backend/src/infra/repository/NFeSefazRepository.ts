import DatabaseConnection from "./DatabaseConnection";

export type DocumentoSefaz = {
  tenant_id: number;
  chave: string;
  xml?: string | null;
  cnpjcpf?: string | null;
  cnpjcpf_fornecedor?: string | null;
  nome_fornecedor?: string | null;
  nsu?: string | null;
  resumo: boolean;
};

/**
 * Persistência dos documentos capturados na SEFAZ, no banco principal (`erp`),
 * na tabela `nfe`. Substitui o antigo banco `erp_nfe` do serviço da pasta `nfe`.
 */
export class NFeSefazRepository {
  async upsertDocumento(doc: DocumentoSefaz): Promise<void> {
    await DatabaseConnection.query(
      `INSERT INTO nfe (tenant_id, chave, xml, cnpjcpf, cnpjcpf_fornecedor, nome_fornecedor, nsu, resumo, pendente, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, TRUE, now(), now())
       ON CONFLICT (tenant_id, chave) DO UPDATE SET
         -- só sobrescreve o XML quando o novo conteúdo for mais completo (não regride de nota completa p/ resumo)
         xml = COALESCE(NULLIF(EXCLUDED.xml, ''), nfe.xml),
         cnpjcpf = COALESCE(EXCLUDED.cnpjcpf, nfe.cnpjcpf),
         cnpjcpf_fornecedor = COALESCE(EXCLUDED.cnpjcpf_fornecedor, nfe.cnpjcpf_fornecedor),
         nome_fornecedor = COALESCE(EXCLUDED.nome_fornecedor, nfe.nome_fornecedor),
         nsu = COALESCE(EXCLUDED.nsu, nfe.nsu),
         resumo = CASE WHEN EXCLUDED.resumo = FALSE THEN FALSE ELSE nfe.resumo END,
         updated_at = now()`,
      [doc.tenant_id, doc.chave, doc.xml || null, doc.cnpjcpf || null, doc.cnpjcpf_fornecedor || null, doc.nome_fornecedor || null, doc.nsu || null, doc.resumo]
    );
  }

  async getByChave(chave: string, tenant_id: number): Promise<any> {
    return await DatabaseConnection.queryFirst("SELECT * FROM nfe WHERE chave = $1 AND tenant_id = $2", [chave, tenant_id]);
  }

  /** Notas ainda pendentes de entrada no ERP — alimenta a aba "Notas na Sefaz". */
  async getPendentes(tenant_id: number): Promise<any[]> {
    return await DatabaseConnection.queryAll(
      `SELECT chave, cnpjcpf, cnpjcpf_fornecedor, nome_fornecedor, pendente, resumo
       FROM nfe WHERE tenant_id = $1 AND pendente = TRUE
       ORDER BY created_at DESC`,
      [tenant_id]
    );
  }

  async marcarProcessada(chave: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("UPDATE nfe SET pendente = FALSE, updated_at = now() WHERE chave = $1 AND tenant_id = $2", [chave, tenant_id]);
  }
}

export default new NFeSefazRepository();
