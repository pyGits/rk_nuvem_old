import Vue from "vue";
import VueRouter, { RouteConfig } from "vue-router";

// Importações de componentes
import ListaProduto from "./../views/Produto/ListaProduto.vue";
import CadastroProduto from "./../views/Produto/CadastroProduto.vue";
import CadastroLoja from "./../views/Loja/CadastroLoja.vue";
import ListaLoja from "./../views/Loja/ListaLoja.vue";
import CadastroCliente from "./../views/Cliente/CadastroCliente.vue";
import ListaCliente from "./../views/Cliente/ListaCliente.vue";
import CadastroFornecedor from "./../views/Fornecedor/CadastroFornecedor.vue";
import ListaFornecedor from "./../views/Fornecedor/ListaFornecedor.vue";
import CadastroUsuario from "./../views/Usuario/WEB/CadastroUsuario.vue";
import ListaUsuario from "./../views/Usuario/WEB/ListaUsuario.vue";
import CadastroFuncionario from "./../views/Usuario/Funcionario/CadastroFuncionario.vue";
import ListaFuncionario from "./../views/Usuario/Funcionario/ListaFuncionario.vue";
import CadastroSecao from "./../views/Secao/SecaoCadastroNovo.vue";
import CadastroTributacao from "../views/Fiscal/Tributacao/CadastroTributacao.vue";
import ListaTributacao from "../views/Fiscal/Tributacao/ListarTributacao.vue";
import ListaImpFederal from "@/views/Fiscal/Federais/ListaImpFederais.vue";
import CadastroImpFderal from "@/views/Fiscal/Federais/CadastroImpFederal.vue";
import CargaLoja from "@/views/Carga/Loja.vue";
import Downloads from "@/views/Downloads/Downloads.vue";
import Inicio from "@/views/Home/Inicio.vue";
import SemAcesso from "@/views/Home/SemAcesso.vue";
import ListaFinalizadora from "@/views/Finalizadora/ListaFinalizadora.vue";
import CadastroFinalizadora from "@/views/Finalizadora/CadastroFinalizadora.vue";
import PainelVendas from "@/views/Relatorio/Caixa/Painel/Painel.vue";
import PainelControle from "@/views/Relatorio/Caixa/Controle/Painel.vue";
import PainelEstoque from "@/views/Relatorio/Estoque/Painel.vue";
import RelatorioProdutoListagem from "@/views/Relatorio/Produto/Listagem.vue";
import Login from "@/views/Deslogado/Login.vue";
import RegistrarAdmin from "@/views/Deslogado/PainelAdmin/RegistrarAdmin.vue";
import ClientesAdmin from "@/views/Deslogado/PainelAdmin/ListarClientes.vue";
import DownloadsAdmin from "@/views/Deslogado/PainelAdmin/Downloads.vue";
import IbptAdmin from "@/views/Deslogado/PainelAdmin/Ibpt.vue";
import ErrosPdvAdmin from "@/views/Deslogado/PainelAdmin/ErrosPdv.vue";
import CargasAdmin from "@/views/Deslogado/PainelAdmin/Cargas.vue";
import FeedbacksAdmin from "@/views/Deslogado/PainelAdmin/Feedbacks.vue";
import DownloadsPublico from "@/views/Deslogado/DownloadsPublico.vue";
import LoginAdmin from "@/views/Deslogado/LoginAdmin.vue";
import Configuracoes from "@/views/Configuracoes/Configuracoes.vue";
import ListarContasPagar from "@/views/Financeiro/ContasAPagar/ListarContasPagar.vue";
import EditarContasAPagar from "@/views/Financeiro/ContasAPagar/EditarContasAPagar.vue";
import RecebimentoXML from "@/views/Compra/Recebimento/RecebimentoXML.vue";

