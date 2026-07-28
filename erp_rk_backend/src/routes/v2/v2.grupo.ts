import { GrupoRepositoryPG } from "../../infra/repository/GrupoRepository";
import httpServer from "../../infra/server/httpServer";
import GrupoUseCase from "../../infra/usecase/GrupoUseCase";

class V2GrupoRoutes {
  grupoUseCase: GrupoUseCase;
  constructor() {
    this.grupoUseCase = new GrupoUseCase(new GrupoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/grupo/:codigo_secao", async (params: any) => {
      const output = await this.grupoUseCase.getAllByCodigoSecao({ codigo_secao: params.codigo_secao, tenant_id: params.tenant_id });
      return output.data;
    });
  }
}

export default new V2GrupoRoutes();
