import ContaPagarFactory from "../entity/Factory.ts/ContaPagarFactory";
import ContaPagarTituloListFactory from "../entity/Factory.ts/ContaPagarTituloListFactory";
import CategoriaFinanceiraLancamentoRepository from "../repository/CategoriaFinanceiraLancamentoRepository";
import ContaPagarRepository from "../repository/ContaPagarRepository";
import ContaPagarTituloPagamentoRepository from "../repository/ContaPagarTituloPagamentoRepository";
import ContaPagarTituloRepository from "../repository/ContaPagarTituloRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class ContaPagarUseCase {
  constructor(
    readonly contaPagarRepository: ContaPagarRepository,
    readonly contaPagarTituloRepository: ContaPagarTituloRepository,
    readonly contaPagarTituloPagamentoRepository: ContaPagarTituloPagamentoRepository,
    readonly categoriaFinanceiraLancamentoRepository: CategoriaFinanceiraLancamentoRepository
  ) {}
  async estornar(input: Input): Promise<Output> {
    const titulos = ContaPagarTituloListFactory.createList(input.body);
    await this.contaPagarTituloRepository.estornar(titulos, input.tenant_id);

    for (const titulo of titulos.items) {
      await this.contaPagarTituloPagamentoRepository.estornarByTitulo(titulo, input.tenant_id);
    }
    return { status: 201 };
  }
  async cancelar(input: Input): Promise<Output> {
    const titulos = ContaPagarTituloListFactory.createList(input.body);
    await this.contaPagarTituloRepository.cancelar(titulos, input.tenant_id);
    return { status: 201 };
  }
  async liquidar(input: Input): Promise<Output> {
    const titulos = ContaPagarTituloListFactory.createList(input.body);
    await this.contaPagarTituloRepository.liquidar(titulos, input.tenant_id);

    for (const titulo of titulos.items) {
      await this.contaPagarTituloPagamentoRepository.insertByTitulo(titulo, input.tenant_id);
    }
    return { status: 201 };
  }
  async getAllTitulos(input: Input) {
    const titulos = await this.contaPagarTituloRepository.getAll(input.filter, input.tenant_id);
    return { data: titulos, status: 200 };
  }

  async insert(input: Input): Promise<Output> {
    const contaPagar = ContaPagarFactory.create(input.body);

    contaPagar.codigo = await SequencialRepository.get("conta_pagar", "codigo", input.tenant_id);

    const isContaExists = await this.contaPagarRepository.getByNumeroDocumento(contaPagar.numeroDocumento, input.tenant_id);

    if (isContaExists) throw new Error("Documento já cadastrado com mesmo número !");

    await this.contaPagarRepository.insert(contaPagar, input.tenant_id);
    await this.contaPagarTituloRepository.insert(contaPagar, input.tenant_id);

    for (const cat of contaPagar.categoriaFinanceiraList) {
      await this.categoriaFinanceiraLancamentoRepository.insert(cat.categoria_codigo, cat.subcategoria_id, cat.valor, contaPagar.dataVencimento, contaPagar.lojaId, input.tenant_id);
    }

    // await this.categoriaFinanceiraLancamentoRepository.insert(conta)
    // await this.categoriaFinanceiraLancamentoRepository.insert(contaPagar.categoriaFinanceiraId, contaPagar.subCategoriaFinanceiraId, contaPagar.valorTotal(), contaPagar.dataVencimento, contaPagar.lojaId, input.tenant_id);

    return { status: 201 };
  }
  async getByCodigo(input: Input): Promise<Output> {
    const contaPagar = await this.contaPagarRepository.getByCodigo(input.codigo, input.tenant_id);
    return { status: 200, data: contaPagar };
  }
  async getAll(input: Input): Promise<Output> {
    const list = await this.contaPagarRepository.getAll(input.tenant_id);
    return { data: list, status: 200 };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  codigo?: string;
  filter?: any;
};

type Output = {
  status: number;
  data?: any;
};
