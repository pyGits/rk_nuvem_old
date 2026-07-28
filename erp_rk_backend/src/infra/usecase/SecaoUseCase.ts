import SecaoRepository from "../repository/SecaoRepository";

export default class SecaoUseCase {
  constructor(readonly secaoRepository: SecaoRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.secaoRepository.getAll(input.tenant_id);
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
