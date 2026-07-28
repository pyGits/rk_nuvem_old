import httpServer from "../../infra/server/httpServer";
import { CESTRepositoryPostgres } from "../../infra2/Repository/CESTRepository";
import GetCESTUseCase from "../../infra2/UseCase/CEST/GetCESTUseCase";
import ListCESTUseCase from "../../infra2/UseCase/CEST/ListCESTUseCase";

class V3CESTRoutes {
  getCESTUseCase: GetCESTUseCase;
  listCESTUseCase: ListCESTUseCase;

  constructor() {
    const cestRepository = new CESTRepositoryPostgres();
    this.getCESTUseCase = new GetCESTUseCase(cestRepository);
    this.listCESTUseCase = new ListCESTUseCase(cestRepository);
  }

  register() {
    httpServer.register("get", "/v3/cest", async (params: any, body: any, query: any) => {
      // Se passar código, busca CEST específico
      if (query.codigo) {
        return await this.getCESTUseCase.execute({
          codigo: query.codigo,
        });
      }

      // Se não passar código, lista todos os CESTs com filtros opcionais
      return await this.listCESTUseCase.execute({
        filter: {
          codigo: query.codigo_filter,
          ncm: query.ncm,
        },
      });
    });
  }
}

export default new V3CESTRoutes();
