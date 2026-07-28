import DatabaseConnection from "./DatabaseConnection";

export interface CodigoBarrasAuxiliar {
  codigo_produto: string;
  codigo_barras: string;
}

export default interface ProdutoCodigoBarrasRepository {
  insert(codigo: CodigoBarrasAuxiliar, tenant_id: number): Promise<void>;
}

export class ProdutoCodigoBarrasRepositoryPG implements ProdutoCodigoBarrasRepository {
  async insert(codigo: CodigoBarrasAuxiliar, tenant_id: number): Promise<void> {
    // Normaliza igual ao código de barras principal (ProdutoRepository.insert):
    // remove zeros à esquerda para que o Sync/PDV consiga casar a busca.
    const codigoBarras = String(codigo.codigo_barras).replace(/^0+/, "");

    await DatabaseConnection.query(
      `INSERT INTO produto_codigos_barras (codigo_produto, codigo_barras, tenant_id, created_at, updated_at)
       VALUES ($1, $2, $3, now(), now())
       ON CONFLICT (tenant_id, codigo_barras) DO NOTHING`,
      [codigo.codigo_produto, codigoBarras, tenant_id],
    );
  }
}
