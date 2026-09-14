// Catalogo das telas que o dono do inquilino pode liberar ou nao para cada
// usuario web.
//
// Esta e a UNICA fonte da lista. O front nao tem copia: ele recebe este array
// pelo GET /api/me e monta a tela de acessos com o que vier. Duplicar a lista
// no front daria o pior defeito possivel desta feature - o dono marca o acesso,
// grava, e o usuario continua sem ver a tela, sem nenhuma mensagem de erro.
//
// O `id` e a chave estavel: ele aparece gravado em usuario_permissoes.tela, no
// `meta.tela` de cada rota do vue-router e no campo "tela" de cada folha do
// Menu.json do front. Renomear um id exige migration - prefira criar outro.
//
// Tela nova entra em TRES lugares: aqui, no Menu.json e no meta.tela da rota.
//
// Fora do catalogo de proposito: "/" (Inicio) e "/configuracoes" (troca da
// propria senha). As duas ficam sempre liberadas, senao um usuario sem nenhum
// acesso cairia numa tela em branco sem saida nenhuma.

export interface Tela {
  id: string;
  grupo: string;
  rotulo: string;
}

// Marca de acesso irrestrito gravada em usuario_permissoes.tela. Vale para as
// telas de hoje e para as que ainda nao existem - e o que os usuarios web
// criados antes desta feature receberam, para que ninguem perdesse acesso no
// dia em que ela subiu.
export const TELA_ACESSO_TOTAL = "*";

export const CATALOGO_TELAS: Tela[] = [
  // Cadastro                                            /cadastro/*
  { id: "cadastro.produto", grupo: "Cadastro", rotulo: "Produto" },
  { id: "cadastro.loja", grupo: "Cadastro", rotulo: "Loja" },
  { id: "cadastro.secao", grupo: "Cadastro", rotulo: "Mercadológico" },
  { id: "cadastro.cliente", grupo: "Cadastro", rotulo: "Cliente" },
  { id: "cadastro.fornecedor", grupo: "Cadastro", rotulo: "Fornecedor" },
  { id: "cadastro.finalizadora", grupo: "Cadastro", rotulo: "Finalizadora - PDV" },

  // Relatorios                                          /relatorio/*
  { id: "relatorio.caixa.painel", grupo: "Relatórios", rotulo: "Caixa > Painel de Vendas" },
  { id: "relatorio.caixa.controle", grupo: "Relatórios", rotulo: "Caixa > Controle de Caixa" },
  { id: "relatorio.estoque.painel", grupo: "Relatórios", rotulo: "Estoque > Painel de Estoque" },
  { id: "relatorio.produto.listagem", grupo: "Relatórios", rotulo: "Produto > Listagem" },
  { id: "relatorio.financeiro.balancete", grupo: "Relatórios", rotulo: "Financeiro > Balancete" },

  // Financeiro                                          /financeiro/*
  { id: "financeiro.contas_pagar", grupo: "Financeiro", rotulo: "Contas a Pagar" },
  { id: "financeiro.contas_receber", grupo: "Financeiro", rotulo: "Contas a Receber" },
  { id: "financeiro.categoria", grupo: "Financeiro", rotulo: "Categoria Financeira" },
  { id: "financeiro.forma_pagamento", grupo: "Financeiro", rotulo: "Formas de Pagamento" },

  // Compra                                              /compra/*
  { id: "compra.recebimento", grupo: "Compra", rotulo: "Nota Fiscal - Entrada" },

  // Usuarios                                            /usuarios/*
  { id: "usuarios.web", grupo: "Usuários", rotulo: "Usuários WEB" },
  { id: "usuarios.funcionario", grupo: "Usuários", rotulo: "Funcionários" },

  // Carga                                               /carga/*
  { id: "carga.loja", grupo: "Carga", rotulo: "Carga para a Loja" },

  // Fiscal                                              /fiscal/*
  { id: "fiscal.tributacao", grupo: "Fiscal", rotulo: "Tributação" },
  { id: "fiscal.impfederal", grupo: "Fiscal", rotulo: "Impostos Federais" },

  // Downloads                                           /downloads
  { id: "downloads", grupo: "Downloads", rotulo: "Downloads" },
];

export function telaExiste(id: string): boolean {
  return CATALOGO_TELAS.some((tela) => tela.id === id);
}

// Descarta o que nao estiver no catalogo. Usado na gravacao dos acessos: id
// desconhecido no banco viraria permissao fantasma, que ninguem consegue ver
// nem tirar pela tela.
export function apenasTelasConhecidas(ids: string[]): string[] {
  const unicos = new Set(ids.filter((id) => telaExiste(id)));
  return Array.from(unicos);
}
