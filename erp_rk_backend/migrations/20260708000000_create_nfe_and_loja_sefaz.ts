import type { Knex } from "knex";

/**
 * Integração SEFAZ nativa no backend (sem a pasta `nfe` e sem o banco `erp_nfe`).
 *
 * - Cria a tabela `nfe` no banco principal para armazenar os documentos capturados
 *   na Distribuição de DFe da SEFAZ (XML completo ou apenas o resumo).
 * - Adiciona em `lojas` as colunas necessárias para a comunicação com a SEFAZ:
 *   certificado (.pfx em base64), senha, UF, último NSU consultado e metadados do
 *   certificado (titular, validade) além do controle de sincronização.
 */
export async function up(knex: Knex): Promise<void> {
  const hasNfe = await knex.schema.hasTable("nfe");
  if (!hasNfe) {
    await knex.schema.createTable("nfe", (table) => {
      table.increments("id").primary();
      table.integer("tenant_id").notNullable();
      table.string("chave", 44).notNullable();
      table.text("xml");
      table.string("cnpjcpf", 20);
      table.string("cnpjcpf_fornecedor", 20);
      table.string("nome_fornecedor", 255);
      table.string("nsu", 20);
      // pendente = ainda não foi dado entrada no ERP
      table.boolean("pendente").notNullable().defaultTo(true);
      // resumo = a SEFAZ só entregou o resumo (resNFe); falta manifestar p/ obter o XML completo
      table.boolean("resumo").notNullable().defaultTo(false);
      table.timestamps(true, true);

      table.unique(["tenant_id", "chave"], { indexName: "uq_nfe_tenant_chave" });
      table.index(["tenant_id", "pendente"], "idx_nfe_tenant_pendente");
    });
  }

  const addColumn = async (name: string, builder: (t: Knex.CreateTableBuilder) => void) => {
    const exists = await knex.schema.hasColumn("lojas", name);
    if (!exists) {
      await knex.schema.alterTable("lojas", (table) => builder(table as any));
    }
  };

  await addColumn("certificado", (t) => t.text("certificado"));
  await addColumn("senha", (t) => t.string("senha", 255));
  await addColumn("uf", (t) => t.string("uf", 2));
  await addColumn("ultimo_nsu", (t) => t.string("ultimo_nsu", 15).defaultTo("000000000000000"));
  await addColumn("certificado_titular", (t) => t.string("certificado_titular", 255));
  await addColumn("certificado_validade", (t) => t.timestamp("certificado_validade"));
  await addColumn("ultimo_sync", (t) => t.timestamp("ultimo_sync"));
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("nfe");
  await knex.schema.alterTable("lojas", (table) => {
    table.dropColumn("certificado_titular");
    table.dropColumn("certificado_validade");
    table.dropColumn("ultimo_sync");
    table.dropColumn("ultimo_nsu");
    table.dropColumn("uf");
    // certificado/senha são mantidos por já existirem antes desta migração.
  });
}
