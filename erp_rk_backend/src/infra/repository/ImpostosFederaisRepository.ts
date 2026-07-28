import ImpostosFederais from "../entity/ImpostosFederais";
import DatabaseConnection from "./DatabaseConnection";

export default interface ImpostosFederaisRepository {
  getAll(tenant_id: number): Promise<ImpostosFederais[]>;
  getByCodigo(codigo: string, tenant_id: number): Promise<ImpostosFederais>;
}
export class ImpostosFederaisRepositoryPG implements ImpostosFederaisRepository {
  async getByCodigo(codigo: string, tenant_id: number): Promise<ImpostosFederais> {
    const data = await DatabaseConnection.query("select * from imp_federais where codigo = $1 and tenant_id = $2", [codigo, tenant_id]);
    if (!data) return null;
    return new ImpostosFederais(data.codigo, data.nome, data.cst_entrada, data.cst_saida, data.pis, data.cofins);
  }
  async delete(codigo: string, tenant_id: number): Promise<void> {
    return;
  }
  async insert(impostosFederais: ImpostosFederais, tenant_id: number): Promise<void> {
    return;
  }
  async getAll(tenant_id: number): Promise<ImpostosFederais[]> {
    const data = await DatabaseConnection.queryAll("select * from imp_federais where tenant_id = $1", [tenant_id]);
    let impostosFederais = [];
    if (data.length == 0) return impostosFederais;

    data.map((imp) => {
      impostosFederais.push(ImpostosFederais.create(imp));
    });

    return impostosFederais;
  }
}
