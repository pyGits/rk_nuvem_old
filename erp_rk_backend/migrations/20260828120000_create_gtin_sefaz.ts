import type { Knex } from "knex";

// Cache das consultas de GTIN ao Cadastro Centralizado (CCG) da SEFAZ.
//
// A chave e o GTIN, nao o produto: o codigo de barras identifica o item de
// forma global, entao uma consulta serve para todos os clientes que vendem
// aquele produto. Foi o que mediu bem melhor que perguntar pela descricao -
// 85% dos produtos irregulares tem GTIN de fabricante.
//
// Guarda TAMBEM a resposta negativa (cStat != 9490, com ncm nulo): "a SEFAZ nao
// tem esse GTIN" e informacao util e evita repetir a consulta. Sem isso o
// mutirao perguntaria de novo a cada rodada exatamente os que nunca respondem.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("gtin_sefaz", (table) => {
    table.increments("id").primary();
    // GTIN-8/12/13/14, so digitos.
    table.string("gtin", 14).notNullable();
    // Null quando a SEFAZ nao devolveu NCM (GTIN desconhecido, ou dono da marca
    // que nao autorizou a publicacao dos dados).
    table.string("ncm", 8).nullable();
    table.string("cest", 7).nullable();
    table.text("xprod").nullable();
    // cStat/xMotivo crus, para diagnosticar sem ter que reconsultar.
    table.string("cstat", 4).notNullable().defaultTo("");
    table.text("xmotivo").nullable();
    table.timestamps(true, true);

    table.unique(["gtin"], { indexName: "gtin_sefaz_gtin_unique" });
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("gtin_sefaz");
}
