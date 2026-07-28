import CESTModel from "../../../../erp_rk_shared/Entity/CESTModel";
import PostgreConnection from "./PostgreConnection";
import { Knex } from "knex";

export interface ListCESTFilter {
  codigo?: string;
  ncm?: string;
}

export interface ICESTRepository {
  getByCodigo(codigo: string): Promise<CESTModel | null>;
  getAll(filter?: ListCESTFilter): Promise<CESTModel[]>;
}

export class CESTRepositoryPostgres implements ICESTRepository {
  private db: Knex;

  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getByCodigo(codigo: string): Promise<CESTModel | null> {
    const cest = await this.db("cests").where({ cest: codigo }).first();
    if (!cest) return null;
    return new CESTModel(cest.cest, cest.ncm || "", cest.descricao || "");
  }

  async getAll(filter?: ListCESTFilter): Promise<CESTModel[]> {
    let query = this.db("cests");

    if (filter?.codigo) {
      query = query.andWhere("cest", "ilike", `%${filter.codigo}%`);
    }

    if (filter?.ncm) {
      const ncmSanitized = filter.ncm.replace(/\D/g, "");
      query = query.andWhere("ncm", ncmSanitized);
    }

    const cests = await query.orderBy("cest", "asc").limit(100);
    return cests.map((cest: any) => new CESTModel(cest.cest, cest.ncm || "", cest.descricao || ""));
  }
}
