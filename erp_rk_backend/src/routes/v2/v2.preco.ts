// import { LojaRepositoryPG } from "../../infra/repository/LojaRepository";
// import { PrecoRepositoryPG } from "../../infra/repository/PrecoRepository";
// import httpServer from "../../infra/server/httpServer";
// // import PrecoUseCase from "../../infra/usecase/PrecoUseCase";

// class V2PrecoRoutes {
//   precoUseCase: PrecoUseCase;
//   constructor() {
//     this.precoUseCase = new PrecoUseCase(new PrecoRepositoryPG(), new LojaRepositoryPG());
//   }
//   register() {
//     httpServer.register("get", "/v2/preco/:codigo_produto", async (params: any) => {
//       const output = await this.precoUseCase.getByCodigoProduto(params.codigo_produto, params.tenant_id);
//       return output.data;
//     });
//   }
// }

// export default new V2PrecoRoutes();
