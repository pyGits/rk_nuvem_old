import { AssociacaoRepositoryPG } from "../../infra/repository/AssociacaoRepository";
import { EstoqueRepositoryPG } from "../../infra/repository/EstoqueRepository";
import { FornecedorRepositoryPG } from "../../infra/repository/FornecedorRepository";
import { LojaRepositoryPG } from "../../infra/repository/LojaRepository";
import { NotaFiscalItemRepository } from "../../infra/repository/NotaFiscalItemRepository";
import { NotaFiscalRepositoryPG } from "../../infra/repository/NotaFiscalRepository";
import { PrecoRepositoryPG } from "../../infra/repository/PrecoRepository";
import { ProdutoRepositoryPG } from "../../infra/repository/ProdutoRepository";
import httpServer from "../../infra/server/httpServer";
import CompraUseCase from "../../infra/usecase/CompraUseCase";

export class V2CompraRoutes {
  compraUseCase: CompraUseCase;
  constructor() {
    this.compraUseCase = new CompraUseCase(new FornecedorRepositoryPG(), new AssociacaoRepositoryPG(), new LojaRepositoryPG(), new NotaFiscalRepositoryPG(), new NotaFiscalItemRepository(), new ProdutoRepositoryPG(), new PrecoRepositoryPG(), new EstoqueRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/compra/notas/sefaz", async (params: any) => {
      const output = await this.compraUseCase.getAllSefaz({ tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("get", "/v2/compra/notas/:chave/capturar", async (params: any) => {
      const output = await this.compraUseCase.capturaXml(params.chave, params.tenant_id);
      return output;
    });
    httpServer.register("get", "/v2/compra/notas/:chave/romaneio", async (params: any) => {
      const output = await this.compraUseCase.gerarRomaneio({ chave: params.chave, tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("put", "/v2/compra/notas/:chave/etapa/:etapa", async (params: any, body: any) => {
      const output = await this.compraUseCase.atualizarEtapa({ chave: params.chave, etapa: params.etapa, tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("post", "/v2/compra/notas/desfazer", async (params: any, body: any) => {
      const output = await this.compraUseCase.desfazerNota({ body: body, tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("post", "/v2/compra/notas/atualizarTransportadora", async (params: any, body: any) => {
      const output = await this.compraUseCase.atualizarTransportadora({ body: body, tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("post", "/v2/compra/notas/efetivar", async (params: any, body: any) => {
      const output = await this.compraUseCase.efetivarNota({ body: body, tenant_id: params.tenant_id });
      return output;
    });
    httpServer.register("get", "/v2/compra/notas/:chave_xml", async (params: any) => {
      const output = await this.compraUseCase.getNota({ chave_nota: params.chave_xml, tenant_id: params.tenant_id });
      return output;
    });

    httpServer.register("get", "/v2/compra/notas", async (params: any) => {
      const output = await this.compraUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });

    httpServer.registerFiles("post", "/v2/compra/uploadLoteXML", async (params: any, body: any) => {
      const output = await this.compraUseCase.uploadLoteXML(params.files, params.tenant_id);
      return { message: output.message, status: output.status };
    });
    httpServer.registerFiles("post", "/v2/compra/uploadXML", async (params: any, body: any) => {
      const output = await this.compraUseCase.uploadXML(params.files, params.tenant_id);
      return { message: output.message, status: output.status, chave_xml: output.chave_xml };
    });
  }
}

export default new V2CompraRoutes();
