import DatabaseConnection, { Queryable } from "./DatabaseConnection";

// Um recibo e derivado, nao armazenado: as linhas de conta_receber_recebimento
// que compartilham recibo_id sao a operacao inteira. Tudo que o comprovante
// precisa sai de um GROUP BY, e por isso nao existe tabela de cabecalho.
export type ReciboTitulo = {
  id: string;
  codigo: string;
  prestacao: number;
  dataVencimento: string;
  valorTitulo: number;
  valorRecebimento: number;
  descontoRecebimento: number;
  saldoTitulo: number;
};

export type Recibo = {
  reciboId: string;
  reciboNumero: number;
  dataPagamento: string;
  lojaId: number;
  clienteCodigo: string;
  clienteNome: string;
  clienteCpf: string;
  formaPagamento: string;
  formaPagamentoNome: string;
  qtdTitulos: number;
  valor: number;
  juros: number;
  multa: number;
  desconto: number;
  valorEmCaixa: number;
  estornado: number;
  estornadoParcial: boolean;
  titulos: ReciboTitulo[];
};

export default interface ContaReceberReciboRepository {
  getAll(filtros: any, tenant_id: number): Promise<Recibo[]>;
  getById(reciboId: string, tenant_id: number): Promise<Recibo | null>;
  estornar(reciboId: string, tenant_id: number, db?: Queryable): Promise<string[]>;
}

export class ContaReceberReciboRepositoryPG implements ContaReceberReciboRepository {
  async getAll(filtros: any, tenant_id: number): Promise<Recibo[]> {
    let sql = `
      select r.recibo_id,
             min(r.recibo_numero)   as recibo_numero,
             min(r.data_pagamento)  as data_pagamento,
             min(c.loja)            as loja,
             min(c.cliente_codigo)  as cliente_codigo,
             min(c.cliente_cpf)     as cliente_cpf,
             min(cl.nome)           as cliente_nome,
             min(r.forma_pagamento) as forma_pagamento,
             min(fp.nome)           as forma_pagamento_nome,
             count(*)               as qtd_titulos,
             sum(r.valor)           as valor,
             sum(r.valor_juros)     as juros,
             sum(r.valor_multa)     as multa,
             sum(r.valor_desconto)  as desconto,
             min(r.estornado)       as estornado_min,
             max(r.estornado)       as estornado_max
        from conta_receber_recebimento r
        join conta_receber c on c.id = r.conta_receber_id and c.tenant_id = r.tenant_id
        -- LEFT, nunca INNER: cliente que so existe no PDV e forma sem cadastro
        -- nao podem fazer o recibo desaparecer da lista.
        left join clientes cl        on cl.tenant_id = c.tenant_id and cl.codigo = c.cliente_codigo
        left join forma_pagamento fp on fp.tenant_id = r.tenant_id and fp.codigo = r.forma_pagamento
       where r.tenant_id = $1 and r.recibo_id is not null`;

    const params: any[] = [tenant_id];
    let index = 2;

    if (filtros.reciboId) {
      sql += ` and r.recibo_id = $${index++}`;
      params.push(filtros.reciboId);
    }
    if (filtros.dataDe) {
      sql += ` and r.data_pagamento >= $${index++}`;
      params.push(filtros.dataDe);
    }
    if (filtros.dataAte) {
      sql += ` and r.data_pagamento <= $${index++}`;
      params.push(filtros.dataAte);
    }
    if (filtros.selectedCliente) {
      sql += ` and c.cliente_codigo = $${index++}`;
      params.push(filtros.selectedCliente);
    }
    if (filtros.selectedLoja) {
      sql += ` and c.loja = $${index++}`;
      params.push(Number(filtros.selectedLoja));
    }
    if (filtros.formaPagamento) {
      sql += ` and r.forma_pagamento = $${index++}`;
      params.push(filtros.formaPagamento);
    }
    if (String(filtros.incluirEstornados || "0") !== "1") {
      sql += " and r.estornado = 0";
    }

    sql += " group by r.recibo_id order by min(r.data_pagamento) desc, min(r.recibo_numero) desc";

    const rows = await DatabaseConnection.queryAll(sql, params);
    if (rows.length === 0) return [];

    const recibos = rows.map(montarRecibo);
    await carregarTitulos(recibos, tenant_id);

    return recibos;
  }

