import Fornecedor from "../entity/Fornecedor";
import FornecedorRepository from "../repository/FornecedorRepository";
type Output = {
  message?: string;
  data: any;
};
type Input = {
  fornecedor: any;
};

export default class FornecedorController {
  constructor(readonly fornecedorRepository: FornecedorRepository) {}

  async getAllTransportadora(): Promise<Output> {
    const res = await this.fornecedorRepository.getAllTransportadora();
    return { data: res };
  }
  async getAll(): Promise<Output> {
    const res = await this.fornecedorRepository.getAll();
    return { data: res };
  }
  async getTransportadoraByCodigo(codigo: string): Promise<Output> {
    if (codigo.trim() === "") return { data: new Fornecedor() };

    const fornecedor = await this.fornecedorRepository.getTransportadoraByCodigo(codigo);
    return { data: fornecedor };
  }
  async insert(input: Input): Promise<Output> {
    const fornecedor = Fornecedor.create(input.fornecedor);
    fornecedor.validate();
    const res = await this.fornecedorRepository.insert(input.fornecedor);
    return { message: res.data.message, data: res.data.fornecedor_id };
  }
  async update(input: Input): Promise<Output> {
    const fornecedor = Fornecedor.create(input.fornecedor);
    fornecedor.validate();
    const res = await this.fornecedorRepository.update(input.fornecedor);
    return { message: res.data.message, data: null };
  }
  async getByCNPJCPF(cnpjcpf: string): Promise<Output> {
    const fornecedor = await this.fornecedorRepository.getByCNPJCPF(cnpjcpf);
    return { data: fornecedor };
  }
}
