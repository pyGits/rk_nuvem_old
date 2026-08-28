import type { Knex } from "knex";

// Um recebimento no web pode quitar varios titulos de uma vez: o valor e
// rateado e vira uma linha de conta_receber_recebimento por titulo. Ate aqui
// cada linha nascia com um uuid proprio e nada as ligava, entao a operacao
// "recebi R$ 300 do fulano" nao existia como entidade - so as suas partes.
//
// recibo_id devolve essa identidade, e com ela o comprovante pode ser gerado
// de novo a qualquer momento a partir do dado. O PDF nao e guardado: gerar sob
// demanda e sempre consistente com o que esta gravado.
//
// recibo_numero e o numero legivel, sequencial por tenant - um uuid e inutil
// num papel que o cliente guarda e cita no balcao.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.alterTable("conta_receber_recebimento", (table) => {
    // Nullable e sem default de proposito: um NOT NULL DEFAULT jogaria o
    // historico inteiro dentro de um unico recibo falso.
    table.text("recibo_id").nullable();
    table.integer("recibo_numero").nullable();

    table.index(["tenant_id", "recibo_id"], "conta_receber_recebimento_recibo_index");
  });

  // Parcial: as linhas historicas ficam sem numero ate o backfill abaixo, e
  // uma unique comum nao aceitaria varios NULL por tenant em todos os bancos.
  await knex.raw(`create unique index conta_receber_recebimento_recibo_numero_unique
                    on conta_receber_recebimento (tenant_id, recibo_numero)
                 where recibo_numero is not null`);

  // Backfill: reconstitui os recebimentos ja gravados agrupando o que uma mesma
  // chamada de "receber" necessariamente compartilhava. Sem isso o operador
  // continuaria sem conseguir reimprimir o que ja liquidou, que e justamente a
  // queixa que originou esta mudanca.
  //
  // cliente_codigo entra na particao para garantir que nenhum recibo retroativo
  // atravesse clientes. Usar o proprio id da linha como recibo_id dispensa
  // extensao de uuid no banco, e o "where recibo_id is null" deixa o comando
  // re-executavel.
  //
  // date_trunc('second', created_at) e a parte imprecisa: cada linha nasceu em
  // sua propria transacao implicita, entao os timestamps de uma mesma baixa
  // diferem por milissegundos. O risco e duas baixas distintas do mesmo cliente,
  // mesma forma, no mesmo segundo virarem um recibo so - mesmo cliente e mesmo
  // dinheiro, e as colunas sao removiveis pelo down().
  await knex.raw(`
    update conta_receber_recebimento r
       set recibo_id = g.novo_id
      from (
        select r2.id,
               first_value(r2.id) over (
                 partition by r2.tenant_id, c.cliente_codigo, r2.data_pagamento,
                              coalesce(r2.forma_pagamento, ''), coalesce(r2.usuario, ''),
                              coalesce(r2.origem, ''), date_trunc('second', r2.created_at)
                 order by r2.created_at, r2.id
               ) as novo_id
          from conta_receber_recebimento r2
          join conta_receber c
            on c.id = r2.conta_receber_id and c.tenant_id = r2.tenant_id
         where r2.recibo_id is null
      ) g
     where r.id = g.id and r.recibo_id is null`);

  // Numera os grupos por tenant, do mais antigo para o mais novo.
  await knex.raw(`
    with grupos as (
      select tenant_id, recibo_id, min(created_at) as quando
        from conta_receber_recebimento
       where recibo_numero is null and recibo_id is not null
       group by tenant_id, recibo_id
    ), numerados as (
      select tenant_id, recibo_id,
             row_number() over (partition by tenant_id order by quando, recibo_id) as n
        from grupos
    )
    update conta_receber_recebimento r
       set recibo_numero = numerados.n
      from numerados
     where r.tenant_id = numerados.tenant_id
       and r.recibo_id = numerados.recibo_id
       and r.recibo_numero is null`);
}

export async function down(knex: Knex): Promise<void> {
  await knex.raw("drop index if exists conta_receber_recebimento_recibo_numero_unique");
  await knex.schema.alterTable("conta_receber_recebimento", (table) => {
    table.dropIndex(["tenant_id", "recibo_id"], "conta_receber_recebimento_recibo_index");
    table.dropColumn("recibo_numero");
    table.dropColumn("recibo_id");
  });
}
