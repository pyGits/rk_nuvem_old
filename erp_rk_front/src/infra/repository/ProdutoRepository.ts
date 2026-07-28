import ProdutoFactory from "../entity/factory/ProdutoFactory";
import Produto, { ListaProdutos } from "../entity/Produto";
import Connection from "./Connection";

export default interface ProdutoRepository {
  getAll(): Promise<Produto[]>;
  insert(produto: Produto): Promise<any>;
  delete(codigo: string): Promise<void>;
  getByCodigo(codigo_produto: string): Promise<Produto>;
  updatePrecosByProdutos(produtos: ListaProdutos): Promise<void>;
  getAllByFilter(filter: any): Promise<Produto[]>;
}
export class ProdutoRepositoryAPI implements ProdutoRepository {
  async getAllByFilter(filter: any): Promise<Produto[]> {
    const res = await Connection.get("/v2/produto/filtro", { params: filter });
    return ProdutoFactory.createFromApiList(res.data);
  }

  async updatePrecosByProdutos(produtos: ListaProdutos): Promise<void> {
    await Connection.put("/v2/produtos/precos", produtos.items);
  }
  async getByCodigo(codigo_produto: string): Promise<Produto> {
    const res = await Connection.get(`/v2/produto/${codigo_produto}`);
    const data = res.data;
    return Object.assign(new Produto(), data);
  }
  async delete(codigo: string): Promise<void> {
    await Connection.delete(`/v2/produto/${codigo}`);
  }
  async insert(produto: Produto): Promise<any> {
    const res = await Connection.post("/v2/produto", produto);
    return res.data;
  }
  async getAll(): Promise<Produto[]> {
    const res = await Connection.get("/v2/produto");
    const data = res.data;
    if (!Array.isArray(data) || data.length === 0) return [];

    const produtos: Produto[] = data.map((produto: any) => Object.assign(new Produto(), produto));

    return produtos;
  }
}
