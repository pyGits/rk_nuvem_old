import type { Knex } from "knex";

// Configurações do cliente (inquilino) — uma linha por tenant.
//
// Nasce para guardar o parâmetro da CARGA AUTOMÁTICA: até aqui, alterar um
// produto marcava `carga_pendente = true` e o dado ficava parado até alguém
// abrir "Carga para as Lojas" e clicar em "Enviar alterados". Quem cadastra o
// dia inteiro esquece de clicar, e o PDV fica com preço velho sem ninguém
// perceber. Com o parâmetro ligado, a própria gravação enfileira a carga de
// alterados para as lojas do cliente.
//
// POR QUE TABELA PRÓPRIA, E NÃO COLUNAS EM `tenants`:
// `tenants` é cadastro de cliente e é escrito pelo painel administrativo
// (AdminController.updateTenant, que grava o registro inteiro). Configuração
// operacional do dia a dia, alterada pelo próprio dono na tela de
// Configurações, não pode dividir linha com isso — um update do painel
// sobrescreveria o que o cliente configurou. Separada, cada lado grava o seu.
//
// A ausência de linha é o padrão desligado: cliente que nunca abriu a tela não
// tem linha aqui e continua exatamente com o comportamento de antes (carga só
// quando alguém clica). Ninguém passa a mandar carga sozinho por causa do
// deploy — quem quiser, liga.
//
// Parâmetro novo de configuração do cliente entra como coluna aqui, com
// default que preserve o comportamento atual.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("configuracoes", (table) => {
    table.increments("id").primary();
    // Único: é uma linha por cliente, não um histórico.
    table.integer("tenant_id").notNullable().unique();

    table.boolean("carga_automatica").notNullable().defaultTo(false);

    // Janela de agrupamento, em segundos. A carga não sai na hora: salvar 40
    // produtos seguidos não pode virar 40 pedidos de carga. O contador
    // reinicia a cada gravação e a carga só é enfileirada quando o cliente
    // para de mexer por esse tempo. Ver src/infra/service/CargaAutomatica.ts.
    table.integer("carga_automatica_segundos").notNullable().defaultTo(60);

    table.timestamps(true, true);
  });
}

// Voltar atrás devolve o comportamento antigo (carga só manual), que é o
// seguro: nenhuma loja deixa de poder receber carga, só deixa de recebê-la
// sozinha.
export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("configuracoes");
}
