import ImpostosFederais from "../entity/ImpostosFederais";
import Connection from "./Connection";

export default interface ImpostosFederaisRepository {
  getAll(): Promise<ImpostosFederais[]>;
  insert(impostosFederais: ImpostosFederais): Promise<void>;
  delete(codigo: string): Promise<void>;
  getByCodigo(codigo: string): Promise<ImpostosFederais>;
}
export class ImpostosFederaisRepositoryAPI implements ImpostosFederaisRepository {
  async getByCodigo(codigo: string): Promise<ImpostosFederais> {
    const res = await Connection.get(`/v2/impostosFederais/${codigo}`);
    return ImpostosFederais.create(res.data);
  }
  async delete(codigo: string): Promise<void> {
    await Connection.delete(`/v2/impostosFederais/${codigo}`);
  }
  async insert(impostosFederais: ImpostosFederais): Promise<void> {
    await Connection.post("/v2/impostosFederais", impostosFederais);
  }
  async getAll(): Promise<ImpostosFederais[]> {
    const res = await Connection.get("/v2/impostosFederais");
    const data = res.data;
    if (!Array.isArray(data) || data.length === 0) return [];

    const impostosFederaiss: ImpostosFederais[] = data.map((impostosFederais: any) => ImpostosFederais.create(impostosFederais));

    return impostosFederaiss;
  }
}
