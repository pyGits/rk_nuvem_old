import ProdutoModel from "../../../../../erp_rk_shared/Entity/ProdutoModel";
import { IProdutoRepository, ListProdutoFilter } from "../../Repository/ProdutoRepository";

export interface ListProdutoInput {
  tenantId: number;
  filter?: ListProdutoFilter;
}

export interface ListProdutoOutput {
  produtos: ProdutoModel[];
  total: number;
}

export default class ListProdutoUseCase {
  private produtoRepository: IProdutoRepository;

  constructor(produtoRepository: IProdutoRepository) {
    this.produtoRepository = produtoRepository;
  }

  async execute(input: ListProdutoInput): Promise<ListProdutoOutput> {
    const produtos = await this.produtoRepository.getAll(input.tenantId, input.filter);

    return {
      produtos,
      total: produtos.length,
    };
  }
}
