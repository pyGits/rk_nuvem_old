import type { Knex } from "knex";

// Erros registrados nos PDVs, enviados pelo Sync_NUVEM.
//
// Ate aqui a tabela ERROS existia so no banco de cada caixa: para ver uma falha
// era preciso alguem no balcao perceber e avisar. Aqui o suporte enxerga de
// fora, de todos os clientes.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("erro_pdv", (table) => {
    table.increments("id").primary();
    table.integer("tenant_id").notNullable();
    table.integer("loja").notNullable().defaultTo(0);
    table.integer("caixa").notNullable().defaultTo(0);
    table.integer("operador").notNullable().defaultTo(0);
    // Identificador da linha no PDV de origem. Junto com tenant/loja/caixa forma
    // a chave natural que torna o reenvio idempotente - o agente repete o envio
    // quando o UPDATE de NUVEM = 1 falha depois de a nuvem ja ter recebido.
    table.integer("codigo").notNullable().defaultTo(0);
    table.date("data").nullable();
    table.string("hora", 8).nullable();
    table.text("erro").notNullable().defaultTo("");
    // Onde aconteceu: a tela, a rotina, ou "EXCECAO NAO TRATADA".
    table.string("origem", 60).notNullable().defaultTo("");
    table.timestamps(true, true);

    table.unique(["tenant_id", "loja", "caixa", "codigo"], { indexName: "erro_pdv_origem_unique" });
    // A consulta do painel e sempre "os mais recentes".
    table.index(["tenant_id", "data"], "erro_pdv_data_index");
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("erro_pdv");
}
