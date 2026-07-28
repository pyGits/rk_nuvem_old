import CategoriaFinanceiraFactory from "../entity/Factory.ts/CategoriaFinanceiraFactory";
import CategoriaFinanceiraLancamentoRepository from "../repository/CategoriaFinanceiraLancamentoRepository";
import CategoriaFinanceiraRepository from "../repository/CategoriaFinanceiraRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class CategoriaFinanceiraUseCase {
  constructor(readonly categoriaFinanceiraRepository: CategoriaFinanceiraRepository, readonly categoriaFinanceiraLancamentoRepository: CategoriaFinanceiraLancamentoRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.categoriaFinanceiraRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }
  async getAllWithSubCategorias(input: Input): Promise<Output> {
    const res = await this.categoriaFinanceiraRepository.getAllWithSubCategorias(input.tenant_id);
    return { status: 200, data: res };
  }
  async insert(input: Input): Promise<Output> {
    const categoriaFinanceira = CategoriaFinanceiraFactory.create(input.body);
    categoriaFinanceira.codigo = await SequencialRepository.get("categoria_financeira", "codigo", input.tenant_id);
    await this.categoriaFinanceiraRepository.insert(categoriaFinanceira, input.tenant_id);
    return { status: 201 };
  }
  async update(input: Input): Promise<Output> {
    const categoriaFinanceira = CategoriaFinanceiraFactory.create(input.body);
    await this.categoriaFinanceiraRepository.update(categoriaFinanceira, input.tenant_id);
    return { status: 200 };
  }
  async delete(input: Input): Promise<Output> {
    await this.categoriaFinanceiraRepository.delete(input.codigo, input.tenant_id);
    return { status: 201 };
  }
  async getBalancete(input: Input): Promise<Output> {
    const data_categoria: any = await this.categoriaFinanceiraRepository.getAll(input.tenant_id);
    for (const categoria of data_categoria) {
      categoria.subcategoria = await this.categoriaFinanceiraLancamentoRepository.getBalanceteSubCategoria(categoria.codigo, input.filtros, input.tenant_id);

      categoria.total = categoria.subcategoria.reduce((acc: number, item: any) => {
        return acc + Number(item.total);
      }, 0);
    }

    const saldo = data_categoria.reduce((acc: number, item: any) => {
      return acc + Number(item.total);
    }, 0);

    return { status: 200, data: { categorias: data_categoria, saldo: saldo } };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  codigo?: string;
  filtros?: any;
};

type Output = {
  status: number;
  data?: any;
};
