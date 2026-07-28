import { TributacaoRepositoryPG } from "../../infra/repository/TributacaoRepository";
import httpServer from "../../infra/server/httpServer";
import TributacaoUseCase from "../../infra/usecase/TributacaoUseCase";

class V2TributacaoRoutes {
  tributacaoUseCase: TributacaoUseCase;
  constructor() {
    this.tributacaoUseCase = new TributacaoUseCase(new TributacaoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/tributacao", async (params: any, body: any, query: any) => {
      const filtros = query;
      const isFilterExists = Object.keys(filtros).length > 0;
      if (!isFilterExists) {
        const output = await this.tributacaoUseCase.getAll({ tenant_id: params.tenant_id });
        return output.data;
      }
      const output = await this.tributacaoUseCase.getByFiltro(filtros, params.tenant_id);
      return output.data;
    });

    httpServer.register("get", "/v2/tributacao/:codigo", async (params: any) => {
      const output = await this.tributacaoUseCase.getByCodigo(params.codigo, params.tenant_id);
      return output.data;
    });
  }
}

export default new V2TributacaoRoutes();
