import type { Knex } from "knex";

// Certificado digital proprio do painel, usado para consultar o Cadastro
// Centralizado de GTIN da SEFAZ.
//
// Existe para NAO consultar em nome de um cliente. O CCG bloqueia por consumo
// indevido (cStat 656) e o bloqueio recai sobre o CNPJ do certificado - se
// fosse o de um cliente, uma varredura feita para todos penalizaria um so, que
// nem pediu isso. Com certificado proprio o risco fica com quem opera.
//
// Guarda uma linha so: quem sobe um novo substitui o anterior.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("sefaz_certificado", (table) => {
    table.increments("id").primary();
    // .pfx em base64, mesmo formato ja usado na coluna `lojas.certificado`.
    table.text("certificado").notNullable();
    // Em texto, como em `lojas.senha`: e preciso reabrir o .pfx a cada
    // consulta, entao um hash nao serviria.
    table.string("senha", 255).notNullable();
    // Extraidos do proprio .pfx no upload, so para exibicao no painel.
    table.string("titular", 255);
    table.string("documento", 20);
    table.timestamp("validade");
    table.timestamps(true, true);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("sefaz_certificado");
}
