import ExpressAdapter from "./src/infra/server/httpServer";
import V2CompraRoutes from "./src/routes/v2/v2.compra";
import V2FornecedorRoutes from "./src/routes/v2/v2.fornecedor";
import V2ProdutoRoutes from "./src/routes/v2/v2.produto";
import V2SecaoRoutes from "./src/routes/v2/v2.secao";
import V2GrupoRoutes from "./src/routes/v2/v2.grupo";
import v2Tributacao from "./src/routes/v2/v2.tributacao";
import V2ImpostosFederais from "./src/routes/v2/v2.impostosFederais";
import v2Associacao from "./src/routes/v2/v2.associacao";
import v2Lojas from "./src/routes/v2/v2.lojas";
import v2Contapagar from "./src/routes/v2/v2.contaPagar";
import v2CategoriaFinanceira from "./src/routes/v2/v2.categoriaFinanceira";
import v2SubCategoriaFinanceira from "./src/routes/v2/v2.subCategoriaFinanceira";
import v2FormaPagamento from "./src/routes/v2/v2.formaPagamento";
import v2ContaPagarTitulo from "./src/routes/v2/v2.contaPagarTitulo";
import v2ContaReceber from "./src/routes/v2/v2.contaReceber";
import v3Produto from "./src/routes/v3/v3.produto";
import v3NCM from "./src/routes/v3/v3.ncm";
import v3CEST from "./src/routes/v3/v3.cest";
import MigrateFromRKUseCase from "./src/infra/usecase/MigrateFromRKUseCase";
import MigrateFromSyspdvUseCase from "./src/infra/usecase/MigrateFromSyspdvUseCase";
import SefazScheduler from "./src/infra/service/sefaz/SefazScheduler";

// Rede de seguranca: a partir do Node 15 uma promise rejeitada sem catch ENCERRA
// o processo. As rotas /v2 e /v3 passam pelo httpServer, que captura excecao do
// handler; as 25 rotas antigas vao direto no Express, e nelas um handler async
// que rejeita nao vira resposta de erro - vira queda do backend inteiro. Uma
// consulta de relatorio que falha nao pode deslogar todo mundo do sistema.
//
// Registrar isto nao dispensa o try/catch por rota: sem ele a requisicao fica
// pendurada ate o timeout do cliente. O que muda e que o processo sobrevive.
process.on("unhandledRejection", (motivo: any) => {
  console.error("[unhandledRejection]", motivo?.stack || motivo);
});

ExpressAdapter.listen();
V2FornecedorRoutes.register();
V2CompraRoutes.register();
V2ProdutoRoutes.register();
V2SecaoRoutes.register();
V2GrupoRoutes.register();
v2Tributacao.register();
V2ImpostosFederais.register();
v2Associacao.register();
v2Lojas.register();
v2Contapagar.register();
v2CategoriaFinanceira.register();
v2SubCategoriaFinanceira.register();
v2FormaPagamento.register();
v2ContaPagarTitulo.register();
v2ContaReceber.register();

v3Produto.register();
v3NCM.register();
v3CEST.register();

// Sincronização automática das notas de entrada na SEFAZ (a cada 1h, lojas com certificado válido).
SefazScheduler.start();
// MigrateFromSyspdvUseCase.execute(32);
// MigrateFromSyspdvUseCase.migrateCodigosAuxiliares(32);
// MigrateFromRKUseCase.execute(36);
