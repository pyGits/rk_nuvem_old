import type { Knex } from "knex";

/**
 * Preenche `cargo` e `comissao` nulos em `funcionarios` e passa a garantir o
 * default no proprio banco.
 *
 * O seeder de tenant novo criava o funcionario "RK" sem esses dois campos, e o
 * agente de carga converte ambos direto para numero: `StrToInt('null')` levanta
 * excecao e derruba a carga de funcionarios inteira do tenant, impedindo a
 * primeira carga de um inquilino recem-criado.
 *
 * "0" e o cargo Operador — o mesmo default do cadastro no front.
 */
export async function up(knex: Knex): Promise<void> {
  await knex.raw(`UPDATE funcionarios SET cargo = '0' WHERE cargo IS NULL OR cargo = ''`);
  await knex.raw(`UPDATE funcionarios SET comissao = 0 WHERE comissao IS NULL`);

  await knex.raw(`ALTER TABLE funcionarios ALTER COLUMN cargo SET DEFAULT '0'`);
  await knex.raw(`ALTER TABLE funcionarios ALTER COLUMN comissao SET DEFAULT 0`);
}

export async function down(knex: Knex): Promise<void> {
  // Os valores preenchidos nao sao revertidos: nao ha como distinguir o que era
  // nulo antes do que foi cadastrado como Operador/comissao zero.
  await knex.raw(`ALTER TABLE funcionarios ALTER COLUMN cargo DROP DEFAULT`);
  await knex.raw(`ALTER TABLE funcionarios ALTER COLUMN comissao DROP DEFAULT`);
}
