import Loja from "../entity/Loja";
import Estoque from "../entity/Estoque";
import Produto from "../entity/Produto";
import DatabaseConnection from "./DatabaseConnection";
import { NotaFiscal } from "../entity/NotaFiscal";

export default interface EstoqueRepository {
  insertByProduto(produto: Produto, tenant_id: number): Promise<void>;
  insertMovimentacaoByNota(nota: NotaFiscal, tenant_id: number): Promise<void>;
  removeMovimentacaoByNota(chave_nota: string, lojaId: number, tenant_id: number): Promise<void>;
  getByProduto(produto: Produto, lojas: Loja[], tenant_id: number): Promise<Estoque[]>;
  getMovimentacoesByNota(chave_nota: string, tenant_id: number): Promise<any[]>;
}

export class EstoqueRepositoryPG implements EstoqueRepository {
  async removeMovimentacaoByNota(chave_nota: string, lojaId: number, tenant_id: number): Promise<void> {
    const movimentacoes = await DatabaseConnection.queryAll("select * from estoque_movimentacaos where tenant_id=$1 and codigo_cupom = $2", [tenant_id, chave_nota]);
    for (const mov of movimentacoes) {
      // Reverte cada movimentação na sua própria loja (a nota pode ter sido distribuída entre várias lojas).
      await DatabaseConnection.query(`UPDATE estoques SET estoque = estoque - $1 WHERE tenant_id = $2 AND codigo_produto = $3 and loja = $4`, [Number(mov.qtde), tenant_id, mov.codigo_produto, mov.loja]);
      await DatabaseConnection.query(`UPDATE estoque_movimentacaos SET qtde = 0 WHERE tenant_id = $1 and id = $2`, [tenant_id, mov.id]);
    }
  }
  async getMovimentacoesByNota(chave_nota: string, tenant_id: number): Promise<any[]> {
    return await DatabaseConnection.queryAll("select * from estoque_movimentacaos where tenant_id=$1 and codigo_cupom = $2 and origem = $3 and qtde > 0", [tenant_id, chave_nota, "NOTA_ENTRADA"]);
  }
  async insertMovimentacaoByNota(nota: NotaFiscal, tenant_id: number): Promise<void> {
    for (const item of nota.items) {
      // Uma movimentação/atualização de saldo por loja que recebe estoque deste item.
      for (const dist of item.distribuicoesOuPadrao(Number(nota.loja.codigo))) {
        await DatabaseConnection.query(
          `insert into estoque_movimentacaos(loja,codigo_produto,qtde,data,hora,codigo_cupom,item,codigo_funcionario,origem,tenant_id,created_at,updated_at)
                values ($1,$2,$3,now(),now(),$4,$5,$6,$7,$8,now(),now())`,
          [dist.lojaCodigo, item.associacao.codigo_produto, dist.quantidade, nota.protocolo.chave, item.numeroItem, "999", "NOTA_ENTRADA", tenant_id]
        );
        await DatabaseConnection.query(
          `
                INSERT INTO estoques (
                  codigo_produto, loja, estoque, carga_pendente, tenant_id, created_at, updated_at
                ) VALUES ($1, $2, $3, $4, $5, now(), now())
                ON CONFLICT (codigo_produto, loja, tenant_id)
                DO UPDATE SET
                  estoque = estoques.estoque + EXCLUDED.estoque,
                  carga_pendente = EXCLUDED.carga_pendente,
                  updated_at = now();
              `,
          [item.associacao.codigo_produto, dist.lojaCodigo, dist.quantidade, 1, tenant_id]
        );
      }
    }
  }
  async insertByProduto(produto: Produto, tenant_id: number): Promise<void> {
    for (const estoque of produto.estoques) {
      await DatabaseConnection.query(
        `
        INSERT INTO estoques (
          codigo_produto, loja, estoque, estoque_minimo, estoque_maximo, carga_pendente, tenant_id, created_at, updated_at
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, now(), now())
        ON CONFLICT (codigo_produto, loja, tenant_id)
        DO UPDATE SET 
          estoque = EXCLUDED.estoque,
          estoque_minimo = EXCLUDED.estoque_minimo,
          estoque_maximo = EXCLUDED.estoque_maximo,
          carga_pendente = EXCLUDED.carga_pendente,
          updated_at = now();
      `,
        [produto.codigo, estoque.lojaId, estoque.estoque, estoque.estoque_minimo, estoque.estoque_maximo, 1, tenant_id]
      );
    }
  }
  async getByProduto(produto: Produto, lojas: Loja[], tenant_id: number): Promise<Estoque[]> {
    let estoques = [];
    for (const loja of lojas) {
      const row = await DatabaseConnection.query("select * from estoques where codigo_produto = $1 and loja = $2 and tenant_id = $3", [produto.codigo, loja.codigo, tenant_id]);
      if (row) estoques.push(new Estoque(row.codigo_produto, row.loja, row.estoque, row.estoque_minimo, row.estoque_maximo, row.chave_xml, loja));
      if (!row) estoques.push(new Estoque(produto.codigo, Number(loja.codigo), 0, 0, 0, "", loja));
    }

    return estoques;
  }
}
