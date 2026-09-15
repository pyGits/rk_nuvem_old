import { gravaDadoDeCarga } from "./cargaAutomatica.middleware";

// O defeito que estes testes existem para pegar e silencioso: se um caminho
// sair da lista (ou entrar errado), o cliente liga a carga automatica, altera
// o produto por aquela tela e a carga simplesmente nao sai - sem erro, sem
// mensagem, sem log.

describe("carga automatica - o que conta como alteracao", () => {
  it("reconhece a gravacao de produto, preco e estoque", () => {
    expect(gravaDadoDeCarga("POST", "/api/produtos")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/produtos/000123")).toBe(true);
    expect(gravaDadoDeCarga("POST", "/api/precos")).toBe(true);
    expect(gravaDadoDeCarga("POST", "/api/estoques")).toBe(true);
  });

  // O agente da loja sobe um POST /estoqueMovimentacao por item vendido. Se
  // isso contasse como alteracao, cada venda pediria uma carga de volta para a
  // loja que acabou de vende-la, e o sync nunca mais pararia.
  it("ignora o movimento que a loja SOBE para a nuvem", () => {
    expect(gravaDadoDeCarga("POST", "/api/estoqueMovimentacao")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/estoqueMovimentacao/lote")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/venda/lote")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/vendaItem/lote")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/fechamento/lote")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/naoFiscal/lote")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/contaReceber")).toBe(false);
  });

  it("reconhece as demais etapas da carga", () => {
    expect(gravaDadoDeCarga("POST", "/api/tributacao")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/tributacao/001")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/finalizadoras")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/funcionarios/001")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/clientes/001")).toBe(true);
  });

  it("reconhece as rotas /v2 de produto e a entrada de nota fiscal", () => {
    expect(gravaDadoDeCarga("POST", "/api/v2/produto")).toBe(true);
    expect(gravaDadoDeCarga("PUT", "/api/v2/produtos/precos")).toBe(true);
    // Efetivar a nota grava custo em `precos` sem passar pelas rotas de preco.
    expect(gravaDadoDeCarga("POST", "/api/v2/compra/notas/efetivar")).toBe(true);
    expect(gravaDadoDeCarga("POST", "/api/v2/compra/notas/desfazer")).toBe(true);
  });

  it("ignora leitura: consultar cadastro nao e alterar cadastro", () => {
    expect(gravaDadoDeCarga("GET", "/api/produtos")).toBe(false);
    expect(gravaDadoDeCarga("GET", "/api/produtos/000123")).toBe(false);
    expect(gravaDadoDeCarga("GET", "/api/v2/compra/notas/efetivar")).toBe(false);
  });

  it("ignora o que nao vai na carga", () => {
    expect(gravaDadoDeCarga("POST", "/api/secoes")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/fornecedor")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/v2/contaReceber")).toBe(false);
    expect(gravaDadoDeCarga("PUT", "/api/usuarios/001")).toBe(false);
    // A propria carga nao pode se realimentar.
    expect(gravaDadoDeCarga("POST", "/api/cargaAlterados")).toBe(false);
  });

  it("nao confunde caminho que apenas comeca igual", () => {
    expect(gravaDadoDeCarga("POST", "/api/produtosComPrecos")).toBe(false);
    expect(gravaDadoDeCarga("POST", "/api/clientesInativos")).toBe(false);
  });

  it("despreza a querystring", () => {
    expect(gravaDadoDeCarga("PUT", "/api/produtos/000123?loja=001")).toBe(true);
    expect(gravaDadoDeCarga("GET", "/api/produtos?alterados=true")).toBe(false);
  });
});
