import type { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("cests", (table) => {
    table.increments("id").primary();
    table.string("cest", 20).notNullable();
    table.string("ncm", 20).notNullable();
    table.text("descricao").nullable();
    table.timestamps(true, true);
  });

  await knex.raw(`
    CREATE INDEX idx_cests_cest ON cests(cest);
    CREATE INDEX idx_cests_ncm ON cests(ncm);
    CREATE INDEX idx_cests_descricao ON cests(descricao);
  `);
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("cests");
}
