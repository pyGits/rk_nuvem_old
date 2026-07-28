import TributacaoModel from "../../../../erp_rk_shared/Entity/TributacaoModel";
import PostgreConnection from "./PostgreConnection";
export interface ITributacaoRepository {
  getAll(tenant_id: number): Promise<TributacaoModel[]>;
  getByCodigo(codigo: string, tenant_id: number): Promise<TributacaoModel>;
}

export class TributacaoRepositoryPostgres implements ITributacaoRepository {
  private readonly db: any;

  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getAll(tenant_id: number): Promise<TributacaoModel[]> {
    const rows = await this.db("tributacaos").where({ tenant_id });

    return rows.map((row: any) => TributacaoModel.fromDatabase(row));
  }
  async getByCodigo(codigo: string, tenant_id: number): Promise<TributacaoModel | null> {
    console.log("row", "codigo:", codigo, "tenant_id:", tenant_id);
    const row = await this.db("tributacaos").where({ codigo, tenant_id }).first();
    return TributacaoModel.fromDatabase(row);
  }
}