  async getById(reciboId: string, tenant_id: number): Promise<Recibo | null> {
    // Reimpressao mostra o recibo como ele esta hoje, estornado inclusive - por
    // isso incluirEstornados. Esconder o estorno transformaria a 2a via em
    // comprovante de um pagamento que nao existe mais.
    const [recibo] = await this.getAll({ reciboId, incluirEstornados: "1" }, tenant_id);
    return recibo || null;
  }

  // Devolve os ids dos titulos afetados para quem chamou recalcular a situacao
  // deles: sem isso o titulo fica LIQUIDADO sem nenhum recebimento valido.
  async estornar(reciboId: string, tenant_id: number, db: Queryable = DatabaseConnection): Promise<string[]> {
    const rows = await db.queryAll("select distinct conta_receber_id from conta_receber_recebimento where tenant_id = $1 and recibo_id = $2 and estornado = 0", [tenant_id, reciboId]);

    if (rows.length === 0) return [];

    await db.query("update conta_receber_recebimento set estornado = 1, updated_at = now() where tenant_id = $1 and recibo_id = $2 and estornado = 0", [tenant_id, reciboId]);

    return rows.map((row: any) => row.conta_receber_id);
  }
}

// decimal do Postgres volta como string pelo pg - somar sem converter concatena.
function numero(valor: any): number {
  return Number(valor || 0);
}

function montarRecibo(row: any): Recibo {
  const valor = numero(row.valor);
  const juros = numero(row.juros);
  const multa = numero(row.multa);

  return {
    reciboId: row.recibo_id,
    reciboNumero: numero(row.recibo_numero),
    dataPagamento: row.data_pagamento,
    lojaId: numero(row.loja),
    clienteCodigo: row.cliente_codigo || "",
    clienteNome: row.cliente_nome || "",
    clienteCpf: row.cliente_cpf || "",
    formaPagamento: row.forma_pagamento || "",
    formaPagamentoNome: row.forma_pagamento_nome || "",
    qtdTitulos: numero(row.qtd_titulos),
    valor,
    juros,
    multa,
    desconto: numero(row.desconto),
    // O que o cliente efetivamente entregou (espelha RecebimentoTitulo.valorEmCaixa).
    valorEmCaixa: valor + juros + multa,
    estornado: numero(row.estornado_min) === 1 ? 1 : 0,
    // Estorno antigo era por titulo, entao um recibo de varios titulos pode
    // estar estornado pela metade. A 2a via precisa dizer isso.
    estornadoParcial: numero(row.estornado_min) !== numero(row.estornado_max),
    titulos: [],
  };
}

// Uma consulta para todos os recibos do lote, nunca uma por recibo.
async function carregarTitulos(recibos: Recibo[], tenant_id: number): Promise<void> {
  const ids = recibos.map((recibo) => recibo.reciboId);

  const rows = await DatabaseConnection.queryAll(
    `select r.recibo_id, r.valor, r.valor_desconto,
            c.id, c.codigo, c.prestacao, c.data_vencimento, c.valor as valor_titulo,
            coalesce((select sum(v.valor) + sum(v.valor_desconto)
                        from conta_receber_recebimento v
                       where v.conta_receber_id = c.id and v.tenant_id = c.tenant_id and v.estornado = 0), 0) as abatido
       from conta_receber_recebimento r
       join conta_receber c on c.id = r.conta_receber_id and c.tenant_id = r.tenant_id
      where r.tenant_id = $1 and r.recibo_id = ANY($2)
      order by c.data_vencimento, c.codigo`,
    [tenant_id, ids]
  );

  const porRecibo: { [id: string]: ReciboTitulo[] } = {};
  rows.forEach((row: any) => {
    if (!porRecibo[row.recibo_id]) porRecibo[row.recibo_id] = [];

    const valorTitulo = numero(row.valor_titulo);
    porRecibo[row.recibo_id].push({
      id: row.id,
      codigo: row.codigo,
      prestacao: numero(row.prestacao),
      dataVencimento: row.data_vencimento,
      valorTitulo,
      valorRecebimento: numero(row.valor),
      descontoRecebimento: numero(row.valor_desconto),
      // Saldo atual do titulo, com o piso em zero - mesma regra de
      // ContaReceberTitulo.valorAReceber().
      saldoTitulo: Math.max(valorTitulo - numero(row.abatido), 0),
    });
  });

  recibos.forEach((recibo) => (recibo.titulos = porRecibo[recibo.reciboId] || []));
}
