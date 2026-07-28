import { Knex } from "knex";
import ProdutoModel from "../../../../erp_rk_shared/Entity/ProdutoModel";
import PostgreConnection from "./PostgreConnection";

export interface IProdutoRepository {
  getByCodigo(codigo: string, tenantId: number): Promise<ProdutoModel | null>;
  getAll(tenantId: number, filter?: ListProdutoFilter): Promise<ProdutoModel[]>;
}

export interface ListProdutoFilter {
  codigo_barras?: string;
  nome?: string;
  ativo?: "S" | "N";
}

export class ProdutoRepositoryPostgres implements IProdutoRepository {
  private db: Knex;
  constructor() {
    this.db = PostgreConnection.getConnection();
  }
  async getByCodigo(codigo: string, tenantId: number): Promise<ProdutoModel | null> {
    const produto = await this.db("produtos").where({ codigo: codigo, tenant_id: tenantId }).first();
    return ProdutoModel.fromDatabase(produto);
  }

  async getAll(tenantId: number, filter?: ListProdutoFilter): Promise<ProdutoModel[]> {
    let query = this.db("produtos").where({ tenant_id: tenantId });

    if (filter?.codigo_barras) {
      query = query.andWhere("codigo_barras", "ilike", `%${filter.codigo_barras}%`);
    }

    if (filter?.nome) {
      query = query.andWhere("descricao", "ilike", `%${filter.nome}%`);
    }

    if (filter?.ativo) {
      query = query.andWhere("ativo", filter.ativo);
    }

    const produtos = await query.orderBy("codigo", "asc");
    return produtos.map((p: any) => ProdutoModel.fromDatabase(p));
  }
}
