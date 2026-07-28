import TributacaoRepository from "../repository/TributacaoRepository";

export default class TributacaoController {
  constructor(readonly tributacaoRepository: TributacaoRepository) {}

  async getAll(): Promise<Output> {
    const data = await this.tributacaoRepository.getAll();
    return { status: 200, data: data };
  }

  async getByCodigo(codigo: string): Promise<Output> {
    const data = await this.tributacaoRepository.getByCodigo(codigo);
    return { status: 200, data: data };
  }
  async getByFiltro(filtro: FiltroTributacao): Promise<Output> {
    if (filtro.icms === 0) return { status: 200, data: "" };
    const data = await this.tributacaoRepository.getByFiltro(filtro);
    return { status: 200, data: data };
  }
}

type Output = {
  status: number;
  data?: any;
};

type FiltroTributacao = {
  cst?: string;
  cfop?: string;
  csosn?: string;
  icms?: number;
};
