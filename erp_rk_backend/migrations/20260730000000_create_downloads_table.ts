import type { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("downloads", (table) => {
    table.increments("id").primary();
    table.string("titulo", 100).notNullable();
    table.string("descricao", 255).notNullable().defaultTo("");
    table.string("versao", 30).notNullable().defaultTo("");
    // Nome gerado no disco (uploads/downloads) e o nome que o cliente ve ao salvar.
    table.string("arquivo", 255).notNullable();
    table.string("arquivo_original", 255).notNullable();
    table.bigInteger("tamanho").notNullable().defaultTo(0);
    // Permite tirar do ar sem apagar o arquivo.
    table.boolean("ativo").notNullable().defaultTo(true);
    table.timestamps(true, true);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("downloads");
}
