import type { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("feedbacks", (table) => {
    table.increments("id").primary();
    table.integer("tenant_id").notNullable();
    table.text("mensagem").notNullable();
    // 1 a 5, opcional — o cliente pode só escrever sem avaliar.
    table.integer("nota").nullable();
    // Marcado pelo admin ao ler, pra saber o que ainda falta responder.
    table.boolean("lido").notNullable().defaultTo(false);
    table.timestamps(true, true);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("feedbacks");
}
