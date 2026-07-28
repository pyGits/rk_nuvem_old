import { EstoqueRepositoryPG } from "../../infra/repository/EstoqueRepository";
import { LojaRepositoryPG } from "../../infra/repository/LojaRepository";
import { PrecoRepositoryPG } from "../../infra/repository/PrecoRepository";
import { ProdutoRepositoryPG } from "../../infra/repository/ProdutoRepository";
import httpServer from "../../infra/server/httpServer";
import ProdutoUseCase from "../../infra/usecase/ProdutoUseCase";

class V2ProdutoRoutes {
  produtoUseCase: ProdutoUseCase;
  constructor() {
    this.produtoUseCase = new ProdutoUseCase(new ProdutoRepositoryPG(), new PrecoRepositoryPG(), new LojaRepositoryPG(), new EstoqueRepositoryPG());
  }
  register() {
    httpServer.register("get", "/v2/produto/filtro", async (params: any, body: any, query: any) => {
      const output = await this.produtoUseCase.getAllByFilter({ tenant_id: params.tenant_id, filter: query });
      return output.data;
    });
    httpServer.register("put", "/v2/produtos/precos", async (params: any, body: any) => {
      const output = await this.produtoUseCase.updatePrecosByProdutos({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("post", "/v2/produto", async (params: any, body: any) => {
      const output = await this.produtoUseCase.insert({ body: body, tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/produto", async (params: any) => {
      const output = await this.produtoUseCase.getAll({ tenant_id: params.tenant_id });
      return output.data;
    });
    httpServer.register("get", "/v2/produto/:codigo_produto", async (params: any) => {
      const output = await this.produtoUseCase.getByCodigo(params.codigo_produto, params.tenant_id);
      return output.data;
    });
  }
}

export default new V2ProdutoRoutes();
