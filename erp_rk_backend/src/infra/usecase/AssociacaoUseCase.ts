import { Associacao } from "../entity/NotaFiscalItem";
import AssociacaoRepository from "../repository/AssociacaoRepository";

export default class AssociacaoUseCase {
  constructor(readonly associacaoRepository: AssociacaoRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.associacaoRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }

  async insert(input: Input) {
    const associacao = Object.assign(new Associacao(), input.body);
    associacao.validate();
    await this.associacaoRepository.upinsert(associacao, input.tenant_id);
    return { status: 201 };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
};

type Output = {
  status: number;
  data?: any;
};