import store from "@/store";
import CadastroProdutoRefact from "@/views/ProdutoRefact/CadastroProduto.vue";
import Teste from "@/views/Teste/Teste.vue";
import ListarCategoriaFinanceira from "@/views/Financeiro/Categoria/ListarCategoriaFinanceira.vue";
import CadastrarFormaPagamento from "@/views/Financeiro/FormaPagamento/CadastrarFormaPagamento.vue";
import LiquidarContasAPagar from "@/views/Financeiro/ContasAPagar/LiquidarContasAPagar.vue";
import EditarTitulo from "@/views/Financeiro/ContasAPagar/EditarTitulo.vue";
import ListarContasReceber from "@/views/Financeiro/ContasAReceber/ListarContasReceber.vue";
import LocalizarFornecedor from "@/views/Fornecedor/LocalizarFornecedor.vue";
import ListarBalancete from "@/views/Relatorio/Financeiro/ListarBalancete.vue";
import ImportarXMLChave from "@/views/Compra/Recebimento/ImportarXMLChave.vue";
import WizardEntradaNota from "@/views/Compra/WizardEntrada/WizardEntradaNota.vue";
import ListarNota from "@/views/Compra/Recebimento/ListarNota.vue";
import InicioWizardEntradaNota from "@/views/Compra/WizardEntrada/InicioWizardEntradaNota.vue";
import AdicionarItensNotaFiscal from "@/views/Compra/Recebimento/AdicionarItensNotaFiscal.vue";

Vue.use(VueRouter);

