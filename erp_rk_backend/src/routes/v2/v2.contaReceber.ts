import { ContaReceberRecebimentoRepositoryPG } from "../../infra/repository/ContaReceberRecebimentoRepository";
import { ContaReceberReciboRepositoryPG } from "../../infra/repository/ContaReceberReciboRepository";
import { ContaReceberRepositoryPG } from "../../infra/repository/ContaReceberRepository";
import { LojaRepositoryPG } from "../../infra/repository/LojaRepository";
import httpServer from "../../infra/server/httpServer";
import ContaReceberUseCase from "../../infra/usecase/ContaReceberUseCase";

class V2ContaReceberRoutes {
  contaReceberUseCase: ContaReceberUseCase;
  constructor() {
    this.contaReceberUseCase = new ContaReceberUseCase(new ContaReceberRepositoryPG(), new ContaReceberRecebimentoRepositoryPG(), new ContaReceberReciboRepositoryPG(), new LojaRepositoryPG());
  }
  register() {
    // Rota do Sync_NUVEM, que le CUPOM_CREDIARIO em cada PDV. Fica junto das
    // demais do modulo, mas sem o /v2 porque o agente Delphi so marca o titulo
    // como enviado quando a resposta e exatamente {"message":"SINCRONIZADO"}.
    httpServer.register("post", "/contaReceber", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.sincronizar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });

    httpServer.register("get", "/v2/contaReceber/titulos", async (params: any, body: any, query: any) => {
      const output = await this.contaReceberUseCase.getAllTitulos({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("get", "/v2/contaReceber/saldoClientes", async (params: any, body: any, query: any) => {
      const output = await this.contaReceberUseCase.getSaldoClientes({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });

    // Recibos: a lista do que ja foi liquidado e a 2a via em PDF. E por aqui
    // que se confere um recebimento depois de feito - o titulo liquidado sai da
    // grade de titulos assim que a situacao filtrada e "em aberto".
    httpServer.register("get", "/v2/contaReceber/recibos", async (params: any, body: any, query: any) => {
      const output = await this.contaReceberUseCase.getRecibos({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("get", "/v2/contaReceber/recibo", async (params: any, body: any, query: any) => {
      const output = await this.contaReceberUseCase.gerarRecibo({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("post", "/v2/contaReceber/estornarRecibo", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.estornarRecibo({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/contaReceber/extrato", async (params: any, body: any, query: any) => {
      const output = await this.contaReceberUseCase.getExtrato({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("post", "/v2/contaReceber", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaReceber/receber", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.receber({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaReceber/estornar", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.estornar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/contaReceber/cancelar", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.cancelar({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("put", "/v2/contaReceber/titulo", async (params: any, body: any) => {
      const output = await this.contaReceberUseCase.update({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
  }
}

export default new V2ContaReceberRoutes();
