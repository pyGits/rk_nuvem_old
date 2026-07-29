import type { Knex } from "knex";

/**
 * Inclui `loja` na chave primária de `nao_fiscals`.
 *
 * A PK era (caixa, codigo, tenant_id) — sem a loja. Como cada loja tem seu
 * próprio sequencial de documento não fiscal começando do zero, duas lojas do
 * mesmo tenant chegam ao mesmo `codigo` no mesmo número de caixa, e a segunda
 * loja colide na PK. O agente RKNuvem recebia 400, nunca marcava o registro como
 * NUVEM=1 e reenviava o mesmo documento indefinidamente.
 *
 * Todas as outras tabelas alimentadas pelo agente (`vendas`, `venda_items`,
 * `venda_formas`, `fechamentos`, `fechamento_formas`) já incluem `loja` na
 * chave; `nao_fiscals` era a única fora do padrão.
 *
 * Ampliar a chave nunca gera conflito: o que era único em
 * (caixa, codigo, tenant_id) continua único com uma coluna a mais.
 */
export async function up(knex: Knex): Promise<void> {
  const [{ existe }] = (
    await knex.raw(`
      SELECT count(*)::int AS existe
      FROM pg_constraint
      WHERE conname = 'nao_fiscals_pkey'
        AND conrelid = 'nao_fiscals'::regclass
    `)
  ).rows;

  if (existe) {
    await knex.raw(`ALTER TABLE nao_fiscals DROP CONSTRAINT nao_fiscals_pkey`);
  }

  // tenant_id primeiro: toda consulta do sistema filtra por tenant, então o
  // índice da PK passa a servir também para as buscas por loja dentro do tenant.
  await knex.raw(`
    ALTER TABLE nao_fiscals
      ADD CONSTRAINT nao_fiscals_pkey PRIMARY KEY (tenant_id, loja, caixa, codigo)
  `);
}

export async function down(knex: Knex): Promise<void> {
  // A volta só é possível se não houver duas lojas usando o mesmo (caixa, codigo)
  // dentro do tenant — exatamente o caso que esta migration passou a permitir.
  const [{ colisoes }] = (
    await knex.raw(`
      SELECT count(*)::int AS colisoes FROM (
        SELECT 1 FROM nao_fiscals
        GROUP BY tenant_id, caixa, codigo
        HAVING count(*) > 1
      ) x
    `)
  ).rows;

  if (colisoes > 0) {
    throw new Error(
      `Não é possível reverter: ${colisoes} combinação(ões) de (tenant_id, caixa, codigo) ` +
        `passaram a existir em mais de uma loja. Reverter exigiria descartar registros.`
    );
  }

  await knex.raw(`ALTER TABLE nao_fiscals DROP CONSTRAINT nao_fiscals_pkey`);
  await knex.raw(`
    ALTER TABLE nao_fiscals
      ADD CONSTRAINT nao_fiscals_pkey PRIMARY KEY (caixa, codigo, tenant_id)
  `);
}
