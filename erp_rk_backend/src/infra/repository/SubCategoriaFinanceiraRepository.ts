import SubCategoriaFinanceira from "../entity/SubCategoriaFinanceira";
import DatabaseConnection from "./DatabaseConnection";

export default interface SubCategoriaFinanceiraRepository {
  getAllWithSubCategoria(tenant_id: number): Promise<any[]>;
  getAllByCategoria(codigo_categoria: string, tenant_id: number): Promise<SubCategoriaFinanceira[]>;
  insert(subCategoriaFinanceira: SubCategoriaFinanceira, tenant_id: number): Promise<void>;
  update(subCategoriaFinanceira: SubCategoriaFinanceira, tenant_id: number): Promise<void>;
  delete(codigo: string, codigo_categoria: string, tenant_id: number): Promise<void>;
}
export class SubCategoriaFinanceiraRepositoryPG implements SubCategoriaFinanceiraRepository {
  async getAllWithSubCategoria(tenant_id: number): Promise<any[]> {
    const data = await DatabaseConnection.queryAll(
      `select 
      cf.codigo as categoria_codigo,
      cf.nome as categoria_nome,

      scf.codigo as sub_categoria_codigo,
      scf.nome as sub_categoria_nome

      from categoria_financeira cf
      left join sub_categoria_financeira scf
      on cf.codigo = scf.codigo_categoria
      where cf.tenant_id = $1 and scf.tenant_id = $1`,
      [tenant_id]
    );
    return data;
  }
  async getAllByCategoria(codigo_categoria: string, tenant_id: number): Promise<SubCategoriaFinanceira[]> {
    const data = await DatabaseConnection.queryAll("select * from sub_categoria_financeira where codigo_categoria =$1 and tenant_id = $2", [codigo_categoria, tenant_id]);
    return data;
  }
  async delete(codigo: string, codigo_categoria: string, tenant_id: number): Promise<void> {
    if (codigo.trim() === "") throw new Error("Categoria sem código");
    await DatabaseConnection.query("delete from sub_categoria_financeira where codigo = $1 and codigo_categoria = $2 and tenant_id =$3", [codigo, codigo_categoria, tenant_id]);
  }
  async insert(subCategoriaFinanceira: SubCategoriaFinanceira, tenant_id: number): Promise<void> {
    if (subCategoriaFinanceira.codigo.trim() === "") throw new Error("Sub Categoria sem código");
    if (subCategoriaFinanceira.codigo_categoria.trim() === "") throw new Error("Sub Categoria sem código de categoria");
    await DatabaseConnection.query("insert into sub_categoria_financeira(codigo,codigo_categoria,nome,tipo,tenant_id) values ($1,$2,$3,$4,$5)", [subCategoriaFinanceira.codigo, subCategoriaFinanceira.codigo_categoria, subCategoriaFinanceira.nome, subCategoriaFinanceira.tipo, tenant_id]);
  }
  async update(subCategoriaFinanceira: SubCategoriaFinanceira, tenant_id: number): Promise<void> {
    if (subCategoriaFinanceira.codigo.trim() === "") throw new Error("Categoria sem código");
    await DatabaseConnection.query("update sub_categoria_financeira set nome = $1, tipo=$2 where codigo =$3 and tenant_id = $4", [subCategoriaFinanceira.nome, subCategoriaFinanceira.tipo, subCategoriaFinanceira.codigo, tenant_id]);
  }
}
