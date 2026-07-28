import CategoriaFinanceira from "../entity/CategoriaFinanceira";
import DatabaseConnection from "./DatabaseConnection";

export default interface CategoriaFinanceiraRepository {
  getAll(tenant_id: number): Promise<CategoriaFinanceira[]>;
  getAllWithSubCategorias(tenant_id: number): Promise<any[]>;
  insert(categoriaFinanceira: CategoriaFinanceira, tenant_id: number): Promise<void>;
  update(categoriaFinanceira: CategoriaFinanceira, tenant_id: number): Promise<void>;
  delete(codigo: string, tenant_id: number): Promise<void>;
}
export class CategoriaFinanceiraRepositoryPG implements CategoriaFinanceiraRepository {
  async getAllWithSubCategorias(tenant_id: number): Promise<any[]> {
    const data = await DatabaseConnection.queryAll(
      `select cf.codigo as codigo_categoria, cf.nome as nome_categoria,scf.codigo as codigo_sub, scf.nome as nome_sub from categoria_financeira cf
            left join sub_categoria_financeira scf
            on cf.codigo = scf.codigo_categoria
            where cf.tenant_id = $1 and scf.tenant_id=$1`,
      [tenant_id]
    );

    return data;
  }

  async delete(codigo: string, tenant_id: number): Promise<void> {
    if (codigo.trim() === "") throw new Error("Categoria sem código");

    await DatabaseConnection.query("delete from categoria_financeira where codigo = $1 and tenant_id =$2", [codigo, tenant_id]);
    await DatabaseConnection.query("delete from sub_categoria_financeira where codigo_categoria = $1 and tenant_id =$2", [codigo, tenant_id]);
  }
  async insert(categoriaFinanceira: CategoriaFinanceira, tenant_id: number): Promise<void> {
    if (categoriaFinanceira.codigo.trim() === "") throw new Error("Categoria sem código");
    await DatabaseConnection.query("insert into categoria_financeira(codigo,nome,tenant_id) values ($1,$2,$3)", [categoriaFinanceira.codigo, categoriaFinanceira.nome, tenant_id]);
  }
  async update(categoriaFinanceira: CategoriaFinanceira, tenant_id: number): Promise<void> {
    if (categoriaFinanceira.codigo.trim() === "") throw new Error("Categoria sem código");
    await DatabaseConnection.query("update categoria_financeira set nome = $1 where codigo =$2 and tenant_id = $3", [categoriaFinanceira.nome, categoriaFinanceira.codigo, tenant_id]);
  }
  async getAll(tenant_id: number): Promise<CategoriaFinanceira[]> {
    const data = await DatabaseConnection.queryAll("select * from categoria_financeira where tenant_id = $1", [tenant_id]);

    return data;
  }
}
