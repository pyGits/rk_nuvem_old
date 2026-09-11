import type { Knex } from "knex";

// O numero do recibo nasceu como coluna das linhas de recebimento, com unique
// em (tenant_id, recibo_numero). So que uma baixa de varios titulos gera uma
// linha por titulo, todas com o mesmo numero - e justamente isso que torna a
// operacao reimprimivel. A unique entao proibia o caso que deveria permitir:
// receber dois titulos de uma vez terminava em "duplicate key value violates
// unique constraint conta_receber_recebimento_recibo_numero_unique", com o
// recebimento inteiro desfeito pelo rollback.
//
// O recibo passa a ter tabela propria, uma linha por recibo: e la que
// (tenant_id, numero) e unico, sem atrapalhar as linhas filhas. O conteudo do
// comprovante continua derivado do GROUP BY das linhas - esta tabela existe
// para reservar o numero, nao para guardar o recibo.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("conta_receber_recibo", (table) => {
    table.text("id").primary();
    table.integer("tenant_id").notNullable();
    table.integer("numero").notNullable();
    table.timestamp("created_at").defaultTo(knex.fn.now());

    table.unique(["tenant_id", "numero"], { indexName: "conta_receber_recibo_tenant_numero_unique" });
  });

  // Os recibos que ja existem nas linhas viram linhas da tabela nova, para que
  // a numeracao continue de onde parou. O "do nothing" cobre o caso de dois
  // recibos historicos terem ficado com o mesmo numero: a tabela fica com um, e
  // nada quebra na migracao.
  await knex.raw(`
    insert into conta_receber_recibo (id, tenant_id, numero, created_at)
    select recibo_id, tenant_id, min(recibo_numero), min(created_at)
      from conta_receber_recebimento
     where recibo_id is not null and recibo_numero is not null
     group by recibo_id, tenant_id
    on conflict do nothing`);

  // Sai a unique que impedia a baixa de varios titulos; entra um indice comum,
  // porque a busca do comprovante pelo numero continua precisando dele.
  await knex.raw("drop index if exists conta_receber_recebimento_recibo_numero_unique");
  await knex.raw(`create index if not exists conta_receber_recebimento_recibo_numero_index
                    on conta_receber_recebimento (tenant_id, recibo_numero)`);
}

export async function down(knex: Knex): Promise<void> {
  await knex.raw("drop index if exists conta_receber_recebimento_recibo_numero_index");
  await knex.schema.dropTableIfExists("conta_receber_recibo");

  // A unique original so volta a ser criavel se nenhum recibo tiver mais de uma
  // linha. Onde houver, o banco recusa - e e o comportamento correto: ela e
  // incompativel com o dado que o sistema grava.
  await knex.raw(`create unique index if not exists conta_receber_recebimento_recibo_numero_unique
                    on conta_receber_recebimento (tenant_id, recibo_numero)
                 where recibo_numero is not null`);
}
