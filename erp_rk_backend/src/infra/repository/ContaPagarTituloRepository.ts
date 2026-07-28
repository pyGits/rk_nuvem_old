import ContaPagar from "../entity/ContaPagar";
import ContaPagarTitulo from "../entity/ContaPagarTitulo";
import ContaPagarTituloList from "../entity/ContaPagarTituloList";
import DatabaseConnection from "./DatabaseConnection";

export default interface ContaPagarTituloRepository {
  update(titulo: ContaPagarTitulo, tenant_id: number): Promise<void>;
  insert(contaPagar: ContaPagar, tenant_id: number): Promise<void>;
  getAll(filtros: any, tenant_id: number): Promise<ContaPagarTituloList>;
  liquidar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void>;
  estornar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void>;
  cancelar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void>;
}

export class ContaPagarTituloRepositoryPG implements ContaPagarTituloRepository {
  async update(titulo: ContaPagarTitulo, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update conta_pagar_titulo set valor = $1, descricao_conta=$2, numero_documento_conta=$3,vencimento=$4 where id =$5 and tenant_id = $6", [titulo.valor, titulo.descricao, titulo.numeroDocumento, titulo.vencimento, titulo.id, tenant_id]);
  }

  async estornar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void> {
    titulos.estornar();
    for (const titulo of titulos.items) {
      await DatabaseConnection.query("update conta_pagar_titulo set valor_pago = $1, status = $2 where id = $3 and tenant_id =$4", [titulo.valorPago, titulo.status, titulo.id, tenant_id]);
    }
  }
  async cancelar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void> {
    titulos.cancelarTitulos();
    for (const titulo of titulos.items) {
      await DatabaseConnection.query("update conta_pagar_titulo set valor_pago = $1, status = $2 where id = $3 and tenant_id =$4", [titulo.valorPago, titulo.status, titulo.id, tenant_id]);
    }
  }

  async liquidar(titulos: ContaPagarTituloList, tenant_id: number): Promise<void> {
    for (const titulo of titulos.items) {
      await DatabaseConnection.query("update conta_pagar_titulo set valor_pago = $1, status = $2 where id = $3 and tenant_id =$4", [titulo.valorPago, titulo.status, titulo.id, tenant_id]);
    }
  }

  async getAll(filtros: any, tenant_id: number): Promise<ContaPagarTituloList> {
    let sql = `
    SELECT * FROM conta_pagar_titulo 
    WHERE tenant_id = $1
  `;

    const params: any[] = [tenant_id];
    let index = 2;

    // Filtro de status (ignorando "Ambas")
    if (filtros.selectedStatus && filtros.selectedStatus !== "AMBAS") {
      sql += ` AND status = $${index++}`;
      params.push(filtros.selectedStatus);
    }

    // Filtro por data de vencimento (de)
    if (filtros.dataVencimentoDe) {
      sql += ` AND vencimento >= $${index++}`;
      params.push(filtros.dataVencimentoDe);
    }

    // Filtro por data de vencimento (até)
    if (filtros.dataVencimentoAte) {
      sql += ` AND vencimento <= $${index++}`;
      params.push(filtros.dataVencimentoAte);
    }
    // ----
    // Filtro por data de vencimento (de)
    if (filtros.dataEmissaoDe) {
      sql += ` AND emissao >= $${index++}`;
      params.push(filtros.dataEmissaoDe);
    }

    // Filtro por data de emissao (até)
    if (filtros.dataEmissaoAte) {
      sql += ` AND emissao <= $${index++}`;
      params.push(filtros.dataEmissaoAte);
    }
    // fornecedor
    if (filtros.selectedFornecedor) {
      sql += ` AND fornecedor_id = $${index++}`;
      params.push(filtros.selectedFornecedor);
    }
    // categoria
    if (filtros.selectedCategoria) {
      sql += ` AND categoria_financeira_id = $${index++}`;
      params.push(filtros.selectedCategoria);
    }

    // Filtro por descrição (busca parcial, insensível a maiúsculas)
    if (filtros.descricaoFiltro) {
      sql += ` AND descricao_conta ILIKE $${index++}`;
      params.push(`%${filtros.descricaoFiltro}%`);
    }

    // Filtro por número do documento (busca parcial, insensível a maiúsculas)
    if (filtros.numeroDocumentoFiltro) {
      sql += ` AND numero_documento_conta ILIKE $${index++}`;
      params.push(`%${filtros.numeroDocumentoFiltro}%`);
    }

    // Ordenação final
    sql += ` ORDER BY conta_pagar_id, parcela ASC`;

    // Executa consulta
    const data = await DatabaseConnection.queryAll(sql, params);

    // Monta lista de títulos
    const list = new ContaPagarTituloList();
    data.map((row) => {
      list.adicionarTitulo(new ContaPagarTitulo(row.parcela, row.vencimento, row.valor, row.valor_pago, row.descricao_conta, row.numero_documento_conta, row.fornecedor_id, row.loja_id, row.categoria_financeira_id, row.sub_categoria_financeira_id, row.id, row.status));
    });

    return list;
  }
  async insert(contaPagar: ContaPagar, tenant_id: number): Promise<void> {
    if (contaPagar.codigo.trim() === "") throw new Error("Código não informado !");
    for (const titulo of contaPagar.titulos.items) {
      if (titulo.id.trim() === "") throw new Error("Título sem ID");
      await DatabaseConnection.query(
        `insert into conta_pagar_titulo(conta_pagar_id,parcela,vencimento,valor,

        descricao_conta,numero_documento_conta,fornecedor_id,loja_id,valor_pago,       
        status,id,emissao,
        tenant_id) values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)`,
        [contaPagar.codigo, titulo.seq, titulo.vencimento, titulo.valor, contaPagar.descricao, contaPagar.numeroDocumento, contaPagar.fornecedorId, contaPagar.lojaId, titulo.valorPago, titulo.status, titulo.id, contaPagar.dataEmissao, tenant_id]
      );
    }
  }
}
