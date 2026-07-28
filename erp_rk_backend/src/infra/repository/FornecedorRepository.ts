import Fornecedor from "../entity/Fornecedor";
import DatabaseConnection from "./DatabaseConnection";
export default interface FornecedorRepository {
  insert(fornecedor: Fornecedor, tenant_id: number): Promise<void>;
  getByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<Fornecedor>;
  delete(codigo: string, tenant_id: number): Promise<void>;
  getAll(tenant_id: number): Promise<Fornecedor[]>;
  getByCodigo(codigo: string, tenant_id: number): Promise<Fornecedor>;
  update(fornecedor: Fornecedor, tenant_id: number): Promise<void>;
  getAllByFilter(filter: { codigo: string; nome: string; cnpjcpf: string }, tenant_id: number);
  getTransportadoraByCodigo(codigo: string, tenant_id: number);
  getAllTransportadora(tenant_id: number): Promise<Fornecedor[]>;
}
export class FornecedorRepositoryPG implements FornecedorRepository {
  async getTransportadoraByCodigo(codigo: string, tenant_id: number) {
    const res = await DatabaseConnection.queryFirst("select * from fornecedors where tenant_id =$1 and codigo =$2 and transportadora = 'S'", [tenant_id, codigo]);
    if (!res) return null;
    return new Fornecedor(res.codigo, res.cnpjcpf, res.nome, res.fantasia, res.ierg, res.uf, res.im, res.telefone, res.telefone2, res.celular, res.email, res.observacao, res.cep, res.logradouro, res.cidade, res.bairro, res.complemento, res.codigoibge);
  }
  async getAllByFilter(filter: { codigo: string; nome: string; cnpjcpf: string }, tenant_id: number) {
    let sql = `
    SELECT * FROM fornecedors
    WHERE tenant_id = $1
  `;

    const params: any[] = [tenant_id];
    let index = 2;

    // Filtro por código (busca exata ou parcial)
    if (filter.codigo) {
      sql += ` AND codigo ILIKE $${index++}`;
      params.push(`%${filter.codigo}%`);
    }

    // Filtro por nome (busca parcial, case-insensitive)
    if (filter.nome) {
      sql += ` AND nome ILIKE $${index++}`;
      params.push(`%${filter.nome}%`);
    }

    // Filtro por CNPJ/CPF (busca parcial, case-insensitive)
    if (filter.cnpjcpf) {
      sql += ` AND cnpjcpf ILIKE $${index++}`;
      params.push(`%${filter.cnpjcpf}%`);
    }

    // Ordenação final (opcional, personalizável)
    sql += ` ORDER BY codigo asc`;

    // Executa a consulta
    const data = await DatabaseConnection.queryAll(sql, params);

    // Aqui você pode mapear para uma classe FornecedorList ou retornar direto:
    return data;
  }
  async insert(fornecedor: Fornecedor, tenant_id: number): Promise<void> {
    await DatabaseConnection.query(
      "INSERT INTO fornecedors(codigo, cnpjcpf, nome, fantasia, ierg, im, telefone, telefone2, celular, email, observacao,cep,logradouro,uf,cidade,bairro,complemento,codigoIbge, tenant_id,created_at,updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11,$12,$13,$14,$15,$16,$17,$18,$19,now(),now())",
      [
        fornecedor.codigo,
        fornecedor.cnpjcpf,
        fornecedor.nome,
        fornecedor.nome_fantasia,
        fornecedor.ierg,
        fornecedor.im,
        fornecedor.telefone,
        fornecedor.telefone2,
        fornecedor.celular,
        fornecedor.email,
        fornecedor.observacao,

        fornecedor.cep,
        fornecedor.logradouro,
        fornecedor.uf,
        fornecedor.cidade,
        fornecedor.bairro,
        fornecedor.complemento,
        fornecedor.codigoIbge,

        tenant_id,
      ]
    );
  }
  async update(fornecedor: Fornecedor, tenant_id: number): Promise<void> {
    await DatabaseConnection.query(
      `UPDATE fornecedors SET
        cnpjcpf = $1,
        nome = $2,
        fantasia = $3,
        ierg = $4,
        im = $5,
        telefone = $6,
        telefone2 = $7,
        celular = $8,
        email = $9,
        observacao = $10,
        cep = $11,
        logradouro = $12,
        uf = $13,
        cidade = $14,
        bairro = $15,
        complemento = $16,
        codigoIbge = $17,
        updated_at = now()
      WHERE codigo = $18 AND tenant_id = $19`,
      [
        fornecedor.cnpjcpf,
        fornecedor.nome,
        fornecedor.nome_fantasia,
        fornecedor.ierg,
        fornecedor.im,
        fornecedor.telefone,
        fornecedor.telefone2,
        fornecedor.celular,
        fornecedor.email,
        fornecedor.observacao,
        fornecedor.cep,
        fornecedor.logradouro,
        fornecedor.uf,
        fornecedor.cidade,
        fornecedor.bairro,
        fornecedor.complemento,
        fornecedor.codigoIbge,
        fornecedor.codigo,
        tenant_id,
      ]
    );
  }

  async getByCNPJCPF(cnpjcpf: string, tenant_id: number): Promise<Fornecedor> {
    const res = await DatabaseConnection.query("select * from fornecedors where cnpjcpf = $1 and tenant_id = $2", [cnpjcpf, tenant_id]);
    if (!res) return null;
    return new Fornecedor(res.codigo, res.cnpjcpf, res.nome, res.fantasia, res.ierg, res.uf, res.im, res.telefone, res.telefone2, res.celular, res.email, res.observacao, res.cep, res.logradouro, res.cidade, res.bairro, res.complemento, res.codigoibge);
  }
  async getByCodigo(codigo: string, tenant_id: number): Promise<Fornecedor> {
    const res = await DatabaseConnection.query("select * from fornecedors where codigo = $1 and tenant_id = $2", [codigo, tenant_id]);
    if (!res) return null;
    return new Fornecedor(res.codigo, res.cnpjcpf, res.nome, res.fantasia, res.ierg, res.uf, res.im, res.telefone, res.telefone2, res.celular, res.email, res.observacao, res.cep, res.logradouro, res.cidade, res.bairro, res.complemento, res.codigoibge);
  }
  async delete(codigo: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("delete from fornecedors where codigo = $1 and tenant_id =$2", [codigo, tenant_id]);
  }

  async deleteAll(tenant_id: number) {
    await DatabaseConnection.query("delete from fornecedors where tenant_id = $1", [tenant_id]);
  }
  async getAll(tenant_id: number) {
    const data = await DatabaseConnection.queryAll("select * from fornecedors where tenant_id = $1", [tenant_id]);
    return data.map((res) => new Fornecedor(res.codigo, res.cnpjcpf, res.nome, res.fantasia, res.ierg, res.uf, res.im, res.telefone, res.telefone2, res.celular, res.email, res.observacao, res.cep, res.logradouro, res.cidade, res.bairro, res.complemento, res.codigoibge));
  }
  async getAllTransportadora(tenant_id: number) {
    const data = await DatabaseConnection.queryAll("select * from fornecedors where tenant_id = $1 and transportadora = 'S'", [tenant_id]);
    return data.map((res) => new Fornecedor(res.codigo, res.cnpjcpf, res.nome, res.fantasia, res.ierg, res.uf, res.im, res.telefone, res.telefone2, res.celular, res.email, res.observacao, res.cep, res.logradouro, res.cidade, res.bairro, res.complemento, res.codigoibge));
  }
}
