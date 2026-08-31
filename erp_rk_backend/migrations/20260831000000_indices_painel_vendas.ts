import type { Knex } from "knex";

// Indices para os filtros de venda do painel de relatorios.
//
// Ate aqui os filtros de cupom (numero, caixa, CPF, vendedor, valor, chave XML,
// cliente, finalizadora) viviam na aba Cupom e eram aplicados no navegador,
// sobre uma lista ja carregada. Agora sobem para o topo da tela e valem para
// todas as abas - e as abas agregadas somam no banco, entao viraram condicao de
// SQL: nas consultas sobre venda_items/venda_formas o filtro de cupom e um
// EXISTS em vendas, e o filtro de finalizadora um EXISTS em venda_formas.
//
// Esses EXISTS rodam por linha. Sem indice, um periodo longo faz um seq scan de
// vendas para cada item vendido, que e exatamente o cenario em que o relatorio
// e usado (fechamento de mes).
//
// As tabelas vendas/venda_items/venda_formas sao legado: nasceram fora do knex,
// nunca tiveram migration. Por isso aqui so entram indices, com IF NOT EXISTS -
// nenhuma coluna, constraint ou dado e tocado.
const INDICES: Array<[string, string, string]> = [
  // Casa o EXISTS inteiro (todas as colunas sao igualdade) e tambem serve as
  // consultas diretas sobre vendas, que sao "tenant + periodo", com ou sem loja.
  ["vendas_painel_cupom_index", "vendas", "(tenant_id, data, caixa, loja, codigo)"],
  // A finalizadora entra no fim: o EXISTS que pergunta "este cupom pagou com
  // X?" se resolve sem tocar na tabela.
  ["venda_formas_painel_cupom_index", "venda_formas", "(tenant_id, data, caixa, loja, codigo_cupom, finalizadora)"],
  ["venda_items_painel_cupom_index", "venda_items", "(tenant_id, data, caixa, loja, codigo_cupom)"],
  // O cupom mostra o cliente mesmo quando o PDV so gravou o CPF do consumidor:
  // o cadastro e casado por CNPJ/CPF so-digitos, dos dois lados. A expressao
  // abaixo tem que ser identica a da consulta para o indice ser usado.
  [
    "clientes_cnpjcpf_digitos_index",
    "clientes",
    "(tenant_id, (regexp_replace(coalesce(cnpjcpf, ''), '[^0-9]', '', 'g')))",
  ],
];

// CREATE INDEX comum trava escrita na tabela ate terminar, e o Sync_NUVEM sobe
// venda o dia inteiro. CONCURRENTLY nao pode rodar dentro de transacao, dai o
// transaction: false. O preco e conhecido: se a criacao for interrompida, o
// indice fica invalido no banco e o IF NOT EXISTS nao o recria - nesse caso e
// preciso derrubar o invalido a mao antes de rodar de novo.
export const config = { transaction: false };

export async function up(knex: Knex): Promise<void> {
  for (const [nome, tabela, colunas] of INDICES) {
    await knex.raw(`create index concurrently if not exists ${nome} on ${tabela} ${colunas}`);
  }
}

export async function down(knex: Knex): Promise<void> {
  for (const [nome] of INDICES) {
    await knex.raw(`drop index concurrently if exists ${nome}`);
  }
}
