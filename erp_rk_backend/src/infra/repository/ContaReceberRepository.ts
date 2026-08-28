import { v4 as uuidv4 } from "uuid";
import ContaReceber from "../entity/ContaReceber";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberTituloList from "../entity/ContaReceberTituloList";
import RecebimentoTitulo from "../entity/RecebimentoTitulo";
import DatabaseConnection, { Queryable } from "./DatabaseConnection";

export default interface ContaReceberRepository {
  sincronizar(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  // db opcional: o padrao e a conexao solta de sempre, e quem precisa de
  // atomicidade passa o Queryable da transacao.
  insert(contaReceber: ContaReceber, tenant_id: number, db?: Queryable): Promise<void>;
  getAll(filtros: any, tenant_id: number): Promise<ContaReceberTituloList>;
  getByIds(ids: string[], tenant_id: number): Promise<ContaReceberTituloList>;
  atualizarSituacao(titulo: ContaReceberTitulo, tenant_id: number, db?: Queryable): Promise<void>;
  update(titulo: ContaReceberTitulo, tenant_id: number): Promise<void>;
  proximoCodigoManual(tenant_id: number): Promise<string>;
  getSaldoClientes(filtros: any, tenant_id: number): Promise<SaldoCliente[]>;
}

// Posição consolidada: uma linha por cliente. Não materializa título nenhum
// porque, sem filtro de cliente, isso seria o crediário inteiro do tenant.
export type SaldoCliente = {
  clienteCodigo: string;
  clienteNome: string;
  qtdTitulos: number;
  qtdTitulosVencidos: number;
  valor: number;
  recebido: number;
  saldo: number;
  saldoVencido: number;
  vencimentoMaisAntigo: string;
  ultimoRecebimento: string;
};

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

// Resolve os nomes que conta_receber nao guarda: cliente e forma de pagamento
// ficam gravados so como codigo. Duas consultas por lote, nunca por linha.
//
// Deliberadamente fora do SELECT principal, e nao como JOIN: os filtros de
// getAll montam o WHERE com nomes de coluna sem prefixo (status, codigo,
// descricao...), que existem tambem em clientes - um JOIN os tornaria ambiguos.
async function carregarNomes(titulos: ContaReceberTitulo[], tenant_id: number): Promise<void> {
  if (titulos.length === 0) return;

  const codigos = Array.from(new Set(titulos.map((titulo) => titulo.clienteCodigo).filter((codigo) => !!codigo)));

  if (codigos.length > 0) {
    // Sem nome cadastrado o titulo continua aparecendo com o codigo: cliente
    // que so existe no PDV e nunca subiu para a nuvem nao pode sumir da tela.
    const clientes = await DatabaseConnection.queryAll("select codigo, nome from clientes where tenant_id = $1 and codigo = ANY($2)", [tenant_id, codigos]);

    const nomePorCliente: { [codigo: string]: string } = {};
    clientes.forEach((row: any) => (nomePorCliente[String(row.codigo)] = row.nome || ""));
    titulos.forEach((titulo) => (titulo.clienteNome = nomePorCliente[String(titulo.clienteCodigo)] || ""));
  }

  const formas = await DatabaseConnection.queryAll("select codigo, nome from forma_pagamento where tenant_id = $1", [tenant_id]);

  const nomePorForma: { [codigo: string]: string } = {};
  formas.forEach((row: any) => (nomePorForma[String(row.codigo)] = row.nome || ""));
  titulos.forEach((titulo) => titulo.recebimentos.forEach((recebimento) => (recebimento.formaPagamentoNome = nomePorForma[String(recebimento.formaPagamento)] || "")));
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

  async insert(contaReceber: ContaReceber, tenant_id: number, db: Queryable = DatabaseConnection): Promise<void> {
    for (const titulo of contaReceber.titulos.items) {
      await db.query(
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
    await carregarNomes(list.items, tenant_id);

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
    await carregarNomes(list.items, tenant_id);

    return list;
  }

  // O saldo e clampado POR TITULO (greatest(..., 0)), e nao no total: e a mesma
  // regra de ContaReceberTitulo.valorAReceber(). Somando antes de clampar, um
  // titulo pago a maior por um centavo abateria do saldo do cliente e o
  // consolidado deixaria de bater com o extrato que o usuario abre em seguida.
  async getSaldoClientes(filtros: any, tenant_id: number): Promise<SaldoCliente[]> {
    let sql = `
      select c.cliente_codigo,
             max(cl.nome)                                                       as cliente_nome,
             count(*)                                                           as qtd_titulos,
             count(*) filter (where t.saldo > 0 and c.data_vencimento < current_date) as qtd_vencidos,
             sum(c.valor)                                                       as valor,
             sum(t.recebido)                                                    as recebido,
             sum(t.saldo)                                                       as saldo,
             coalesce(sum(t.saldo) filter (where c.data_vencimento < current_date), 0) as saldo_vencido,
             min(c.data_vencimento) filter (where t.saldo > 0)                  as vencimento_mais_antigo,
             max(t.ultimo_pagamento)                                            as ultimo_recebimento
        from conta_receber c
        left join clientes cl on cl.tenant_id = c.tenant_id and cl.codigo = c.cliente_codigo
        -- lateral sobre subconsulta so de agregados: sempre devolve exatamente
        -- uma linha, entao nenhum titulo se perde por falta de recebimento.
        cross join lateral (
          select coalesce(sum(r.valor), 0) as recebido,
                 max(r.data_pagamento)     as ultimo_pagamento,
                 greatest(c.valor - coalesce(sum(r.valor), 0) - coalesce(sum(r.valor_desconto), 0), 0) as saldo
            from conta_receber_recebimento r
           where r.tenant_id = c.tenant_id and r.conta_receber_id = c.id and r.estornado = 0
        ) t
       where c.tenant_id = $1 and c.cancelado = 0 and c.status <> 'CANCELADO'`;

    const params: any[] = [tenant_id];
    let index = 2;

    if (filtros.selectedLoja) {
      sql += ` and c.loja = $${index++}`;
      params.push(Number(filtros.selectedLoja));
    }
    if (filtros.dataVencimentoAte) {
      sql += ` and c.data_vencimento <= $${index++}`;
      params.push(filtros.dataVencimentoAte);
    }
    if (filtros.clienteFiltro) {
      sql += ` and (c.cliente_codigo ILIKE $${index} or cl.nome ILIKE $${index})`;
      params.push(`%${filtros.clienteFiltro}%`);
      index++;
    }

    sql += " group by c.cliente_codigo";
    // Por padrao mostra so quem deve: a lista serve para cobrar.
    if (String(filtros.somenteComSaldo ?? "1") === "1") sql += " having sum(t.saldo) > 0";
    sql += " order by sum(t.saldo) desc";

    const rows = await DatabaseConnection.queryAll(sql, params);

    // decimal do Postgres volta como string pelo pg: somar sem converter concatena.
    return rows.map((row: any) => ({
      clienteCodigo: row.cliente_codigo || "",
      clienteNome: row.cliente_nome || "",
      qtdTitulos: Number(row.qtd_titulos || 0),
      qtdTitulosVencidos: Number(row.qtd_vencidos || 0),
      valor: Number(row.valor || 0),
      recebido: Number(row.recebido || 0),
      saldo: Number(row.saldo || 0),
      saldoVencido: Number(row.saldo_vencido || 0),
      vencimentoMaisAntigo: row.vencimento_mais_antigo,
      ultimoRecebimento: row.ultimo_recebimento,
    }));
  }

  async atualizarSituacao(titulo: ContaReceberTitulo, tenant_id: number, db: Queryable = DatabaseConnection): Promise<void> {
    await db.query("update conta_receber set status = $1, cancelado = $2, updated_at = now() where id = $3 and tenant_id = $4", [titulo.status, titulo.cancelado, titulo.id, tenant_id]);
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
