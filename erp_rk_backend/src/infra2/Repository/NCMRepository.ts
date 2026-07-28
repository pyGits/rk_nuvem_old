import NCMModel from "../../../../erp_rk_shared/Entity/NCMModel";
import PostgreConnection from "./PostgreConnection";
import { Knex } from "knex";

export interface ListNCMFilter {
  codigo?: string;
  descricao?: string;
}

export interface INCMRepository {
  getByCodigo(codigo: string): Promise<NCMModel | null>;
  getAll(filter?: ListNCMFilter): Promise<NCMModel[]>;
}

export class NCMRepositoryPostgres implements INCMRepository {
  private db: Knex;

  constructor() {
    this.db = PostgreConnection.getConnection();
  }

  async getByCodigo(codigo: string): Promise<NCMModel | null> {
    const ncm = await this.db("ncms").where({ codigo }).first();
    if (!ncm) return null;
    return ncm as NCMModel;
  }

  async getAll(filter?: ListNCMFilter): Promise<NCMModel[]> {
    let query = this.db("ncms");

    if (filter?.codigo) {
      query = query.andWhere("codigo", "ilike", `%${filter.codigo}%`);
    }

    if (filter?.descricao) {
      query = query.andWhere("descricao", "ilike", `%${filter.descricao}%`);
    }

    const ncms = await query.orderBy("codigo", "asc").limit(100);
    return ncms as NCMModel[];
  }
}
