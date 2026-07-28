import SecaoRepository from "../repository/SecaoRepository";

export default class SecaoController {
  constructor(readonly secaoRepository: SecaoRepository) {}
  async getAll(): Promise<Output> {
    const res = await this.secaoRepository.getAll();
    return { status: 200, data: res };
  }
}
type Output = {
  status: number;
  data?: any;
};
