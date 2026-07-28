import Connection from "./Connection";
import CategoriaFinanceira from "../entity/CategoriaFinanceira";
import CategoriaFinanceiraFactory from "../entity/factory/CategoriaFinanceiraFactory";

export default interface CategoriaFinanceiraRepository {
  insert(categoriaFinanceira: CategoriaFinanceira): Promise<void>;
  delete(categoriaFinanceira: CategoriaFinanceira): Promise<void>;
  update(categoriaFinanceira: CategoriaFinanceira): Promise<void>;
  getAll(): Promise<CategoriaFinanceira[]>;
  getByCodigo(codigo: string): Promise<CategoriaFinanceira>;
  getAllWithSubCategorias(): Promise<[]>;
  getBalancete(filters: any): Promise<any>;
}
export class CategoriaFinanceiraRepositoryApi implements CategoriaFinanceiraRepository {
  async getBalancete(filters: any): Promise<any> {
    const res = await Connection.get("/v2/categoria-financeira/relatorio/balancete", { params: filters });
    return res.data;
  }
  async getAllWithSubCategorias(): Promise<[]> {
    const res = await Connection.get("/v2/categoria-financeira/sub-categorias");
    return res.data;
  }

  async delete(categoriaFinanceira: CategoriaFinanceira): Promise<void> {
    await Connection.delete(`/v2/categoria-financeira/${categoriaFinanceira.codigo}`);
  }
  async update(categoriaFinanceira: CategoriaFinanceira): Promise<void> {
    await Connection.put("/v2/categoria-financeira", categoriaFinanceira);
  }
  async getByCodigo(codigo: string): Promise<CategoriaFinanceira> {
    const res = await Connection.get(`/v2/categoria-financeira/${codigo}`);
    return CategoriaFinanceiraFactory.create(res.data);
  }
  async insert(categoriaFinanceira: CategoriaFinanceira): Promise<void> {
    await Connection.post("/v2/categoria-financeira", categoriaFinanceira);
  }
  async getAll(): Promise<CategoriaFinanceira[]> {
    const res = await Connection.get("/v2/categoria-financeira");
    return CategoriaFinanceiraFactory.createList(res.data);
  }
}
