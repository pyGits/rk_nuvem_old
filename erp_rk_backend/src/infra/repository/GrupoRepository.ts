import Grupo from "../entity/Grupo";
import DatabaseConnection from "./DatabaseConnection";

export default interface GrupoRepository {
  getAllByCodigoSecao(codigo_secao: string, tenant_id: number): Promise<Grupo[]>;
}
export class GrupoRepositoryFake implements GrupoRepository {
  private grupos: Grupo[] = [];

  async insert(grupo: Grupo, tenant_id: number): Promise<void> {
    this.grupos.push(grupo);
  }

  async delete(codigo: string, tenant_id: number): Promise<void> {
    this.grupos = this.grupos.filter((p) => p.codigo !== codigo);
  }

  async getAllByCodigoSecao(codigo_secao: string, tenant_id: number): Promise<Grupo[]> {
    return this.grupos;
  }

  clear() {
    this.grupos = [];
  }
}
export class GrupoRepositoryPG implements GrupoRepository {
  async delete(codigo: string, tenant_id: number): Promise<void> {
    // await DatabaseConnection.query("delete from grupos where codigo = $1 and tenant_id = $2", [codigo, tenant_id]);
  }
  async insert(grupo: Grupo, tenant_id: number): Promise<void> {
    // await DatabaseConnection.query(
    //   "INSERT INTO grupos(codigo, codigo_barras, descricao, grupo, fornecedor, grupo, forma_venda, unidade, tributacao, impfederal, ncm, cest, balanca, balanca_validade, diversos, ativo, carga_pendente, tenant_id, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, now(), now())",
    //   [grupo.codigo, grupo.codigo_barras, grupo.descricao, grupo.grupo, grupo.fornecedor, grupo.grupo, grupo.forma_venda, grupo.unidade, grupo.tributacao, grupo.impfederal, grupo.ncm, grupo.cest, grupo.balanca, grupo.balanca_validade, grupo.diversos, grupo.ativo, 1, tenant_id]
    // );
  }
  async getAllByCodigoSecao(codigo_secao: string, tenant_id: number): Promise<Grupo[]> {
    const data = await DatabaseConnection.queryAll("select * from grupos where codigo_secao=$1 and tenant_id = $2", [codigo_secao, tenant_id]);
    let grupos = [];
    if (data.length == 0) return grupos;

    data.map((grupo) => {
      grupos.push(Grupo.create(grupo));
    });

    return grupos;
  }
}
