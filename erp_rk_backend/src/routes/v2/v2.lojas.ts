import { LojaRepositoryPG } from "../../infra/repository/LojaRepository";
import httpServer from "../../infra/server/httpServer";
import LojaUseCase from "../../infra/usecase/LojaUseCase";

class V2LojaRoutes {
  lojaUseCase: LojaUseCase;
  constructor() {
    this.lojaUseCase = new LojaUseCase(new LojaRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/loja", async (params: any, body: any, query: any) => {
      const output = await this.lojaUseCase.getAll({ tenant_id: params.tenant_id, filtro: query });
      return output.data;
    });
    httpServer.register("get", "/v2/loja/:codigo", async (params: any) => {
      const output = await this.lojaUseCase.getByCodigo({ codigo: params.codigo, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.registerFile("post", "/v2/loja/:lojaId/certificado", async (params: any) => {
      const output = await this.lojaUseCase.uploadCertificado({ file: params.file, senha: params.body?.senha, lojaId: params.params.lojaId, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/loja/:lojaId/certificado/senha", async (params: any, body: any) => {
      await this.lojaUseCase.atualizarSenhaCertificado({ senha: body.senha, lojaId: params.lojaId, tenant_id: params.tenant_id });
    });
  }
}

export default new V2LojaRoutes();
