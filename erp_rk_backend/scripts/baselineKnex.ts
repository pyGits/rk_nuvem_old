import Knex from "knex";
import config from "../knexfile";

/**
 * Alinha o histórico do knex antes do `migrate:latest`, e roda a cada deploy.
 *
 * As tabelas antigas deste banco foram criadas à mão em produção, sem passar
 * pelo knex: a `knex_migrations` não registra nenhuma delas. Sem este passo, um
 * `migrate:latest` não vê "uma migration pendente" — vê TODAS desde 2025 e tenta
 * reexecutar o histórico inteiro. Em 26/08/2026 isso parou na primeira
 * (`create_cests_table`, "relation cests already exists"), mas na fila vinham um
 * DROP CONSTRAINT na PK de `nao_fiscals` e um UPDATE em `funcionarios`.
 *
 * O que o script faz: registra as migrations da lista LEGADO como já aplicadas.
 * Não cria, não altera e não apaga nenhuma tabela de negócio, e não toca em
 * nenhuma linha de dado — escreve apenas na tabela de controle do knex.
 *
 * A lista é FIXA e fechada de propósito. Nada de "detectar se está aplicada":
 * essas sete nunca devem rodar sozinhas em produção. Se um dia for preciso
 * aplicar uma delas de fato, é decisão consciente, com `migrate:up <arquivo>`.
 * Migrations criadas a partir de 27/08/2026 não entram aqui e são aplicadas
 * normalmente pelo `migrate:latest` do deploy.
 *
 * É idempotente: do segundo deploy em diante não insere nada.
 */
const LEGADO = [
  "20250316000002_create_cests_table.ts",
  "20260626000000_create_produto_codigos_barras_table.ts",
  "20260708000000_create_nfe_and_loja_sefaz.ts",
  "20260728000000_fix_nao_fiscais_pk_por_loja.ts",
  "20260729000000_funcionarios_cargo_comissao_default.ts",
  "20260730000000_create_downloads_table.ts",
  "20260818000000_create_feedbacks_table.ts",
];

async function main() {
  const ambiente = process.env.NODE_ENV || "development";
  const knex = Knex(config[ambiente]);

  try {
    // Mesmo DDL que o knex usaria; num banco onde ele nunca rodou, elas ainda
    // não existem.
    await knex.raw(`
      CREATE TABLE IF NOT EXISTS knex_migrations (
        id             serial PRIMARY KEY,
        name           varchar(255),
        batch          integer,
        migration_time timestamptz
      )
    `);
    await knex.raw(`
      CREATE TABLE IF NOT EXISTS knex_migrations_lock (
        index     serial PRIMARY KEY,
        is_locked integer
      )
    `);

    // Uma execução interrompida deixa o lock preso e o próximo migrate falha
    // com "Migration table is already locked".
    await knex.raw(`
      INSERT INTO knex_migrations_lock (is_locked)
      SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM knex_migrations_lock)
    `);
    await knex.raw(`UPDATE knex_migrations_lock SET is_locked = 0`);

    const registradas = await knex("knex_migrations").select("name");
    const jaRegistradas = new Set(registradas.map((linha: any) => linha.name));
    const faltando = LEGADO.filter((nome) => !jaRegistradas.has(nome));

    if (faltando.length === 0) {
      console.log("Baseline do knex: nada a fazer, histórico já alinhado.");
      return;
    }

    // batch 0 deixa o baseline visivelmente separado das migrations que
    // realmente rodaram neste banco.
    await knex("knex_migrations").insert(
      faltando.map((nome) => ({ name: nome, batch: 0, migration_time: new Date() }))
    );

    console.log(`Baseline do knex: ${faltando.length} migration(s) legada(s) marcada(s) como aplicada(s):`);
    faltando.forEach((nome) => console.log(`  - ${nome}`));
  } finally {
    await knex.destroy();
  }
}

main().catch((erro) => {
  console.error("Falha no baseline do knex:", erro.message);
  process.exit(1);
});
