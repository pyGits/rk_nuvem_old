import DatabaseConnection from "../infra/repository/DatabaseConnection";
import { TELA_ACESSO_TOTAL } from "./CatalogoTelas";

// Acesso a usuario_permissoes por SQL cru, no mesmo padrao dos repositorios do
// v2. De proposito NAO existe model Sequelize desta tabela: o `define` global
// traz timestamps/underscored e abre espaco para hooks, e foi justamente um
// hook (Usuario.beforeSave, que re-hasheia a senha) que motivou tirar o acesso
// de dentro da entidade `usuarios`. Ver o comentario da migration
// 20260914000000_create_usuario_permissoes.ts.

export default {
  // Telas gravadas para o usuario. A marca '*' pode vir no meio das outras -
  // quem interpreta e o PermissaoService.
  async listarTelas(tenant_id: number, usuario_codigo: string): Promise<string[]> {
    const linhas = await DatabaseConnection.queryAll(
      "select tela from usuario_permissoes where tenant_id = $1 and usuario_codigo = $2",
      [tenant_id, usuario_codigo]
    );

    return linhas.map((linha: any) => linha.tela);
  },

  // Troca o conjunto inteiro de uma vez. Apagar e regravar dentro da mesma
  // transacao mantem o estado sempre coerente: nao existe instante em que o
  // usuario fique com meia lista, nem sobra de tela desmarcada.
  async substituirTelas(tenant_id: number, usuario_codigo: string, telas: string[]): Promise<void> {
    await DatabaseConnection.transaction(async (tx) => {
      await tx.query("delete from usuario_permissoes where tenant_id = $1 and usuario_codigo = $2", [
        tenant_id,
        usuario_codigo,
      ]);

      for (const tela of telas) {
        await tx.query(
          `insert into usuario_permissoes (tenant_id, usuario_codigo, tela, created_at, updated_at)
           values ($1, $2, $3, now(), now())`,
          [tenant_id, usuario_codigo, tela]
        );
      }
    });
  },

  // Usado pela tela de acessos para saber se o usuario esta com a marca de
  // acesso irrestrito (o padrao de quem ja existia antes desta feature).
  async temAcessoTotal(tenant_id: number, usuario_codigo: string): Promise<boolean> {
    const telas = await this.listarTelas(tenant_id, usuario_codigo);
    return telas.includes(TELA_ACESSO_TOTAL);
  },
};
