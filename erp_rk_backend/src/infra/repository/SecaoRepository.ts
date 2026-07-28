import Secao from "../entity/Secao";
import DatabaseConnection from "./DatabaseConnection";

export default interface SecaoRepository {
  getAll(tenant_id: number): Promise<Secao[]>;
}
export class SecaoRepositoryPG implements SecaoRepository {
  async getAll(tenant_id: number): Promise<Secao[]> {
    const data = await DatabaseConnection.queryAll("select * from secaos where tenant_id = $1", [tenant_id]);
    let secaos = [];
    if (data.length == 0) return secaos;

    data.map((secao) => {
      secaos.push(Secao.create(secao));
    });

    return secaos;
  }
}
