import Connection from "./Connection";
import SubCategoriaFinanceira from "../entity/SubCategoriaFinanceira";
import SubCategoriaFinanceiraFactory from "../entity/factory/SubCategoriaFinanceiraFactory";

export default interface SubCategoriaFinanceiraRepository {
  insert(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void>;
  delete(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void>;
  update(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void>;
  getAll(): Promise<SubCategoriaFinanceira[]>;
  getByCodigo(codigo: string): Promise<SubCategoriaFinanceira>;
  getAllByCategoria(codigo_categoria: string): Promise<SubCategoriaFinanceira[]>;
  getAllWithSubCategoria(): Promise<any[]>;
}
export class SubCategoriaFinanceiraRepositoryApi implements SubCategoriaFinanceiraRepository {
  async getAllWithSubCategoria(): Promise<any[]> {
    const res = await Connection.get(`/v2/sub-categoria-categoria`);
    return res.data;
  }
  async getAllByCategoria(codigo_categoria: string): Promise<SubCategoriaFinanceira[]> {
    const res = await Connection.get(`/v2/sub-categoria-financeira/${codigo_categoria}`);
    return SubCategoriaFinanceiraFactory.createList(res.data);
  }
  async delete(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void> {
    await Connection.delete(`/v2/sub-categoria-financeira/${SubCategoriaFinanceira.codigo}/${SubCategoriaFinanceira.codigo_categoria}`);
  }
  async update(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void> {
    await Connection.put("/v2/sub-categoria-financeira", SubCategoriaFinanceira);
  }
  async getByCodigo(codigo: string): Promise<SubCategoriaFinanceira> {
    const res = await Connection.get(`/v2/sub-categoria-financeira/${codigo}`);
    return SubCategoriaFinanceiraFactory.create(res.data);
  }
  async insert(SubCategoriaFinanceira: SubCategoriaFinanceira): Promise<void> {
    await Connection.post("/v2/sub-categoria-financeira", SubCategoriaFinanceira);
  }
  async getAll(): Promise<SubCategoriaFinanceira[]> {
    const res = await Connection.get("/v2/sub-categoria-financeira");
    return SubCategoriaFinanceiraFactory.createList(res.data);
  }
}
