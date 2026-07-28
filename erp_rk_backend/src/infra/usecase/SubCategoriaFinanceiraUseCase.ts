import SubCategoriaFinanceiraFactory from "../entity/Factory.ts/SubCategoriaFinanceiraFactory";
import SubCategoriaFinanceiraRepository from "../repository/SubCategoriaFinanceiraRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class SubCategoriaFinanceiraUseCase {
  constructor(readonly subCategoriaFinanceiraRepository: SubCategoriaFinanceiraRepository) {}
  async getAllWithSubCategoria(input: Input): Promise<Output> {
    const res = await this.subCategoriaFinanceiraRepository.getAllWithSubCategoria(input.tenant_id);
    return { status: 200, data: res };
  }
  async getAllByCategoria(input: Input): Promise<Output> {
    const res = await this.subCategoriaFinanceiraRepository.getAllByCategoria(input.codigo, input.tenant_id);
    return { status: 200, data: res };
  }
  async insert(input: Input): Promise<Output> {
    const subCategoriaFinanceira = SubCategoriaFinanceiraFactory.create(input.body);
    subCategoriaFinanceira.codigo = await SequencialRepository.get("sub_categoria_financeira", "codigo", input.tenant_id);
    await this.subCategoriaFinanceiraRepository.insert(subCategoriaFinanceira, input.tenant_id);
    return { status: 201 };
  }
  async update(input: Input): Promise<Output> {
    const subCategoriaFinanceira = SubCategoriaFinanceiraFactory.create(input.body);
    await this.subCategoriaFinanceiraRepository.update(subCategoriaFinanceira, input.tenant_id);
    return { status: 200 };
  }
  async delete(input: Input): Promise<Output> {
    await this.subCategoriaFinanceiraRepository.delete(input.codigo, input.codigo_categoria, input.tenant_id);
    return { status: 201 };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  codigo?: string;
  codigo_categoria?: string;
};

type Output = {
  status: number;
  data?: any;
};
