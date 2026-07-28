import FornecedorRepository, { FornecedorRepositoryApi } from "../repository/FornecedorRepository";

class FornecedorService {
  fornecedorRepository: FornecedorRepository;
  constructor() {
    this.fornecedorRepository = new FornecedorRepositoryApi();
  }
  async getAll(): Promise<GetAllOutput> {
    const fornecedores = await this.fornecedorRepository.getAll();
    return { fornecedores: fornecedores };
  }
  async getAllByFilter(filter: any) {
    const fornecedores = await this.fornecedorRepository.getAllByFilter(filter);
    return fornecedores;
  }
  async getByCNPJCPF(cnpjcpf: string) {
    const fornecedor = await this.fornecedorRepository.getByCNPJCPF(cnpjcpf);
    return fornecedor;
  }
}

type GetAllOutput = {
  fornecedores: any;
};

export default new FornecedorService();
