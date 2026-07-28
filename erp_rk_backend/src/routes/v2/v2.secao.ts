import { SecaoRepositoryPG } from "../../infra/repository/SecaoRepository";
import httpServer from "../../infra/server/httpServer";
import SecaoUseCase from "../../infra/usecase/SecaoUseCase";

class V2SecaoRoutes {
  secaoUseCase: SecaoUseCase;
  constructor() {
    this.secaoUseCase = new SecaoUseCase(new SecaoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/secao", async (params: any) => {
      const output = await this.secaoUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });
  }
}

export default new V2SecaoRoutes();
