import type { Knex } from "knex";

// Nivel de acesso dos usuarios web: o dono do inquilino escolhe, no cadastro de
// cada usuario, quais telas aquele usuario pode abrir. Ate aqui nao havia nada
// disso - qualquer usuario web enxergava e fazia exatamente o mesmo que o dono.
//
// Uma linha = uma tela liberada para um usuario. A ausencia de linha e a
// negacao; nao existe linha de "proibido".
//
// POR QUE TABELA PROPRIA, E NAO UMA COLUNA EM `usuarios`:
// o hook Usuario.beforeSave (src/models/Usuario.ts) re-hasheia a senha em todo
// save, e o updateUsuario ja grava com individualHooks: true. Gravar acesso
// pelo model Sequelize hashearia um hash e arrombaria o login de quem so teve
// um checkbox alterado. Com tabela separada, escrita por knex, esse acidente
// nao tem como acontecer. De quebra, mexer em acesso deixa de exigir a senha:
// o GET /usuarios/:codigo nao devolve `password`, entao gravar pela tela de
// usuario obriga a redigitar a senha - e trocar um acesso nao pode pedir isso.
//
// POR QUE A CHAVE E (tenant_id, usuario_codigo) E NAO usuarios.id:
// `codigo` e a chave de negocio do usuario em todo o sistema - as rotas sao
// /usuarios/:codigo e o proprio controller busca por codigo + tenant_id. A
// tabela `usuarios` foi criada a mao em producao, fora do knex, entao contar
// com o `id` exigiria conferir no banco de producao se ele esta populado e
// unico. Pelo codigo nao ha essa duvida.
//
// A LINHA '*' (TELA_ACESSO_TOTAL) significa "todas as telas, inclusive as que
// ainda nao existem". E o que o backfill abaixo da a TODOS os usuarios web ja
// cadastrados: ninguem pode perder acesso no dia do deploy. Sem ela, um usuario
// antigo ficaria liberado apenas nas telas de hoje, e a tela criada mes que vem
// nasceria invisivel para ele.
//
// Usuario novo, criado a partir daqui, nasce SEM nenhuma linha - portanto sem
// nenhum acesso, ate o dono marcar.
//
// Se um dia o acesso precisar ser por acao (incluir/editar/excluir), basta uma
// migration que acrescente colunas booleanas aqui.
export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("usuario_permissoes", (table) => {
    table.increments("id").primary();
    table.integer("tenant_id").notNullable();
    table.string("usuario_codigo", 3).notNullable();
    // id do catalogo (src/permissao/CatalogoTelas.ts) ou '*'
    table.string("tela", 60).notNullable();
    table.timestamps(true, true);

    table.unique(["tenant_id", "usuario_codigo", "tela"], {
      indexName: "usuario_permissoes_unique",
    });
    table.index(["tenant_id", "usuario_codigo"], "usuario_permissoes_usuario_index");
  });

  // Backfill: todo usuario web que ja existia continua com acesso a tudo.
  await knex.raw(`
    insert into usuario_permissoes (tenant_id, usuario_codigo, tela, created_at, updated_at)
    select u.tenant_id, u.codigo, '*', now(), now()
      from usuarios u
     where u.tenant_id is not null
       and u.codigo is not null
       and u.codigo <> ''
    on conflict on constraint usuario_permissoes_unique do nothing
  `);
}

// Destrutivo por natureza: derrubar a tabela apaga os acessos que o dono tiver
// configurado. Voltar atras devolve o comportamento antigo (todo usuario web
// com acesso a tudo), que e seguro do ponto de vista de ninguem ficar travado.
export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists("usuario_permissoes");
}
