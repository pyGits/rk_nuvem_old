import { avisaAlteracao } from "../service/CargaAutomatica";

// Liga a gravação de um cadastro que vai para o PDV ao disparo da carga
// automática (src/infra/service/CargaAutomatica.ts).
//
// POR QUE MIDDLEWARE, E NÃO UMA CHAMADA EM CADA CONTROLLER:
// os cadastros que viram carga são gravados por caminhos bem diferentes — as
// rotas antigas (ProdutoController, PrecoController, ...), as rotas /v2 e /v3,
// que passam por use case e repositório, e a entrada de nota fiscal, que grava
// produto e preço reaproveitando as mesmas rotas. Espalhar a chamada por
// todos eles é garantir que o próximo caminho de gravação nasça sem ela, e o
// defeito disso é silencioso: o cliente liga o parâmetro, altera o produto por
// aquela tela e a carga simplesmente não sai. Aqui é um lugar só.
//
// Registrado cedo na cadeia (antes das rotas), mas quem faz o trabalho é o
// listener de "finish": ele roda depois da resposta, então não atrasa nada e
// já enxerga o req.tenant_id que o verifyJWT preencheu no meio do caminho.
//
// Só 2xx conta: gravação que falhou não marcou carga_pendente e não tem o que
// mandar.

// Caminhos (sem o prefixo /api) cuja gravação marca carga_pendente, ou cujo
// dado o sync leva na carga. Conferido contra as etapas que o sync envia:
// PRODUTOS, PRECOS, TRIBUTACOES, FINALIZADORAS, CLIENTES, FUNCIONARIOS.
//
// Seção, grupo, fornecedor e impostos federais ficam de fora de propósito: não
// são etapas da carga, vão para o PDV embutidos no produto — e alterar um
// deles sem alterar produto nenhum não tem o que enviar.
//
// FORA DA LISTA POR MOTIVO MAIS FORTE: tudo o que o agente da loja SOBE para a
// nuvem — /venda, /vendaItem, /fechamento, /naoFiscal, /contaReceber e,
// principalmente, /estoqueMovimentacao (um POST por item vendido, ver
// uAPIRequest.pas). Esses são o PDV contando o que vendeu, não alguém alterando
// cadastro: nenhum deles marca carga_pendente. Tratá-los como alteração faria
// cada venda pedir uma carga de volta para a loja que acabou de vendê-la, e o
// sync passaria o dia inteiro recebendo carga por causa do próprio movimento.
const CAMINHOS_DE_CARGA = [
  // Cadastro de produto (telas antigas e /v2), preço e estoque.
  /^\/produtos(\/|$)/,
  /^\/v2\/produtos?(\/|$)/,
  /^\/precos(\/|$)/,
  /^\/estoques(\/|$)/,
  // Demais etapas da carga.
  /^\/tributacao(\/|$)/,
  /^\/finalizadoras(\/|$)/,
  /^\/funcionarios(\/|$)/,
  /^\/clientes(\/|$)/,
  // Entrada de nota fiscal: efetivar grava custo em `precos` e movimenta
  // estoque (CompraUseCase.efetivarNota); desfazer estorna a movimentação.
  // Não passam pelas rotas de produto/preço acima, então precisam entrar aqui.
  /^\/v2\/compra\/notas\/efetivar$/,
  /^\/v2\/compra\/notas\/desfazer$/,
];

const METODOS_DE_GRAVACAO = ["POST", "PUT", "PATCH", "DELETE"];

// Exportada para o teste: um caminho errado aqui nao quebra nada visivelmente
// - a carga automatica simplesmente nao sai por aquela tela.
export function gravaDadoDeCarga(method: string, url: string): boolean {
  if (!METODOS_DE_GRAVACAO.includes(method)) return false;

  // originalUrl vem com o prefixo /api e pode trazer querystring.
  const caminho = url.split("?")[0].replace(/^\/api/, "");
  return CAMINHOS_DE_CARGA.some((padrao) => padrao.test(caminho));
}

export default function cargaAutomaticaMiddleware(req: any, res: any, next: any) {
  if (!gravaDadoDeCarga(req.method, req.originalUrl || req.url || "")) {
    return next();
  }

  res.on("finish", () => {
    if (res.statusCode < 200 || res.statusCode >= 300) return;
    avisaAlteracao(req.tenant_id);
  });

  next();
}
