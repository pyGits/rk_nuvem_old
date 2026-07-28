import GrupoRepository from "../repository/GrupoRepository";

export default class ProdutoController {
  constructor(readonly grupoRepository: GrupoRepository) {}
  async getAllByCodigoSecao(codigo_secao: string): Promise<Output> {
    const res = await this.grupoRepository.getAllByCodigoSecao(codigo_secao);
    return { status: 200, data: res };
  }
}
type Output = {
  status: number;
  data?: any;
};
