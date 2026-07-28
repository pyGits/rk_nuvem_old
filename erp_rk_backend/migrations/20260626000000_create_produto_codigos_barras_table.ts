import type { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("produto_codigos_barras", (table) => {
    table.increments("id").primary();
    table.integer("tenant_id").notNullable();
    table.string("codigo_produto", 6).notNullable();
    table.string("codigo_barras", 14).notNullable();
    table.timestamps(true, true);

    // Garante que um mesmo código de barras auxiliar não se repita dentro do tenant
    table.unique(["tenant_id", "codigo_barras"], {
      indexName: "uq_produto_codigos_barras_tenant_codigo",
    });
    // Acelera a busca dos códigos auxiliares de um produto
    table.index(["tenant_id", "codigo_produto"], "idx_produto_codigos_barras_produto");
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("produto_codigos_barras");
}
