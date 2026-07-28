import Loja from "../entity/Loja";
import DatabaseConnection from "./DatabaseConnection";

export type LojaSefazRow = {
  codigo: string;
  cnpjcpf: string;
  certificado: string;
  senha: string;
  uf: string;
  ultimo_nsu: string;
  tenant_id: number;
};

export default interface LojaRepository {
  getAll(tenant_id: number, filtro?: any): Promise<Loja[]>;
  getByCodigo(codigoLoja: string, tenant_id: number): Promise<Loja>;
  insert(loja: Loja, tenant_id: number): Promise<void>;
  getByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<Loja>;
  getByTenantId(tenant_id: number): Promise<Loja>;
  getCertificado(lojaId: string, tenant_id: number): Promise<string>;
  atualizarSenhaCertificado(senha: string, loja_id: string, tenant_id: number): Promise<void>;
  updateCertificado(certificado_base64: string, loja_id: string, tenant_id: number): Promise<void>;
  // SEFAZ
  salvarCertificado(input: { certificado_base64: string; senha: string; titular: string; validade: Date; loja_id: string; tenant_id: number }): Promise<void>;
  getSefazByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<LojaSefazRow | null>;
  getSefazByCodigo(codigo: string, tenant_id: number): Promise<LojaSefazRow | null>;
  getLojasParaSincronizar(tenant_id: number, intervaloMs: number): Promise<LojaSefazRow[]>;
  getLojasParaSincronizarGlobal(intervaloMs: number): Promise<LojaSefazRow[]>;
  atualizarSincronizacao(codigo: string, tenant_id: number, ultimoNsu: string): Promise<void>;
}

export class LojaRepositoryPG implements LojaRepository {
  async atualizarSenhaCertificado(senha: string, loja_id: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update lojas set senha = $1 where codigo = $2 and tenant_id = $3", [senha, loja_id, tenant_id]);
  }

  async updateCertificado(certificado_base64: string, loja_id: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update lojas set certificado = $1 where codigo = $2 and tenant_id = $3", [certificado_base64, loja_id, tenant_id]);
  }

  async salvarCertificado(input: { certificado_base64: string; senha: string; titular: string; validade: Date; loja_id: string; tenant_id: number }): Promise<void> {
    await DatabaseConnection.query(
      "update lojas set certificado = $1, senha = $2, certificado_titular = $3, certificado_validade = $4 where codigo = $5 and tenant_id = $6",
      [input.certificado_base64, input.senha, input.titular, input.validade, input.loja_id, input.tenant_id]
    );
  }

  private mapSefazRow(data: any): LojaSefazRow | null {
    if (!data) return null;
    return {
      codigo: String(data.codigo),
      cnpjcpf: data.cnpjcpf,
      certificado: data.certificado,
      senha: data.senha,
      uf: data.uf,
      ultimo_nsu: data.ultimo_nsu || "000000000000000",
      tenant_id: data.tenant_id,
    };
  }

  async getSefazByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<LojaSefazRow | null> {
    const data = await DatabaseConnection.queryFirst("select * from lojas where cnpjcpf = $1 and tenant_id = $2", [cnpjcpf, tenant_id]);
    return this.mapSefazRow(data);
  }

  async getSefazByCodigo(codigo: string, tenant_id: number): Promise<LojaSefazRow | null> {
    const data = await DatabaseConnection.queryFirst("select * from lojas where codigo = $1 and tenant_id = $2", [String(codigo), tenant_id]);
    return this.mapSefazRow(data);
  }

  async getLojasParaSincronizar(tenant_id: number, intervaloMs: number): Promise<LojaSefazRow[]> {
    const rows = await DatabaseConnection.queryAll(
      `select * from lojas
       where tenant_id = $1
         and certificado is not null and certificado <> ''
         and senha is not null and senha <> ''
         and uf is not null
         and (ultimo_sync is null or ultimo_sync < now() - ($2 || ' milliseconds')::interval)`,
      [tenant_id, String(intervaloMs)]
    );
    return rows.map((r) => this.mapSefazRow(r)).filter((r): r is LojaSefazRow => r !== null);
  }

