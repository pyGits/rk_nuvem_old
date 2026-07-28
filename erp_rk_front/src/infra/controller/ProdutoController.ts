import ProdutoFactory from "../entity/factory/ProdutoFactory";
import Produto, { ListaProdutos } from "../entity/Produto";
import LojaRepository from "../repository/LojaRepository";
import ProdutoRepository from "../repository/ProdutoRepository";

export default class ProdutoController {
  constructor(readonly produtoRepository: ProdutoRepository) {}
  async getAllByFilter(filter: any) {
    const produtos = await this.produtoRepository.getAllByFilter(filter);
    return produtos;
  }
  async getByCodigo(codigo_produto: string): Promise<Output> {
    if (!codigo_produto) codigo_produto = "novo";
    const res = await this.produtoRepository.getByCodigo(codigo_produto);
    return { status: 200, data: res };
  }
  async getAll(): Promise<Output> {
    const res = await this.produtoRepository.getAll();
    return { status: 200, data: res };
  }
  async insert(produto: Produto) {
    produto.validate();
    const res = await this.produtoRepository.insert(produto);
    return { status: 201, data: res };
  }
  async updatePrecosByProdutos(produtos: ListaProdutos) {
    await this.produtoRepository.updatePrecosByProdutos(produtos);
  }
  async createProdutoFromNotaCompra(item_nota: any) {
    const lojas = await LojaRepository.getAll();
    const produto = ProdutoFactory.createFromNotaFiscalCompra(item_nota, lojas);
    return produto;
  }
}
type Output = {
  status: number;
  data?: any;
};
type Input = {
  data: any;
};
