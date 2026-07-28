import { AssociacaoRepositoryPG } from "../../infra/repository/AssociacaoRepository";
import httpServer from "../../infra/server/httpServer";
import AssociacaoUseCase from "../../infra/usecase/AssociacaoUseCase";

class V2AssociacaoRoutes {
  associacaoUseCase: AssociacaoUseCase;
  constructor() {
    this.associacaoUseCase = new AssociacaoUseCase(new AssociacaoRepositoryPG());
  }
  register() {
    httpServer.register("post", "/v2/associacao", async (params: any, body: any) => {
      const output = await this.associacaoUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output;
    });
    // httpServer.register("get", "/v2/associacao/nota", async (params: any, body: any) => {
    //   const output = await this.associacaoUseCase.getByNota({ body: body, tenant_id: params.tenant_id });
    //   return output;
    // });
  }
}

export default new V2AssociacaoRoutes();
