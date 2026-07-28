import { ContaPagarTituloRepositoryPG } from "../../infra/repository/ContaPagarTituloRepository";
import httpServer from "../../infra/server/httpServer";
import ContaPagarTituloUseCase from "../../infra/usecase/ContaPagarTituloUseCase";

class V2ContaPagarTituloRoutes {
  ContaPagarTituloUseCase: ContaPagarTituloUseCase;
  constructor() {
    this.ContaPagarTituloUseCase = new ContaPagarTituloUseCase(new ContaPagarTituloRepositoryPG());
  }
  register() {
    httpServer.register("put", "/v2/contaPagar/titulo", async (params: any, body: any) => {
      const output = await this.ContaPagarTituloUseCase.update({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
  }
}

export default new V2ContaPagarTituloRoutes();
