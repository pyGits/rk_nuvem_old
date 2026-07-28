import Tributacao from "../entity/Tributacao";
import DatabaseConnection from "./DatabaseConnection";

export default interface TributacaoRepository {
  getAll(tenant_id: number): Promise<Tributacao[]>;
  getByCodigo(codigo: string, tenant_id: number): Promise<Tributacao>;
  getByFiltro(filtro: { icms: string }, tenant_id: number): Promise<Tributacao>;
}

export class TributacaoRepositoryPG implements TributacaoRepository {
  async getByFiltro(filtro: { icms: string }, tenant_id: number): Promise<Tributacao> {
    const data = await DatabaseConnection.queryFirst("select * from tributacaos where icms = $1 and tenant_id= $2", [filtro.icms, tenant_id]);
    if (!data) return new Tributacao();
    return new Tributacao(data.codigo, data.nome, data.cst, data.cfop, data.csosn, data.icms);
  }

  async getByCodigo(codigo: string, tenant_id: number): Promise<Tributacao> {
    const data = await DatabaseConnection.query("select * from tributacaos where codigo = $1 and tenant_id= $2", [codigo, tenant_id]);
    if (!data) return null;
    return new Tributacao(data.codigo, data.nome, data.cst, data.cfop, data.csosn, data.icms);
  }
  async getAll(tenant_id: number): Promise<Tributacao[]> {
    const data = await DatabaseConnection.queryAll("select * from tributacaos where tenant_id = $1", [tenant_id]);
    let tributacaos = [];
    if (data.length == 0) return tributacaos;

    data.map((tributacao) => {
      tributacaos.push(Tributacao.create(tributacao));
    });

    return tributacaos;
  }
}
