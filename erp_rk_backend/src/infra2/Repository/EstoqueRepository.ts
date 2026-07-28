import EstoqueCollectionModel from "../../../../erp_rk_shared/Entity/EstoqueCollectionModel";
import PostgreConnection from "./PostgreConnection";

export interface IEstoqueRepository {
  getByCodigoProduto(codigo: string, tenant_id: number): Promise<EstoqueCollectionModel>;
}

export class EstoqueRepositoryPostgres implements IEstoqueRepository {
  private readonly db: any;

  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getByCodigoProduto(codigo: string, tenant_id: number): Promise<EstoqueCollectionModel> {
    const row = await this.db("estoques").where({ codigo_produto: codigo, tenant_id: tenant_id });
    return EstoqueCollectionModel.fromDatabase(row);
  }
}
