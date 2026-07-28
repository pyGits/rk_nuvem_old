import ImpostosFederaisRepository from "../repository/ImpostosFederaisRepository";

export default class ProdutoController {
  constructor(readonly impostosFederaisRepository: ImpostosFederaisRepository) {}
  async getAll(): Promise<Output> {
    const res = await this.impostosFederaisRepository.getAll();
    return { status: 200, data: res };
  }
  async getByCodigo(codigo: string): Promise<Output> {
    const res = await this.impostosFederaisRepository.getByCodigo(codigo);
    return { status: 200, data: res };
  }
}
type Output = {
  status: number;
  data?: any;
};
