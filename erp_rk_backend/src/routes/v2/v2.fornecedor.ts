import { FornecedorRepositoryPG } from "../../infra/repository/FornecedorRepository";
import httpServer from "../../infra/server/httpServer";
import FornecedorUseCase from "../../infra/usecase/FornecedorUseCase";

export class V2FornecedorRoutes {
  fornecedorUseCase: FornecedorUseCase;
  constructor() {
    this.fornecedorUseCase = new FornecedorUseCase(new FornecedorRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/fornecedor/filtro", async (params: any, body: any, query: any) => {
      const output = await this.fornecedorUseCase.getAllByFilter({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("post", "/v2/fornecedor", async (params: any, body: any) => {
      const output = await this.fornecedorUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return { message: output.message, fornecedor_id: output.data };
    });
    httpServer.register("get", "/v2/fornecedor", async (params: any) => {
      const output = await this.fornecedorUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/fornecedor/transportadora", async (params: any) => {
      const output = await this.fornecedorUseCase.getAllTransportadora({ tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/fornecedor/cnpjcpf/:cnpjcpf", async (params: any) => {
      const output = await this.fornecedorUseCase.getByCNPJCPF({ cnpjcpf: params.cnpjcpf, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/fornecedor/transportadora/:codigo", async (params: any) => {
      const output = await this.fornecedorUseCase.getTransportadoraByCodigo({ codigo: params.codigo, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("put", "/v2/fornecedor", async (params: any, body: any) => {
      const output = await this.fornecedorUseCase.update({ body: body, tenant_id: params.tenant_id });
      return { message: output.message };
    });
  }
}

export default new V2FornecedorRoutes();
