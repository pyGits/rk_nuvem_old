import Loja from "../entity/Loja";
import Preco from "../entity/Preco";
import Produto from "../entity/Produto";
import DatabaseConnection from "./DatabaseConnection";

function normalizarCusto(valor: any): number {
  const numero = Number(valor);
  if (isNaN(numero) || numero < 0) return 0;
  return numero;
}

export default interface PrecoRepository {
  insertByProduto(produto: Produto, tenant_id: number): Promise<void>;
  insert(preco: Preco, tenant_id: number): Promise<void>;
  getByProduto(codigo_produto: string, lojas: Loja[], tenant_id: number): Promise<Preco[]>;
}

export class PrecoRepositoryPG implements PrecoRepository {
  async insert(preco: Preco, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("INSERT INTO precos (codigo_produto,loja,preco,custo,oferta,markup,tenant_id) values ($1,$2,$3,$4,$5,$6,$7)", [preco.codigo_produto, preco.lojaId, preco.preco, normalizarCusto(preco.custo), preco.oferta, preco.markup, tenant_id]);
  }

  async insertByProduto(produto: Produto, tenant_id: number): Promise<void> {
    for (const preco of produto.precos) {
      await DatabaseConnection.query(
        `INSERT INTO precos (
          codigo_produto, loja, preco, custo, oferta, markup, carga_pendente, tenant_id, created_at, updated_at
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, now(), now())
        ON CONFLICT (codigo_produto, loja, tenant_id)
        DO UPDATE SET 
          preco = EXCLUDED.preco,
          custo = EXCLUDED.custo,
          oferta = EXCLUDED.oferta,
          markup = EXCLUDED.markup,
          carga_pendente = EXCLUDED.carga_pendente,
          ultimo_custo = precos.custo,
          updated_at = now();`,
        [produto.codigo, preco.lojaId, preco.preco, normalizarCusto(preco.custo), preco.oferta, preco.markup, 1, tenant_id],
      );
    }
  }

  async getByProduto(codigo_produto: string, lojas: Loja[], tenant_id: number): Promise<Preco[]> {
    let precos = [];
    for (const loja of lojas) {
      const row = await DatabaseConnection.query("select * from precos where codigo_produto = $1 and loja = $2 and tenant_id = $3", [codigo_produto, loja.codigo, tenant_id]);

      if (row) precos.push(new Preco(row.loja, row.preco, normalizarCusto(row.custo), row.oferta, row.markup, loja, codigo_produto, row.ultimo_custo));

      if (!row) precos.push(new Preco(loja.codigo, 0, 0, 0, 0, loja));
    }

    return precos;
  }
}
