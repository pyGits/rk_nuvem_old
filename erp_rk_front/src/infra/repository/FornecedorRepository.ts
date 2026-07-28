import Fornecedor from "../entity/Fornecedor";
import Connection from "./Connection";

export default interface FornecedorRepository {
  insert(fornecedor: Fornecedor): Promise<any>;
  getByCNPJCPF(cnpjcpf: string): Promise<Fornecedor | undefined>;
  update(fornecedor: Fornecedor): Promise<any>;
  getAll(): Promise<Fornecedor[]>;
  getAllByFilter(filter: any): Promise<Fornecedor[]>;
  getAllTransportadora(): Promise<Fornecedor[]>;
  getTransportadoraByCodigo(codigo: string): Promise<Fornecedor>;
}

export class FornecedorRepositoryApi implements FornecedorRepository {
  async getTransportadoraByCodigo(codigo: string): Promise<Fornecedor> {
    const res = await Connection.get(`/v2/fornecedor/transportadora/${codigo}`);
    return res.data;
  }
  async getAllByFilter(filter: any): Promise<Fornecedor[]> {
    const res = await Connection.get("/v2/fornecedor/filtro", { params: filter });
    return res.data;
  }
  async getAll(): Promise<Fornecedor[]> {
    const res = await Connection.get("/v2/fornecedor");
    return res.data.map((data: any) => Fornecedor.create(data));
  }
  async getAllTransportadora(): Promise<Fornecedor[]> {
    const res = await Connection.get("/v2/fornecedor/transportadora");
    return res.data.map((data: any) => Fornecedor.create(data));
  }
  async getByCNPJCPF(cnpjcpf: string): Promise<Fornecedor | undefined> {
    if (!cnpjcpf) throw new Error("Obrigatório CNPJCPF");
    const res = await Connection.get(`/v2/fornecedor/cnpjcpf/${cnpjcpf}`);
    if (res.status !== 200) return undefined;
    return Fornecedor.create(res.data);
  }
  async insert(fornecedor: Fornecedor): Promise<any> {
    return await Connection.post("/v2/fornecedor", fornecedor);
  }
  async update(fornecedor: Fornecedor): Promise<any> {
    return await Connection.put("/v2/fornecedor", fornecedor);
  }
}
