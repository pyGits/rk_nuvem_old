import httpServer from "../../infra/server/httpServer";
import { NCMRepositoryPostgres } from "../../infra2/Repository/NCMRepository";
import GetNCMUseCase from "../../infra2/UseCase/NCM/GetNCMUseCase";
import ListNCMUseCase from "../../infra2/UseCase/NCM/ListNCMUseCase";

class V3NCMRoutes {
  getNCMUseCase: GetNCMUseCase;
  listNCMUseCase: ListNCMUseCase;

  constructor() {
    const ncmRepository = new NCMRepositoryPostgres();
    this.getNCMUseCase = new GetNCMUseCase(ncmRepository);
    this.listNCMUseCase = new ListNCMUseCase(ncmRepository);
  }

  register() {
    httpServer.register("get", "/v3/ncm", async (params: any, body: any, query: any) => {
      // Se passar código, busca NCM específico
      if (query.codigo) {
        return await this.getNCMUseCase.execute({
          codigo: query.codigo,
        });
      }

      // Se não passar código, lista todos os NCMs com filtros opcionais
      return await this.listNCMUseCase.execute({
        filter: {
          codigo: query.codigo_filter,
          descricao: query.descricao,
        },
      });
    });
  }
}

export default new V3NCMRoutes();
