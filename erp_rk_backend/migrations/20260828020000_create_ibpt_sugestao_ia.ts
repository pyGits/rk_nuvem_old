import type { Knex } from "knex";

// Cache das sugestoes de NCM feitas por IA.
//
// A chave e a DESCRICAO do produto, nao o produto: "COCA COLA 2L" e a mesma
// pergunta em qualquer cliente, e assim uma consulta serve para todos. Sem
// isso, o mesmo item repetido em 50 inquilinos custaria 50 chamadas.
//
// Existe para a busca por IA rodar uma vez e o botao Conferir so ler o que ja
// foi respondido - a conferencia e usada o tempo todo, a IA nao.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("ibpt_sugestao_ia", (table) => {
    table.increments("id").primary();
    // Descricao exatamente como esta no cadastro: a comparacao e igualdade
    // simples, sem normalizar, para o JOIN nao depender de acento nem caixa.
    table.text("descricao").notNullable();
    // Pode ser null: "a IA olhou e nao soube dizer" e uma resposta util, e
    // guardada para nao perguntar de novo.
    table.string("ncm", 8).nullable();
    table.text("ncm_descricao").nullable();
    table.string("modelo", 60).notNullable().defaultTo("");
    table.timestamps(true, true);

    table.unique(["descricao"], { indexName: "ibpt_sugestao_ia_descricao_unique" });
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("ibpt_sugestao_ia");
}
