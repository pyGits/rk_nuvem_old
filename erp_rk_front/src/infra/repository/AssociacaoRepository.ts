// import Associacao from "../entity/Associacao";
import { Associacao } from "../entity/NotaFiscalItem";
import Connection from "./Connection";
import { NotaFiscal } from "../entity/NotaFiscal";

export default interface AssociacaoRepository {
  getAll(): Promise<Associacao[]>;
  insert(associacao: Associacao): Promise<void>;
  delete(codigo: string): Promise<void>;
  getByNota(nota: NotaFiscal): Promise<NotaFiscal>;
}

export class AssociacaoRepositoryAPI implements AssociacaoRepository {
  async getByNota(nota: NotaFiscal): Promise<NotaFiscal> {
    const res = await Connection.get("/v2/associacao/nota");
    // return NotaFiscal.create(res.data);
    return new NotaFiscal();
  }
  async delete(codigo: string): Promise<void> {
    await Connection.delete(`/v2/associacao/${codigo}`);
  }
  async insert(associacao: Associacao): Promise<void> {
    await Connection.post("/v2/associacao", associacao);
  }
  async getAll(): Promise<Associacao[]> {
    const res = await Connection.get("/v2/associacao");
    const data = res.data;
    if (!Array.isArray(data) || data.length === 0) return [];

    // const associacaos: Associacao[] = data.map((associacao: any) => Associacao.create(associacao));

    // return associacaos;
    return [new Associacao()];
  }
}
