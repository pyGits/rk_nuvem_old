import DatabaseConnection from "./DatabaseConnection";

export default interface CategoriaFinanceiraLancamentoRepository {
  insert(categoria_id: string, subcategoria_id: string, valor: number, data: Date, lojaId: string, tenant_id: number): Promise<void>;
  getBalanceteSubCategoria(categoria_id: string, filtros: any, tenant_id: number): Promise<any>;
}
export class CategoriaFinanceiraLancamentoRepositoryPG implements CategoriaFinanceiraLancamentoRepository {
  async insert(categoria_id: string, subcategoria_id: string, valor: number, data: Date, lojaId: string, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("insert into categoria_financeira_lancamento(categoria_id,subcategoria_id,valor,data,loja_id,tenant_id) values($1,$2,$3,$4,$5,$6)", [categoria_id, subcategoria_id, valor, data, lojaId, tenant_id]);
  }

  async getBalanceteSubCategoria(categoria_id: string, filtros: any, tenant_Id: number): Promise<any> {
    let params = [tenant_Id, categoria_id, filtros.dtInicio, filtros.dtFim];
    let query = `
    SELECT 
      scf.codigo,
      scf.nome,
      SUM(
        CASE 
          WHEN scf.tipo = 'DESPESA' THEN cfl.valor * -1
          ELSE cfl.valor
        END
      ) AS total,
      scf.tipo
    FROM sub_categoria_financeira scf
    LEFT JOIN categoria_financeira_lancamento cfl 
      ON scf.codigo = cfl.subcategoria_id
    WHERE 
      scf.codigo_categoria = $2
      AND cfl.tenant_id = $1
      AND scf.tenant_id = $1
      AND cfl.data >= $3 AND cfl.data <= $4
  `;

    // Se tiver loja, adiciona ao WHERE
    if (filtros.loja) {
      query += ` AND cfl.loja_id = $5`;
      params.push(filtros.loja);
    }

    query += `
    GROUP BY 
      scf.codigo,
      scf.nome,
      scf.tipo
  `;

    const res = await DatabaseConnection.queryAll(query, params);
    return res;
  }
}