const routes: Array<RouteConfig> = [
  { path: "/teste", component: AdicionarItensNotaFiscal, name: "teste", meta: { requiresAuth: true } },
  // Rotas Admin Deslogado
  {
    path: "/administracao",
    name: "admin-login",
    components: {
      "rotas-deslogado": LoginAdmin,
    },
  },
  {
    path: "/administracao/registrar",
    name: "admin-registrar",
    components: {
      "rotas-deslogado": RegistrarAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/clientes",
    name: "admin-clientes",
    components: {
      "rotas-deslogado": ClientesAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/downloads",
    name: "admin-downloads",
    components: {
      "rotas-deslogado": DownloadsAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/ibpt",
    name: "admin-ibpt",
    components: {
      "rotas-deslogado": IbptAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/cargas",
    name: "admin-cargas",
    components: {
      "rotas-deslogado": CargasAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/erros-pdv",
    name: "admin-erros-pdv",
    components: {
      "rotas-deslogado": ErrosPdvAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    path: "/administracao/feedbacks",
    name: "admin-feedbacks",
    components: {
      "rotas-deslogado": FeedbacksAdmin,
    },
    meta: {
      requiresAuthAdmin: true,
    },
  },
  {
    // Link publico para compartilhar (sem login) — mesma listagem de quem
    // esta logado, ver DownloadController.listarPublicados.
    path: "/downloads/publico",
    name: "downloads-publico",
    components: {
      "rotas-deslogado": DownloadsPublico,
    },
  },

  {
    path: "/",
    name: "home",
    component: Inicio,
    meta: {
      requiresAuth: true,
      tela: "inicio",
    },
  },
  {
    // Sempre acessivel a quem esta logado: e o destino de quem nao tem nenhuma
    // tela liberada.
    path: "/sem-acesso",
    name: "sem-acesso",
    component: SemAcesso,
    meta: { requiresAuth: true },
  },

  // Produto
  {
    path: "/cadastro/produto",
    name: "produto-lista",
    component: ListaProduto,
    meta: { requiresAuth: true, tela: "cadastro.produto" },
  },
  {
    path: "/cadastro/produto/:codigo",
    name: "produto-edicao",
    component: CadastroProduto,
    meta: { requiresAuth: true, tela: "cadastro.produto" },
  },

  // Loja
  {
    path: "/cadastro/loja",
    name: "loja-lista",
    component: ListaLoja,
    meta: { requiresAuth: true, tela: "cadastro.loja" },
  },
  {
    path: "/cadastro/loja/:codigo",
    name: "loja-edicao",
    component: CadastroLoja,
    meta: { requiresAuth: true, tela: "cadastro.loja" },
  },

  // Cliente
  {
    path: "/cadastro/cliente",
    name: "cliente-lista",
    component: ListaCliente,
    meta: { requiresAuth: true, tela: "cadastro.cliente" },
  },
  {
    path: "/cadastro/cliente/:codigo",
    name: "cliente-edicao",
    component: CadastroCliente,
    meta: { requiresAuth: true, tela: "cadastro.cliente" },
  },

  // Usuários WEB
  {
    path: "/usuarios/usuariosweb",
    name: "usuario-web-lista",
    component: ListaUsuario,
    meta: { requiresAuth: true, tela: "usuarios.web" },
  },
  {
    path: "/usuarios/usuariosweb/:codigo",
    name: "usuario-web-edicao",
    component: CadastroUsuario,
    meta: { requiresAuth: true, tela: "usuarios.web" },
  },

  // Funcionários
  {
    path: "/usuarios/funcionario",
    name: "funcionario-lista",
    component: ListaFuncionario,
    meta: { requiresAuth: true, tela: "usuarios.funcionario" },
  },
  {
    path: "/usuarios/funcionario/:codigo",
    name: "funcionario-edicao",
    component: CadastroFuncionario,
    meta: { requiresAuth: true, tela: "usuarios.funcionario" },
  },

  // Fornecedor
  {
    path: "/cadastro/fornecedor",
    name: "fornecedor-lista",
    component: ListaFornecedor,
    meta: { requiresAuth: true, tela: "cadastro.fornecedor" },
  },
  {
    path: "/cadastro/fornecedor/:codigo",
    name: "fornecedor-edicao",
    component: CadastroFornecedor,
    meta: { requiresAuth: true, tela: "cadastro.fornecedor" },
  },

  // Seções
  {
    path: "/cadastro/secoes",
    name: "secao-cadastro",
    component: CadastroSecao,
    meta: { requiresAuth: true, tela: "cadastro.secao" },
  },

  // Tributação
  {
    path: "/fiscal/tributacao",
    name: "tributacao-lista",
    component: ListaTributacao,
    meta: { requiresAuth: true, tela: "fiscal.tributacao" },
  },
  {
    path: "/fiscal/tributacao/:codigo",
    name: "tributacao-edicao",
    component: CadastroTributacao,
    meta: { requiresAuth: true, tela: "fiscal.tributacao" },
  },

  // Impostos Federais
  {
    path: "/fiscal/impfederal",
    name: "impfederal-lista",
    component: ListaImpFederal,
    meta: { requiresAuth: true, tela: "fiscal.impfederal" },
  },
  {
    path: "/fiscal/impfederal/:codigo",
    name: "impfederal-edicao",
    component: CadastroImpFderal,
    meta: { requiresAuth: true, tela: "fiscal.impfederal" },
  },

  // Contas a Pagar
  {
    path: "/financeiro/contas-a-pagar",
    name: "contas-pagar-lista",
    component: ListarContasPagar,
    meta: { requiresAuth: true, tela: "financeiro.contas_pagar" },
  },
  {
    path: "/financeiro/contas-a-receber",
    name: "contas-receber-lista",
    component: ListarContasReceber,
    meta: { requiresAuth: true, tela: "financeiro.contas_receber" },
  },
  {
    path: "/financeiro/categoria",
    name: "categoria-financeira-lista",
    component: ListarCategoriaFinanceira,
    meta: { requiresAuth: true, tela: "financeiro.categoria" },
  },
  {
    path: "/financeiro/forma-pagamento",
    name: "contas-forma-pagamento",
    component: CadastrarFormaPagamento,
    meta: { requiresAuth: true, tela: "financeiro.forma_pagamento" },
  },
  {
    path: "/financeiro/contas-a-pagar/:id",
    name: "contas-pagar-edicao",
    component: EditarContasAPagar,
    meta: { requiresAuth: true, tela: "financeiro.contas_pagar" },
  },

  // Recebimento Compra
  {
    path: "/compra/recebimento",
    name: "recebimento",
    component: InicioWizardEntradaNota,
    meta: { requiresAuth: true, tela: "compra.recebimento" },
  },
  {
    path: "/compra/recebimento/:chave",
    name: "recebimento_chave",
    component: WizardEntradaNota,
    meta: { requiresAuth: true, tela: "compra.recebimento" },
  },

  // Carga
  {
    path: "/carga/loja",
    name: "carga-loja",
    component: CargaLoja,
    meta: { requiresAuth: true, tela: "carga.loja" },
  },

  // Login
  {
    path: "/login",
    name: "login",
    components: {
      "rotas-deslogado": Login,
    },
  },

  // Downloads
  {
    path: "/downloads",
    name: "downloads",
    component: Downloads,
    meta: { requiresAuth: true, tela: "downloads" },
  },

  // Finalizadora
  {
    path: "/cadastro/finalizadora",
    name: "finalizadora-lista",
    component: ListaFinalizadora,
    meta: { requiresAuth: true, tela: "cadastro.finalizadora" },
  },
  {
    path: "/cadastro/finalizadora/:codigo",
    name: "finalizadora-edicao",
    component: CadastroFinalizadora,
    meta: { requiresAuth: true, tela: "cadastro.finalizadora" },
  },

  // Relatórios
  {
    path: "/relatorio/caixa/painel",
    name: "relatorio-caixa-painel",
    component: PainelVendas,
    meta: { requiresAuth: true, tela: "relatorio.caixa.painel" },
  },
  {
    path: "/relatorio/caixa/controle",
    name: "relatorio-caixa-controle",
    component: PainelControle,
    meta: { requiresAuth: true, tela: "relatorio.caixa.controle" },
  },
  {
    path: "/relatorio/estoque/painel",
    name: "relatorio-estoque-painel",
    component: PainelEstoque,
    meta: { requiresAuth: true, tela: "relatorio.estoque.painel" },
  },
  {
    path: "/relatorio/financeiro/balancete",
    name: "relatorio-financeiro-balancete",
    component: ListarBalancete,
    meta: { requiresAuth: true, tela: "relatorio.financeiro.balancete" },
  },
  {
    path: "/relatorio/produto/listagem",
    name: "relatorio-produto-listagem",
    component: RelatorioProdutoListagem,
    meta: { requiresAuth: true, tela: "relatorio.produto.listagem" },
  },

  // Configurações
  {
    path: "/configuracoes",
    name: "configuracoes",
    component: Configuracoes,
    // A tela inteira e do dono do inquilino: logo da empresa e senha do login
    // principal. As duas rotas de API por tras dela ja exigem somentePrincipal.
    meta: { requiresAuth: true, somentePrincipal: true },
  },
];

const router = new VueRouter({
  mode: "history",
  routes,
});

router.beforeEach(async (to, from, next) => {
  const isTokenExists = localStorage.getItem("access_token");
  const isTokenAdminExists = localStorage.getItem("access_token_admin");
  Vue.prototype.$http.defaults.headers.common["x-access-token"] = isTokenExists;
  Vue.prototype.$http.defaults.headers.common["x-access-token-admin"] = isTokenAdminExists;

  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth);
  const requiresAuthAdmin = to.matched.some((record) => record.meta.requiresAuthAdmin);

  // O `return` faltava: sem ele a execucao seguia para o bloco abaixo e
  // chamava next() UMA SEGUNDA VEZ na mesma navegacao. Alem do aviso do
  // vue-router, era uma das origens do "Avoided redundant navigation".
  if (requiresAuthAdmin && !isTokenAdminExists) {
    return next("/login");
  }

  if (requiresAuth && !isTokenExists) {
    return next("/login");
  }

  if (!isTokenExists) {
    store.commit("setLogado", false);
    return next();
  }

  store.commit("setLogado", true);

  // Quem esta logado e a que telas tem acesso. Carrega uma vez por sessao;
  // daqui para frente a navegacao ja decide pelo que esta no store.
  //
  // Falha de rede aqui nao pode impedir a navegacao: o backend recusa as
  // requisicoes de qualquer forma, e travar o app por causa de um /me que nao
  // respondeu seria pior do que deixar o menu incompleto por um instante.
  // O state da raiz nao e tipado com os modulos (store/index.ts declara so
  // errorsx), por isso o cast.
  if (requiresAuth && !(store.state as any).sessao.carregada) {
    try {
      await store.dispatch("carregarSessao");
    } catch (erro) {
      if ((erro as any)?.response?.status === 401) return next("/login");
    }
  }

  // Telas do dono do inquilino: o item nem aparece no menu, mas a URL digitada
  // chegaria aqui.
  if (to.meta && to.meta.somentePrincipal && !store.getters.souPrincipal) {
    store.dispatch("showToastMessage", "Somente o login principal acessa esta tela.");
    return next(from.name ? false : store.getters.rotaInicial());
  }

  // A tela pedida esta liberada para este usuario? Sem isto, digitar a URL na
  // barra de enderecos abriria uma tela que nem aparece no menu dele.
  const tela = to.meta && to.meta.tela;
  if (tela && !store.getters.podeAcessar(tela)) {
    store.dispatch("showToastMessage", "Você não tem acesso a esta tela.");
    // Vindo de outra tela, cancela a navegacao e fica onde esta; vindo de fora
    // (URL digitada, F5), manda para a primeira tela que a pessoa pode abrir.
    return next(from.name ? false : store.getters.rotaInicial());
  }

  return next();
});

export default router;