  async getLojasParaSincronizarGlobal(intervaloMs: number): Promise<LojaSefazRow[]> {
    // Todas as lojas (de todos os tenants) com certificado + senha + UF,
    // com certificado NÃO vencido, cuja última sincronização já passou do intervalo.
    const rows = await DatabaseConnection.queryAll(
      `select * from lojas
       where certificado is not null and certificado <> ''
         and senha is not null and senha <> ''
         and uf is not null
         and (certificado_validade is null or certificado_validade > now())
         and (ultimo_sync is null or ultimo_sync < now() - ($1 || ' milliseconds')::interval)`,
      [String(intervaloMs)]
    );
    return rows.map((r) => this.mapSefazRow(r)).filter((r): r is LojaSefazRow => r !== null);
  }

  async atualizarSincronizacao(codigo: string, tenant_id: number, ultimoNsu: string): Promise<void> {
    await DatabaseConnection.query("update lojas set ultimo_nsu = $1, ultimo_sync = now() where codigo = $2 and tenant_id = $3", [ultimoNsu, codigo, tenant_id]);
  }

  async getCertificado(lojaId: string, tenant_id: number): Promise<string> {
    const res = await DatabaseConnection.query("select certificado from lojas where tenant_id = $1 and codigo = $2", [tenant_id, lojaId]);
    return res?.certificado;
  }

  async reset(tenant_id: number) {
    await DatabaseConnection.query("delete from lojas where tenant_id = $1", [tenant_id]);
  }

  async getByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<Loja> {
    const data = await DatabaseConnection.query("select * from lojas where cnpjcpf = $1 and tenant_id = $2 ", [cnpjcpf, tenant_id]);
    if (!data) return null;
    return new Loja(data.codigo, data.nome, data.fantasia, data.cnpjcpf, data.certificado, data.senha);
  }

  async getByTenantId(tenant_id: number): Promise<Loja> {
    const data = await DatabaseConnection.query("select * from lojas where tenant_id = $1  ", [tenant_id]);
    if (!data) return null;
    return new Loja(data.codigo, data.nome, data.fantasia, data.cnpjcpf, data.certificado, data.senha);
  }

  async insert(loja: Loja, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("insert into lojas (codigo,nome,fantasia,cnpjcpf,tenant_id,created_at,updated_at) values ($1,$2,$3,$4,$5,now(),now())", [loja.codigo, loja.nome, loja.fantasia, loja.cnpjcpf, tenant_id]);
  }

  async getByCodigo(codigoLoja: string, tenant_id: number): Promise<Loja> {
    const data = await DatabaseConnection.query("select * from lojas where codigo = $1 and tenant_id = $2 ", [String(codigoLoja), tenant_id]);
    if (!data) return null;
    return new Loja(data.codigo, data.nome, data.fantasia, data.cnpjcpf, data.certificado, data.senha);
  }

  async getAll(tenant_id: number, filtro: any = {}): Promise<Loja[]> {
    let sql = `
        SELECT * FROM lojas
        WHERE tenant_id = $1
      `;

    const params: any[] = [tenant_id];
    let index = 2;

    if (filtro.codigo) {
      sql += ` AND codigo ILIKE $${index++}`;
      params.push(`%${filtro.codigo}%`);
    }

    if (filtro.nome) {
      sql += ` AND nome ILIKE $${index++}`;
      params.push(`%${filtro.nome}%`);
    }

    if (filtro.cnpjcpf) {
      sql += ` AND cnpjcpf ILIKE $${index++}`;
      params.push(`%${filtro.cnpjcpf}%`);
    }

    sql += ` ORDER BY codigo asc`;

    const data = await DatabaseConnection.queryAll(sql, params);

    return data.map((loja) => new Loja(loja.codigo, loja.nome, loja.fantasia, loja.cnpjcpf, loja.certificado, loja.senha));
  }
}
