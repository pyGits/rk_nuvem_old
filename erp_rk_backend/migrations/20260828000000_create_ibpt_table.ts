import type { Knex } from "knex";

// Tabela IBPT (Lei da Transparencia): o catalogo de NCM com as aliquotas
// aproximadas de tributo. Substitui o NCM.json de 4 MB que vinha embutido no
// bundle do front - com a tabela no banco, atualizar a versao trimestral do
// IBPT passa a ser upload no painel, e nao um novo deploy.
//
// Sem tenant_id de proposito, no mesmo espirito de downloads: o NCM e uma
// tabela publica, igual para todos os clientes.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("ibpt", (table) => {
    table.increments("id").primary();
    // Codigo NCM com 8 digitos. Vem sem pontuacao no arquivo do IBPT.
    table.string("codigo", 8).notNullable();
    // "Excecao" da TIPI: o mesmo NCM pode ter aliquota diferente por EX.
    table.string("ex", 3).notNullable().defaultTo("");
    table.integer("tipo").notNullable().defaultTo(0);
    table.text("descricao").notNullable().defaultTo("");
    // Percentuais aproximados de tributo, como publicados no arquivo.
    table.decimal("nacional_federal", 5, 2).notNullable().defaultTo(0);
    table.decimal("importado_federal", 5, 2).notNullable().defaultTo(0);
    table.decimal("estadual", 5, 2).notNullable().defaultTo(0);
    table.decimal("municipal", 5, 2).notNullable().defaultTo(0);
    table.date("vigencia_inicio").nullable();
    table.date("vigencia_fim").nullable();
    table.string("chave", 10).notNullable().defaultTo("");
    table.string("versao", 20).notNullable().defaultTo("");
    table.string("fonte", 60).notNullable().defaultTo("");
    table.timestamps(true, true);

    // (codigo, ex) e a chave natural do arquivo - conferido nas 12.151 linhas
    // da tabela de referencia, sem nenhuma repeticao.
    table.unique(["codigo", "ex"], { indexName: "ibpt_codigo_ex_unique" });
  });

  // A tela de NCM busca por codigo OU por trecho da descricao enquanto o
  // usuario digita. Sem este indice a busca por texto varre as 12 mil linhas a
  // cada tecla.
  await knex.raw("create index ibpt_descricao_index on ibpt using gin (to_tsvector('portuguese', descricao))");

  // Cada upload substitui a tabela inteira; esta guarda o que foi carregado,
  // para o painel poder mostrar versao e vigencia sem varrer 12 mil linhas.
  await knex.schema.createTable("ibpt_carga", (table) => {
    table.increments("id").primary();
    table.string("arquivo_original", 255).notNullable();
    table.string("versao", 20).notNullable().defaultTo("");
    table.date("vigencia_inicio").nullable();
    table.date("vigencia_fim").nullable();
    table.integer("registros").notNullable().defaultTo(0);
    table.timestamps(true, true);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("ibpt_carga");
  await knex.schema.dropTableIfExists("ibpt");
}
