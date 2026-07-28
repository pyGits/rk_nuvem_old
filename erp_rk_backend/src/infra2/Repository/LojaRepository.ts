import LojaModel from "../../../../erp_rk_shared/Entity/LojaModel";
import PostgreConnection from "./PostgreConnection";

export default interface ILojaRepository {
  getAll(tenant_id: number): Promise<LojaModel[]>;
}

export class LojaRepositoryPostgres implements ILojaRepository {
  private readonly db: any;

  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getAll(tenant_id: number): Promise<LojaModel[]> {
    const rows = await this.db("lojas").where({ tenant_id });

    return rows.map((row: any) => LojaModel.fromDatabase(row));
  }
}
