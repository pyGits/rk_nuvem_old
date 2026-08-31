import type { Knex } from "knex";

// Indice para achar o titulo de convenio a partir do cupom.
//
// A tela de convenio do PDV (uFrmConvenio) vincula o conveniado so ao
// crediario, nunca ao cupom: a venda sobe com codigo_cliente "0" e sem CPF, e
// em vendas nao sobra nada que identifique o comprador. Quem carrega essa
// informacao para a nuvem e a subida de conta a receber, que traz o cupom, o
// caixa e o cliente - entao o relatorio de cupom passa a ler o cliente dali
// quando os outros dois caminhos falham.
//
// conta_receber ja tinha indice por cliente e por vencimento, que sao as buscas
// da tela de contas a receber. Esta e a direcao contraria - do cupom para o
// titulo - e roda uma vez por linha do relatorio.
//
// A data entra na chave porque o fechamento limpa as vendas do banco do PDV e o
// CODIGO do cupom reinicia; (loja, caixa, codigo_cupom) sozinho colidiria entre
// dias.
export const config = { transaction: false };

export async function up(knex: Knex): Promise<void> {
  await knex.raw(`create index concurrently if not exists conta_receber_cupom_index
                    on conta_receber (tenant_id, loja, caixa, codigo_cupom, data_emissao)`);
}

export async function down(knex: Knex): Promise<void> {
  await knex.raw("drop index concurrently if exists conta_receber_cupom_index");
}
