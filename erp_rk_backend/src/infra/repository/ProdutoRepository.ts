import Produto from "../entity/Produto";
import DatabaseConnection from "./DatabaseConnection";

export default interface ProdutoRepository {
  getAll(tenant_id: number): Promise<Produto[]>;
  insert(produto: Produto, tenant_id: number): Promise<any>;
  delete(codigo: string, tenant_id: number): Promise<void>;
  getByCodigo(codigo_produto: string, tenant_id: number): Promise<Produto>;
  getByCodigoBarras(codigo_barras: string, tenant_id: number): Promise<Produto>;
  getAllByFilter(filter: { codigo_barras: string; nome: string }, tenant_id: number): Promise<Produto[]>;
}

export class ProdutoRepositoryPG implements ProdutoRepository {
  async getAllByFilter(filter: { codigo_barras: string; nome: string }, tenant_id: number) {
    let sql = `
      SELECT * FROM produtos
      WHERE tenant_id = $1
    `;

    const params: any[] = [tenant_id];
    let index = 2;

    // Filtro por código (busca exata ou parcial)
    if (filter.codigo_barras) {
      sql += ` AND codigo_barras ILIKE $${index++}`;
      params.push(`%${filter.codigo_barras}%`);
    }

    // Filtro por nome (busca parcial, case-insensitive)
    if (filter.nome) {
      sql += ` AND descricao ILIKE $${index++}`;
      params.push(`%${filter.nome}%`);
    }

    // Ordenação final (opcional, personalizável)
    sql += ` ORDER BY codigo_barras asc`;

    // Executa a consulta
    const data = await DatabaseConnection.queryAll(sql, params);

    // Aqui você pode mapear para uma classe FornecedorList ou retornar direto:
    return data;
  }
  async reset(tenant_id: number) {
    await DatabaseConnection.query("delete from produtos where tenant_id = $1", [tenant_id]);
  }

  async getByCodigoBarras(codigo_barras: string, tenant_id: number): Promise<Produto> {
    let res = await DatabaseConnection.query("select * from produtos where codigo_barras =$1 and tenant_id = $2", [codigo_barras, tenant_id]);

    // Busca completa: se não achar pelo código principal, tenta resolver o
    // produto a partir de um código de barras auxiliar (EAN secundário).
    if (!res) {
      const auxiliar = await DatabaseConnection.query("select codigo_produto from produto_codigos_barras where codigo_barras = $1 and tenant_id = $2", [codigo_barras, tenant_id]);
      if (auxiliar) {
        res = await DatabaseConnection.query("select * from produtos where codigo = $1 and tenant_id = $2", [auxiliar.codigo_produto, tenant_id]);
      }
    }

    if (!res) return null;
    return new Produto(res.codigo, res.codigo_barras, res.descricao, res.secao, res.fornecedor, res.grupo, res.subgrupo, res.unidade, res.forma_venda, res.ncm, res.cest, res.tributacao, res.balanca, res.balanca_validade, res.diversos, res.ativo, res.impfederal);
  }
  async getByCodigo(codigo_produto: string, tenant_id: number): Promise<Produto> {
    const res = await DatabaseConnection.query("select * from produtos where codigo =$1 and tenant_id = $2", [codigo_produto, tenant_id]);
    if (!res) return null;
    return new Produto(res.codigo, res.codigo_barras, res.descricao, res.secao, res.fornecedor, res.grupo, res.subgrupo, res.unidade, res.forma_venda, res.ncm, res.cest, res.tributacao, res.balanca, res.balanca_validade, res.diversos, res.ativo, res.impfederal);
  }
  async delete(codigo: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("delete from produtos where codigo = $1 and tenant_id = $2", [codigo, tenant_id]);
  }
  async insert(produto: Produto, tenant_id: number): Promise<void> {
    const codigoBarras = String(produto.codigo_barras).replace(/^0+/, "");
    await DatabaseConnection.query(
      "INSERT INTO produtos(codigo, codigo_barras, descricao, secao, fornecedor, grupo, forma_venda, unidade, tributacao, impfederal, ncm, cest, balanca, balanca_validade, diversos, ativo, carga_pendente, tenant_id, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, now(), now())",
      [
        produto.codigo,
        codigoBarras,
        produto.descricao,
        produto.secao,
        produto.fornecedor,
        produto.grupo,
        produto.forma_venda,
        produto.unidade,
        produto.tributacao,
        produto.impfederal,
        produto.ncm,
        produto.cest,
        produto.balanca,
        produto.balanca_validade,
        produto.diversos,
        produto.ativo,
        1,
        tenant_id,
      ],
    );
  }
  async getAll(tenant_id: number): Promise<Produto[]> {
    const data = await DatabaseConnection.queryAll("select * from produtos where tenant_id = $1", [tenant_id]);
    let produtos = [];
    if (data.length == 0) return produtos;

    data.map((produto) => {
      produtos.push(Produto.create(produto));
    });

    return produtos;
  }
  async getAllWithPreco(tenant_id: number, loja_id: number, alterados: any): Promise<any[]> {
    let produtos: any[];
    if (alterados) {
      produtos = await DatabaseConnection.queryAll("select * from produtos left join precos on produtos.codigo = precos.codigo_produto where produtos.tenant_id =$1 and precos.tenant_id = $1 and precos.loja = $2 and produtos.carga_pendente = true", [tenant_id, loja_id]);
    } else {
      produtos = await DatabaseConnection.queryAll("select * from produtos left join precos on produtos.codigo = precos.codigo_produto where produtos.tenant_id =$1 and precos.tenant_id = $1 and precos.loja = $2", [tenant_id, loja_id]);
    }

    // Anexa os códigos de barras auxiliares (1 produto -> N EANs) para que o
    // Sync consiga replicá-los no PDV. Busca todos de uma vez e agrupa por
    // código de produto, evitando uma consulta por produto.
    const auxiliares = await DatabaseConnection.queryAll("select codigo_produto, codigo_barras from produto_codigos_barras where tenant_id = $1", [tenant_id]);

    const auxPorProduto = new Map<string, string[]>();
    for (const aux of auxiliares) {
      const chave = String(aux.codigo_produto);
      if (!auxPorProduto.has(chave)) auxPorProduto.set(chave, []);
      auxPorProduto.get(chave)!.push(aux.codigo_barras);
    }

    for (const produto of produtos) {
      produto.codigos_barras_auxiliares = auxPorProduto.get(String(produto.codigo)) || [];
    }

    return produtos;
  }
}
