import GrupoRepository from "../repository/GrupoRepository";

export default class GrupoUseCase {
  constructor(readonly grupoRepository: GrupoRepository) {}
  async getAllByCodigoSecao(input: Input): Promise<Output> {
    const res = await this.grupoRepository.getAllByCodigoSecao(input.codigo_secao, input.tenant_id);
    return { status: 200, data: res };
  }
}

type Input = {
  tenant_id: number;
  codigo_secao: string;
};

type Output = {
  status: number;
  data?: any;
};
