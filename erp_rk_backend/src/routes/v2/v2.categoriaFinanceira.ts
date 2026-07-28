import { CategoriaFinanceiraLancamentoRepositoryPG } from "../../infra/repository/CategoriaFinanceiraLancamentoRepository";
import { CategoriaFinanceiraRepositoryPG } from "../../infra/repository/CategoriaFinanceiraRepository";
import httpServer from "../../infra/server/httpServer";
import CategoriaFinanceiraUseCase from "../../infra/usecase/CategoriaFinanceiraUseCase";

class V2CategoriaFinanceiraRoutes {
  categoriaFinanceiraUseCase: CategoriaFinanceiraUseCase;
  constructor() {
    this.categoriaFinanceiraUseCase = new CategoriaFinanceiraUseCase(new CategoriaFinanceiraRepositoryPG(), new CategoriaFinanceiraLancamentoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/categoria-financeira", async (params: any) => {
      const output = await this.categoriaFinanceiraUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/categoria-financeira", async (params: any, body: any) => {
      const output = await this.categoriaFinanceiraUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("put", "/v2/categoria-financeira", async (params: any, body: any) => {
      const output = await this.categoriaFinanceiraUseCase.update({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("delete", "/v2/categoria-financeira/:codigo", async (params: any, body: any) => {
      const output = await this.categoriaFinanceiraUseCase.delete({ codigo: params.codigo, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/categoria-financeira/sub-categorias", async (params: any) => {
      const output = await this.categoriaFinanceiraUseCase.getAllWithSubCategorias({ tenant_id: params.tenant_id });
      return output.data;
    });

    httpServer.register("get", "/v2/categoria-financeira/relatorio/balancete", async (params: any, body: any, query: any) => {
      const output = await this.categoriaFinanceiraUseCase.getBalancete({ tenant_id: params.tenant_id, filtros: query });
      return output.data;
    });
  }
}

export default new V2CategoriaFinanceiraRoutes();
