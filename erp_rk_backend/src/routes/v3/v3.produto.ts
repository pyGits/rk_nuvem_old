import httpServer from "../../infra/server/httpServer";
import PrecoRepositoryPostgres from "../../infra2/Repository/PrecoRepository";
import { ProdutoRepositoryPostgres } from "../../infra2/Repository/ProdutoRepository";
import GetProdutoUseCase, { TipoPesquisaProduto } from "../../infra2/UseCase/Produto/GetProdutoUseCase";
import ListProdutoUseCase from "../../infra2/UseCase/Produto/ListProdutoUseCase";
import { LojaRepositoryPostgres } from "../../infra2/Repository/LojaRepository";
import { TributacaoRepositoryPostgres } from "../../infra2/Repository/TributacaoRepository";
import { EstoqueRepositoryPostgres } from "../../infra2/Repository/EstoqueRepository";
import { NCMRepositoryPostgres } from "../../infra2/Repository/NCMRepository";
import { CESTRepositoryPostgres } from "../../infra2/Repository/CESTRepository";

class V3ProdutoRoutes {
  getProdutoUseCase: GetProdutoUseCase;
  listProdutoUseCase: ListProdutoUseCase;

  constructor() {
    const produtoRepository = new ProdutoRepositoryPostgres();
    this.getProdutoUseCase = new GetProdutoUseCase(
      produtoRepository,
      new PrecoRepositoryPostgres(),
      new LojaRepositoryPostgres(),
      new TributacaoRepositoryPostgres(),
      new EstoqueRepositoryPostgres(),
      new NCMRepositoryPostgres(),
      new CESTRepositoryPostgres()
    );
    this.listProdutoUseCase = new ListProdutoUseCase(produtoRepository);
  }
  register() {
    httpServer.register("get", "/v3/produto", async (params: any, body: any, query: any) => {
      if (query.codigo) {
        return await this.getProdutoUseCase.execute({
          tipo: TipoPesquisaProduto.codigo,
          valor: query.codigo,
          tenantId: params.tenant_id,
        });
      }
      if (query.codigo_barras) {
        return await this.getProdutoUseCase.execute({
          tipo: TipoPesquisaProduto.codigo_barras,
          valor: query.codigo_barras,
          tenantId: params.tenant_id,
        });
      }

      // Se não passar código ou código de barras, lista todos os produtos
      return await this.listProdutoUseCase.execute({
        tenantId: params.tenant_id,
        filter: {
          codigo_barras: query.codigo_barras_filter,
          nome: query.nome,
          ativo: query.ativo,
        },
      });
    });
  }
}
export default new V3ProdutoRoutes();
