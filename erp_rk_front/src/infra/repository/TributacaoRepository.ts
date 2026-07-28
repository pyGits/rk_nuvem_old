import Tributacao from "../entity/Tributacao";
import Connection from "./Connection";

export default interface TributacaoRepository {
  getAll(): Promise<Tributacao[]>;
  getByCodigo(codigo: string): Promise<Tributacao>;
  getByFiltro(filtro: { cst?: string; cfop?: string; csosn?: string; icms?: number }): Promise<Tributacao>;
}

export class TributacaoRepositoryAPI implements TributacaoRepository {
  async getByFiltro(filtro: { cst?: string; cfop?: string; csosn?: string; icms?: number }): Promise<Tributacao> {
    const res = await Connection.get(`/v2/tributacao`, { params: filtro });
    return Tributacao.create(res.data);
  }

  async getByCodigo(codigo: string): Promise<Tributacao> {
    const res = await Connection.get(`/v2/tributacao/${codigo}`);
    return Tributacao.create(res.data);
  }

  async getAll(): Promise<Tributacao[]> {
    const res = await Connection.get("/v2/tributacao");
    const data = res.data;
    const tributacoes: Tributacao[] = data.map((tributacao: any) => Tributacao.create(tributacao));
    return tributacoes;
  }
}
