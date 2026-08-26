import type { Knex } from "knex";

// Contas a receber da nuvem. Cada linha de conta_receber e uma parcela: e assim
// que o crediario nasce no PDV (uma linha por parcela em CUPOM_CREDIARIO) e e
// assim que a tela lista/recebe. O saldo NUNCA e coluna - ele sai dos
// recebimentos - porque o mesmo titulo pode ser reenviado pelo sync (um
// cancelamento no PDV volta o registro para NUVEM = 0) e o reenvio nao pode
// apagar uma baixa lancada no web.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("conta_receber", (table) => {
    table.text("id").primary();
    table.integer("tenant_id").notNullable();
    table.integer("loja").notNullable();
    // Chave de origem: no PDV e o CODIGO do CUPOM_CREDIARIO; no lancamento
    // manual e o sequencial gerado aqui.
    table.string("codigo", 50).notNullable();
    table.string("codigo_cupom", 50).nullable();
    table.string("numero", 12).nullable();
    table.integer("prestacao").nullable();
    table.string("cliente_codigo", 15).nullable();
    table.string("cliente_cpf", 18).nullable();
    table.string("caixa", 3).nullable();
    table.string("vendedor", 15).nullable();
    table.date("data_emissao").nullable();
    table.date("data_vencimento").nullable();
    table.decimal("valor", 15, 2).notNullable().defaultTo(0);
    table.string("descricao", 60).nullable();
    // PDV = veio do crediario; MANUAL = lancado na tela.
    table.string("origem", 10).notNullable().defaultTo("PDV");
    table.integer("cancelado").notNullable().defaultTo(0);
    table.string("status", 10).notNullable().defaultTo("ABERTO");
    table.timestamps(true, true);

    table.unique(["tenant_id", "loja", "codigo"], { indexName: "conta_receber_tenant_loja_codigo_unique" });
    table.index(["tenant_id", "cliente_codigo"], "conta_receber_tenant_cliente_index");
    table.index(["tenant_id", "data_vencimento"], "conta_receber_tenant_vencimento_index");
  });

  await knex.schema.createTable("conta_receber_recebimento", (table) => {
    table.text("id").primary();
    table.integer("tenant_id").notNullable();
    table.text("conta_receber_id").notNullable();
    table.date("data_pagamento").notNullable();
    table.string("forma_pagamento", 10).nullable();
    // valor abate o titulo; juros e multa sao cobrados a mais (entram em caixa,
    // nao abatem) e o desconto abate o saldo sem entrar em caixa.
    table.decimal("valor", 15, 2).notNullable().defaultTo(0);
    table.decimal("valor_juros", 15, 2).notNullable().defaultTo(0);
    table.decimal("valor_multa", 15, 2).notNullable().defaultTo(0);
    table.decimal("valor_desconto", 15, 2).notNullable().defaultTo(0);
    table.string("origem", 10).notNullable().defaultTo("WEB");
    table.string("usuario", 50).nullable();
    table.integer("estornado").notNullable().defaultTo(0);
    table.timestamps(true, true);

    table.index(["tenant_id", "conta_receber_id"], "conta_receber_recebimento_titulo_index");
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("conta_receber_recebimento");
  await knex.schema.dropTableIfExists("conta_receber");
}
