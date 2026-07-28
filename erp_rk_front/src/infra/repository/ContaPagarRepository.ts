import ContaPagar from "../entity/ContaPagar";
import ContaPagarFactory from "../entity/factory/ContaPagarFactory";
import Connection from "./Connection";

export default interface ContaPagarRepository {
  insert(contaPagar: ContaPagar): Promise<void>;
  getAll(): Promise<ContaPagar[]>;
  getByCodigo(codigo: string): Promise<ContaPagar>;
}
export class ContaPagarRepositoryApi implements ContaPagarRepository {
  async getByCodigo(codigo: string): Promise<ContaPagar> {
    const res = await Connection.get(`/v2/contapagar/${codigo}`);
    return ContaPagarFactory.create(res.data);
  }
  async insert(contaPagar: ContaPagar): Promise<void> {
    await Connection.post("/v2/contapagar", contaPagar);
  }
  async getAll(): Promise<ContaPagar[]> {
    const res = await Connection.get("/v2/contapagar");
    return res.data;
  }
}
