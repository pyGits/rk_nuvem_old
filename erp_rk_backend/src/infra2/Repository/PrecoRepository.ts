import { Knex } from "knex";
import PrecoCollectionModel from "../../../../erp_rk_shared/Entity/PrecoCollectionModel";
import PostgreConnection from "./PostgreConnection";

export interface IPrecoRepository {
  getByCodigoProduto(codigoProduto: string, tenantId: number): Promise<PrecoCollectionModel>;
}

export default class PrecoRepositoryPostgres implements IPrecoRepository {
  db: Knex;
  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getByCodigoProduto(codigoProduto: string, tenantId: number): Promise<PrecoCollectionModel> {
    const precos = await this.db("precos").where({ codigo_produto: codigoProduto, tenant_id: tenantId });
    return PrecoCollectionModel.fromDatabase(precos);
  }
}
