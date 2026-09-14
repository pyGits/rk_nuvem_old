import { SubCategoriaFinanceiraRepositoryPG } from "../../infra/repository/SubCategoriaFinanceiraRepository";
import httpServer from "../../infra/server/httpServer";
import SubCategoriaFinanceiraUseCase from "../../infra/usecase/SubCategoriaFinanceiraUseCase";

class V2SubCategoriaFinanceiraRoutes {
  subCategoriaFinanceirairaUseCase: SubCategoriaFinanceiraUseCase;
  constructor() {
    this.subCategoriaFinanceirairaUseCase = new SubCategoriaFinanceiraUseCase(new SubCategoriaFinanceiraRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/sub-categoria-categoria", async (params: any) => {
      const output = await this.subCategoriaFinanceirairaUseCase.getAllWithSubCategoria({ tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.categoria", "financeiro.contas_pagar", "financeiro.contas_receber", "relatorio.financeiro.balancete");
    httpServer.register("get", "/v2/sub-categoria-financeira/:codigo_categoria", async (params: any) => {
      const output = await this.subCategoriaFinanceirairaUseCase.getAllByCategoria({ codigo: params.codigo_categoria, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.categoria", "financeiro.contas_pagar", "financeiro.contas_receber", "relatorio.financeiro.balancete");
    httpServer.register("post", "/v2/sub-categoria-financeira", async (params: any, body: any) => {
      const output = await this.subCategoriaFinanceirairaUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.categoria");
    httpServer.register("put", "/v2/sub-categoria-financeira", async (params: any, body: any) => {
      const output = await this.subCategoriaFinanceirairaUseCase.update({ body: body, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.categoria");
    httpServer.register("delete", "/v2/sub-categoria-financeira/:codigo/:codigo_categoria", async (params: any, body: any) => {
      const output = await this.subCategoriaFinanceirairaUseCase.delete({ codigo: params.codigo, codigo_categoria: params.codigo_categoria, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.categoria");
  }
}

export default new V2SubCategoriaFinanceiraRoutes();
