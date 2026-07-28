import Grupo from "../entity/Grupo";
import Connection from "./Connection";

export default interface GrupoRepository {
  getAllByCodigoSecao(codigo_secao: string): Promise<Grupo[]>;
  insert(grupo: Grupo): Promise<void>;
  delete(codigo: string): Promise<void>;
}

export class GrupoRepositoryAPI implements GrupoRepository {
  async delete(codigo: string): Promise<void> {
    await Connection.delete(`/v2/grupo/${codigo}`);
  }
  async insert(grupo: Grupo): Promise<void> {
    await Connection.post("/v2/grupo", grupo);
  }
  async getAllByCodigoSecao(codigo_secao: string): Promise<Grupo[]> {
    if (!codigo_secao) return [];
    const res = await Connection.get(`/v2/grupo/${codigo_secao}`);
    const data = res.data;
    if (!Array.isArray(data) || data.length === 0) return [];

    const grupos: Grupo[] = data.map((grupo: any) => Grupo.create(grupo));

    return grupos;
  }
}
