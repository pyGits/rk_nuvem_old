import { v4 as uuidv4 } from "uuid";
import ContaReceber from "../entity/ContaReceber";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberTituloList from "../entity/ContaReceberTituloList";
import RecebimentoTitulo from "../entity/RecebimentoTitulo";
import DatabaseConnection from "./DatabaseConnection";

export default interface ContaReceberRepository {
  sincronizar(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  insert(contaReceber: ContaReceber, tenant_id: number): Promise<void>;
  getAll(filtros: any, tenant_id: number): Promise<ContaReceberTituloList>;
  getByIds(ids: string[], tenant_id: number): Promise<ContaReceberTituloList>;
  atualizarSituacao(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  update(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  proximoCodigoManual(tenant_id: number): Promise<string>;
}

function montarTitulo(row: any): ContaReceberTitulo {
  return new ContaReceberTitulo(
    row.id,
    row.codigo,
    Number(row.loja),
    row.cliente_codigo,
    row.cliente_cpf,
    row.codigo_cupom,
    row.numero,
    Number(row.prestacao || 1),
    row.caixa,
    row.vendedor,
    row.data_emissao,
    row.data_vencimento,
    Number(row.valor),
    row.descricao,
    row.origem,
    Number(row.cancelado || 0),
    row.status
  );
}

// Anexa os recebimentos aos titulos numa unica consulta - a tela lista centenas
// de titulos e o saldo de cada um sai dos recebimentos.
async function carregarRecebimentos(titulos: ContaReceberTitulo[], tenant_id: number): Promise<void> {
  if (titulos.length === 0) return;

  const ids = titulos.map((titulo) => titulo.id);
  const rows = await DatabaseConnection.queryAll("select * from conta_receber_recebimento where tenant_id = $1 and conta_receber_id = ANY($2) order by data_pagamento, created_at", [tenant_id, ids]);

  const porTitulo: { [id: string]: RecebimentoTitulo[] } = {};
  rows.forEach((row: any) => {
    if (!porTitulo[row.conta_receber_id]) porTitulo[row.conta_receber_id] = [];
    porTitulo[row.conta_receber_id].push(new RecebimentoTitulo(Number(row.valor), row.forma_pagamento, Number(row.valor_juros), Number(row.valor_multa), Number(row.valor_desconto), row.data_pagamento, row.id, row.usuario, Number(row.estornado || 0)));
  });

  titulos.forEach((titulo) => (titulo.recebimentos = porTitulo[titulo.id] || []));
}

export class ContaReceberRepositoryPG implements ContaReceberRepository {
  // Upsert: o PDV reenvia o mesmo titulo quando o cupom e cancelado (o registro
  // volta para NUVEM = 0), e um POST repetido tambem acontece quando o
  // UPDATE NUVEM = 1 falha depois de um envio bem-sucedido. So os dados do
  // documento sao atualizados - os recebimentos lancados no web ficam intactos.
  async sincronizar(titulo: ContaReceberTitulo, tenant_id: number): Promise<void> {
    if (String(titulo.codigo).trim() === "") throw new Error("Código do título não informado !");

    await DatabaseConnection.query(
      `insert into conta_receber (id,tenant_id,loja,codigo,codigo_cupom,numero,prestacao,cliente_codigo,cliente_cpf,
        caixa,vendedor,data_emissao,data_vencimento,valor,descricao,origem,cancelado,status)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,'PDV',$16,$17)
       on conflict (tenant_id,loja,codigo) do update set
        codigo_cupom = excluded.codigo_cupom,
        numero = excluded.numero,
        prestacao = excluded.prestacao,
        cliente_codigo = excluded.cliente_codigo,
        cliente_cpf = excluded.cliente_cpf,
        caixa = excluded.caixa,
        vendedor = excluded.vendedor,
        data_emissao = excluded.data_emissao,
        data_vencimento = excluded.data_vencimento,
        valor = excluded.valor,
        descricao = excluded.descricao,
        cancelado = excluded.cancelado,
        status = case when excluded.cancelado = 1 then 'CANCELADO' else conta_receber.status end,
        updated_at = now()`,
      [
        titulo.id || uuidv4(),
        tenant_id,
        titulo.lojaId,
        titulo.codigo,
        titulo.codigoCupom,
        titulo.numero,
        titulo.prestacao,
        titulo.clienteCodigo,
        titulo.clienteCpf,
        titulo.caixa,
        titulo.vendedor,
        titulo.dataEmissao,
        titulo.dataVencimento,
        titulo.valor,
        titulo.descricao,
        titulo.cancelado,
        titulo.status,
      ]
    );
  }

  async insert(contaReceber: ContaReceber, tenant_id: number): Promise<void> {
    for (const titulo of contaReceber.titulos.items) {
      await DatabaseConnection.query(
        `insert into conta_receber (id,tenant_id,loja,codigo,prestacao,cliente_codigo,cliente_cpf,
          data_emissao,data_vencimento,valor,descricao,origem,cancelado,status)
         values ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,'MANUAL',0,'ABERTO')`,
        [uuidv4(), tenant_id, titulo.lojaId, `${contaReceber.codigo}/${titulo.prestacao}`, titulo.prestacao, titulo.clienteCodigo, titulo.clienteCpf, titulo.dataEmissao, titulo.dataVencimento, titulo.valor, titulo.descricao]
      );
    }
  }

  async getAll(filtros: any, tenant_id: number): Promise<ContaReceberTituloList> {
    let sql = "select * from conta_receber where tenant_id = $1";
    const params: any[] = [tenant_id];
    let index = 2;

    if (filtros.selectedStatus && filtros.selectedStatus !== "AMBAS") {
      sql += ` and status = $${index++}`;
      params.push(filtros.selectedStatus);
    }
    if (filtros.dataVencimentoDe) {
      sql += ` and data_vencimento >= $${index++}`;
      params.push(filtros.dataVencimentoDe);
    }
    if (filtros.dataVencimentoAte) {
      sql += ` and data_vencimento <= $${index++}`;
      params.push(filtros.dataVencimentoAte);
    }
    if (filtros.dataEmissaoDe) {
      sql += ` and data_emissao >= $${index++}`;
      params.push(filtros.dataEmissaoDe);
    }
    if (filtros.dataEmissaoAte) {
      sql += ` and data_emissao <= $${index++}`;
      params.push(filtros.dataEmissaoAte);
    }
    if (filtros.selectedCliente) {
      sql += ` and cliente_codigo = $${index++}`;
      params.push(filtros.selectedCliente);
    }
    if (filtros.selectedLoja) {
      sql += ` and loja = $${index++}`;
      params.push(Number(filtros.selectedLoja));
    }
    if (filtros.selectedOrigem) {
      sql += ` and origem = $${index++}`;
      params.push(filtros.selectedOrigem);
    }
    if (filtros.cupomFiltro) {
      sql += ` and (codigo_cupom ILIKE $${index} or numero ILIKE $${index})`;
      params.push(`%${filtros.cupomFiltro}%`);
      index++;
    }
    if (filtros.descricaoFiltro) {
      sql += ` and descricao ILIKE $${index++}`;
      params.push(`%${filtros.descricaoFiltro}%`);
    }

    sql += " order by data_vencimento, cliente_codigo, codigo";

    const rows = await DatabaseConnection.queryAll(sql, params);

    const list = new ContaReceberTituloList();
    rows.forEach((row: any) => list.adicionarTitulo(montarTitulo(row)));
    await carregarRecebimentos(list.items, tenant_id);

    return list;
  }

  // As operacoes recebem so os ids: saldo e status vem do banco, nunca do que o
  // navegador mandou.
  async getByIds(ids: string[], tenant_id: number): Promise<ContaReceberTituloList> {
    const list = new ContaReceberTituloList();
    if (!ids || ids.length === 0) return list;

    const rows = await DatabaseConnection.queryAll("select * from conta_receber where tenant_id = $1 and id = ANY($2) order by data_vencimento, codigo", [tenant_id, ids]);
    rows.forEach((row: any) => list.adicionarTitulo(montarTitulo(row)));
    await carregarRecebimentos(list.items, tenant_id);

    return list;
  }

  async atualizarSituacao(titulo: ContaReceberTitulo, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update conta_receber set status = $1, cancelado = $2, updated_at = now() where id = $3 and tenant_id = $4", [titulo.status, titulo.cancelado, titulo.id, tenant_id]);
  }

  async update(titulo: ContaReceberTitulo, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update conta_receber set valor = $1, data_vencimento = $2, descricao = $3, updated_at = now() where id = $4 and tenant_id = $5", [titulo.valor, titulo.dataVencimento, titulo.descricao, titulo.id, tenant_id]);
  }

  // O codigo do PDV e numerico de 38 digitos, entao o sequencial dos manuais
  // anda numa faixa propria (prefixo M) e nunca colide com ele.
  async proximoCodigoManual(tenant_id: number): Promise<string> {
    const res = await DatabaseConnection.queryFirst(
      `select coalesce(max(cast(substring(codigo from 2 for 9) as bigint)),0) + 1 as proximo
         from conta_receber
        where tenant_id = $1 and origem = 'MANUAL' and codigo similar to 'M[0-9]{9}/%'`,
      [tenant_id]
    );
    return `M${String(res?.proximo || 1).padStart(9, "0")}`;
  }
}
