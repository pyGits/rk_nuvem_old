import Sequencial from "../entity/Sequencial";
import DatabaseConnection from "./DatabaseConnection";

export class SequencialRepository {
  async get(tabela: string, coluna: string, tenant_id: number): Promise<string> {
    const data = await DatabaseConnection.queryAll(`SELECT cast(${coluna} as bigint) as ${coluna} FROM ${tabela} where tenant_id = ${tenant_id} ORDER BY 1`);
    const codigos = data.map((row: any) => row.codigo);
    return String(Sequencial.encontrarProximoCodigoDisponivel(codigos));
  }
}
export default new SequencialRepository();
