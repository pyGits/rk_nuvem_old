import { ImpostosFederaisRepositoryPG } from "../../infra/repository/ImpostosFederaisRepository";
import httpServer from "../../infra/server/httpServer";
import ImpostosFederaisUseCase from "../../infra/usecase/ImpostosFederaisUseCase";

class V2ImpostosFederaisRoutes {
  impostosFederaisUseCase: ImpostosFederaisUseCase;
  constructor() {
    this.impostosFederaisUseCase = new ImpostosFederaisUseCase(new ImpostosFederaisRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/impostosFederais", async (params: any) => {
      const output = await this.impostosFederaisUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });

    httpServer.register("get", "/v2/impostosFederais/:codigo", async (params: any) => {
      const output = await this.impostosFederaisUseCase.getByCodigo(params.codigo, params.tenant_id);
      return output.data;
    });
  }
}

export default new V2ImpostosFederaisRoutes();
