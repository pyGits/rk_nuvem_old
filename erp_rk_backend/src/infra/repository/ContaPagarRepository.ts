import ContaPagar from "../entity/ContaPagar";
import DatabaseConnection from "./DatabaseConnection";

export default interface ContaPagarRepository {
  insert(contaPagar: ContaPagar, tenant_id: number): Promise<void>;
  getAll(tenant_id: number): Promise<ContaPagar[]>;
  getByCodigo(codigo: string, tenant_id: number): Promise<ContaPagar>;
  getByNumeroDocumento(numeroDocumento: string, tenant_id: number): Promise<ContaPagar>;
}

export class ContaPagarRepositoryPG implements ContaPagarRepository {
  async getByNumeroDocumento(numeroDocumento: string, tenant_id: number): Promise<ContaPagar> {
    const res = await DatabaseConnection.queryFirst("select * from conta_pagar where numero_documento = $1 and tenant_id = $2", [numeroDocumento, tenant_id]);
    if (!res) return null;
    return new ContaPagar(res.loja_id, res.fornecedor_id, res.numero_documento, res.data_vencimento, res.valor_nominal, res.valor_acrescimo, res.valor_desconto, res.parcelas, res.intervalo, undefined, res.descricao, res.tipo, res.codigo);
  }
  async getByCodigo(codigo: string, tenant_id: number): Promise<ContaPagar> {
    const res = await DatabaseConnection.queryFirst("select * from conta_pagar where codigo = $1 and tenant_id = $2", [codigo, tenant_id]);
    return new ContaPagar(res.loja_id, res.fornecedor_id, res.numero_documento, res.data_vencimento, res.valor_nominal, res.valor_acrescimo, res.valor_desconto, res.parcelas, res.intervalo, undefined, res.descricao, res.tipo, res.codigo);
  }

  async getAll(tenant_id: number): Promise<ContaPagar[]> {
    const res = await DatabaseConnection.queryAll("select * from conta_pagar where tenant_id = $1", [tenant_id]);
    return res;
  }
  async insert(contaPagar: ContaPagar, tenant_id: number): Promise<void> {
    if (contaPagar.codigo.trim() === "") throw new Error("Código não informado !");
    await DatabaseConnection.query(
      `INSERT INTO conta_pagar(codigo,loja_id,fornecedor_id,descricao,numero_documento,data_vencimento,
        valor_nominal,valor_acrescimo,valor_desconto,valor_total,parcelas,intervalo,tipo,data_emissao,tenant_id) values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)`,
      [
        contaPagar.codigo,
        contaPagar.lojaId,
        contaPagar.fornecedorId,
        contaPagar.descricao,
        contaPagar.numeroDocumento,
        contaPagar.dataVencimento,
        contaPagar.valorNominal,
        contaPagar.acrescimo,
        contaPagar.desconto,
        contaPagar.valorTotal(),
        contaPagar.parcelas,
        contaPagar.intervalo,
        contaPagar.tipoIntervalo,
        contaPagar.dataEmissao,
        tenant_id,
      ]
    );
  }
}
