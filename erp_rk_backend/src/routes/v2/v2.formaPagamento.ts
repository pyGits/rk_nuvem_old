import { FormaPagamentoRepositoryPG } from "../../infra/repository/FormaPagamentoRepository";
import httpServer from "../../infra/server/httpServer";
import FormaPagamentoUseCase from "../../infra/usecase/FormaPagamentoUseCase";

class V2FormaPagamentoRoutes {
  formaPagamentoUseCase: FormaPagamentoUseCase;
  constructor() {
    this.formaPagamentoUseCase = new FormaPagamentoUseCase(new FormaPagamentoRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/forma-pagamento", async (params: any) => {
      const output = await this.formaPagamentoUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.forma_pagamento", "financeiro.contas_pagar", "financeiro.contas_receber");
    httpServer.register("post", "/v2/forma-pagamento", async (params: any, body: any) => {
      const output = await this.formaPagamentoUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.forma_pagamento");
    httpServer.register("put", "/v2/forma-pagamento", async (params: any, body: any) => {
      const output = await this.formaPagamentoUseCase.update({ body: body, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.forma_pagamento");
    httpServer.register("delete", "/v2/forma-pagamento/:codigo", async (params: any, body: any) => {
      const output = await this.formaPagamentoUseCase.delete({ codigo: params.codigo, tenant_id: params.tenant_id });
      return output.data;
    }, "financeiro.forma_pagamento");
  }
}

export default new V2FormaPagamentoRoutes();
