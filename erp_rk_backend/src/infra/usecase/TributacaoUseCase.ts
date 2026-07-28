import TributacaoRepository from "../repository/TributacaoRepository";

export default class TributacaoUseCase {
  constructor(readonly tributacaoRepository: TributacaoRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.tributacaoRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }

  async getByCodigo(codigo: string, tenant_id: number) {
    const tributacao = await this.tributacaoRepository.getByCodigo(codigo, tenant_id);
    if (!tributacao) throw new Error("Tributação não encontrada");
    return { status: 200, data: tributacao };
  }
  async getByFiltro(filtro: { icms: string }, tenant_id: number) {
    const tributacao = await this.tributacaoRepository.getByFiltro(filtro, tenant_id);
    return { status: 200, data: tributacao };
  }
}

type Input = {
  tenant_id: number;
};

type Output = {
  status: number;
  data?: any;
};
