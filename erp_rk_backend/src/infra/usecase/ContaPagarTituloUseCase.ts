import ContaPagarTituloFactory from "../entity/Factory.ts/ContaPagarTituloFactory";
import ContaPagarTituloRepository from "../repository/ContaPagarTituloRepository";

export default class ContaPagarTituloUseCase {
  constructor(readonly contaPagarTituloRepository: ContaPagarTituloRepository) {}
  async update(input: Input): Promise<Output> {
    const titulo = ContaPagarTituloFactory.create(input.body);
    const res = await this.contaPagarTituloRepository.update(titulo, input.tenant_id);
    return { status: 200, data: res };
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
