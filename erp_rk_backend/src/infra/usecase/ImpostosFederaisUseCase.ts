import ImpostosFederaisRepository from "../repository/ImpostosFederaisRepository";

export default class ImpostosFederaisUseCase {
  constructor(readonly impostosFederaisRepository: ImpostosFederaisRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.impostosFederaisRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }
  async getByCodigo(codigo: string, tenant_id: number) {
    const res = await this.impostosFederaisRepository.getByCodigo(codigo, tenant_id);
    if (!res) throw new Error("Imposto federal não encontrado !");
    return { status: 200, data: res };
  }
}

type Input = {
  tenant_id: number;
};

type Output = {
  status: number;
  data?: any;
};
