import Secao from "../entity/Secao";
import Connection from "./Connection";

export default interface SecaoRepository {
  getAll(): Promise<Secao[]>;
  insert(secao: Secao): Promise<void>;
  delete(codigo: string): Promise<void>;
}
export class SecaoRepositoryAPI implements SecaoRepository {
  async delete(codigo: string): Promise<void> {
    await Connection.delete(`/v2/secao/${codigo}`);
  }
  async insert(secao: Secao): Promise<void> {
    await Connection.post("/v2/secao", secao);
  }
  async getAll(): Promise<Secao[]> {
    const res = await Connection.get("/v2/secao");
    const data = res.data;
    if (!Array.isArray(data) || data.length === 0) return [];

    const secaos: Secao[] = data.map((secao: any) => Secao.create(secao));

    return secaos;
  }
}
