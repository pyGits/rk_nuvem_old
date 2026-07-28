import { CategoriaFinanceiraLancamentoRepositoryPG } from "../../infra/repository/CategoriaFinanceiraLancamentoRepository";
import { ContaPagarRepositoryPG } from "../../infra/repository/ContaPagarRepository";
import { ContaPagarTituloPagamentoRepositoryPG } from "../../infra/repository/ContaPagarTituloPagamentoRepository";
import { ContaPagarTituloRepositoryPG } from "../../infra/repository/ContaPagarTituloRepository";
import httpServer from "../../infra/server/httpServer";
import ContaPagarUseCase from "../../infra/usecase/ContaPagarUseCase";

class V2ContaPagarRoutes {
  contaPagarUseCase: ContaPagarUseCase;
  constructor() {
    this.contaPagarUseCase = new ContaPagarUseCase(new ContaPagarRepositoryPG(), new ContaPagarTituloRepositoryPG(), new ContaPagarTituloPagamentoRepositoryPG(), new CategoriaFinanceiraLancamentoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/contaPagar/titulos", async (params: any, body: any, query: any) => {
      const output = await this.contaPagarUseCase.getAllTitulos({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("get", "/v2/contaPagar", async (params: any) => {
      const output = await this.contaPagarUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/contaPagar/:codigo", async (params: any) => {
      const output = await this.contaPagarUseCase.getByCodigo({ codigo: params.codigo, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaPagar", async (params: any, body: any) => {
      const output = await this.contaPagarUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaPagar/liquidar", async (params: any, body: any) => {
      const output = await this.contaPagarUseCase.liquidar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaPagar/estornar", async (params: any, body: any) => {
      const output = await this.contaPagarUseCase.estornar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaPagar/cancelar", async (params: any, body: any) => {
      const output = await this.contaPagarUseCase.cancelar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
  }
}

export default new V2ContaPagarRoutes();
