import Fornecedor from "../entity/Fornecedor";
import FornecedorRepository from "../repository/FornecedorRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class FornecedorUseCasePG {
  constructor(readonly fornecedorRepository: FornecedorRepository) {}
  async getTransportadoraByCodigo(input: Input): Promise<Output> {
    const data = await this.fornecedorRepository.getTransportadoraByCodigo(input.codigo, input.tenant_id);
    if (!data) throw new Error("Transportadora não encontrada");
    return { status: 200, data: data };
  }
  async getAllByFilter(input: Input): Promise<Output> {
    const list = await this.fornecedorRepository.getAllByFilter(input.filter, input.tenant_id);
    return { status: 200, data: list };
  }
  async getAllTransportadora(input: Input): Promise<Output> {
    const list = await this.fornecedorRepository.getAllTransportadora(input.tenant_id);
    return { status: 200, data: list };
  }
  async getAll(input: Input): Promise<Output> {
    const list = await this.fornecedorRepository.getAll(input.tenant_id);
    return { status: 200, data: list };
  }
  async getByCNPJCPF(input: { cnpjcpf: string; tenant_id: number }): Promise<Output> {
    const data = await this.fornecedorRepository.getByCNPJCPF(input.cnpjcpf, input.tenant_id);
    if (!data) throw new Error("Fornecedor não encontrado !");
    return { status: 200, data: data };
  }
  async delete(input: Input): Promise<Output> {
    const fornecedor = Fornecedor.create(input.body);
    await this.fornecedorRepository.delete(fornecedor.codigo, input.tenant_id);
    return { status: 201, message: "Fornecedor deletado com sucesso !", data: null };
  }
  async insert(input: Input): Promise<Output> {
    const fornecedor = Fornecedor.create(input.body);

    const isFornecedorExists = await this.fornecedorRepository.getByCNPJCPF(fornecedor.cnpjcpf, input.tenant_id);
    if (isFornecedorExists) throw new Error("Fornecedor já cadastrado com o mesmo CNPJ/CPF!");

    fornecedor.codigo = await SequencialRepository.get("fornecedors", "codigo", input.tenant_id);

    await this.fornecedorRepository.insert(fornecedor, input.tenant_id);

    return { status: 201, message: "Fornecedor inserido com sucesso !", data: fornecedor.codigo };
  }
  async update(input: Input): Promise<Output> {
    const fornecedor = Fornecedor.create(input.body);

    const isFornecedorExists = await this.fornecedorRepository.getByCodigo(fornecedor.codigo, input.tenant_id);
    if (!isFornecedorExists) throw new Error("Fornecedor não encontrado");

    await this.fornecedorRepository.update(fornecedor, input.tenant_id);
    return { status: 201, message: "Fornecedor atualizado com sucesso !", data: null };
  }
}

type Input = {
  body?: any;
  codigo?: string;
  tenant_id: number;
  filter?: any;
};

type Output = {
  status: number;
  message?: string;
  data?: any;
};
