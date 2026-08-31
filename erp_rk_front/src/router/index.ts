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
    },
  },

  // Produto
  {
    path: "/cadastro/produto",
    name: "produto-lista",
    component: ListaProduto,
    meta: { requiresAuth: true },
  },
  {
    path: "/cadastro/produto/:codigo",
    name: "produto-edicao",
    component: CadastroProduto,
    meta: { requiresAuth: true },
  },

  // Loja
  {
    path: "/cadastro/loja",
    name: "loja-lista",
    component: ListaLoja,
    meta: { requiresAuth: true },
  },
  {
    path: "/cadastro/loja/:codigo",
    name: "loja-edicao",
    component: CadastroLoja,
    meta: { requiresAuth: true },
  },

  // Cliente
  {
    path: "/cadastro/cliente",
    name: "cliente-lista",
    component: ListaCliente,
    meta: { requiresAuth: true },
  },
  {
    path: "/cadastro/cliente/:codigo",
    name: "cliente-edicao",
    component: CadastroCliente,
    meta: { requiresAuth: true },
  },

  // Usuários WEB
  {
    path: "/usuarios/usuariosweb",
    name: "usuario-web-lista",
    component: ListaUsuario,
    meta: { requiresAuth: true },
  },
  {
    path: "/usuarios/usuariosweb/:codigo",
    name: "usuario-web-edicao",
    component: CadastroUsuario,
    meta: { requiresAuth: true },
  },

  // Funcionários
  {
    path: "/usuarios/funcionario",
    name: "funcionario-lista",
    component: ListaFuncionario,
    meta: { requiresAuth: true },
  },
  {
    path: "/usuarios/funcionario/:codigo",
    name: "funcionario-edicao",
    component: CadastroFuncionario,
    meta: { requiresAuth: true },
  },

  // Fornecedor
  {
    path: "/cadastro/fornecedor",
    name: "fornecedor-lista",
    component: ListaFornecedor,
    meta: { requiresAuth: true },
  },
  {
    path: "/cadastro/fornecedor/:codigo",
    name: "fornecedor-edicao",
    component: CadastroFornecedor,
    meta: { requiresAuth: true },
  },

  // Seções
  {
    path: "/cadastro/secoes",
    name: "secao-cadastro",
    component: CadastroSecao,
    meta: { requiresAuth: true },
  },

  // Tributação
  {
    path: "/fiscal/tributacao",
    name: "tributacao-lista",
    component: ListaTributacao,
    meta: { requiresAuth: true },
  },
  {
    path: "/fiscal/tributacao/:codigo",
    name: "tributacao-edicao",
    component: CadastroTributacao,
    meta: { requiresAuth: true },
  },

  // Impostos Federais
  {
    path: "/fiscal/impfederal",
    name: "impfederal-lista",
    component: ListaImpFederal,
    meta: { requiresAuth: true },
  },
  {
    path: "/fiscal/impfederal/:codigo",
    name: "impfederal-edicao",
    component: CadastroImpFderal,
    meta: { requiresAuth: true },
  },

  // Contas a Pagar
  {
    path: "/financeiro/contas-a-pagar",
    name: "contas-pagar-lista",
    component: ListarContasPagar,
    meta: { requiresAuth: true },
  },
  {
    path: "/financeiro/contas-a-receber",
    name: "contas-receber-lista",
    component: ListarContasReceber,
    meta: { requiresAuth: true },
  },
  {
    path: "/financeiro/categoria",
    name: "contas-pagar-lista",
    component: ListarCategoriaFinanceira,
    meta: { requiresAuth: true },
  },
  {
    path: "/financeiro/forma-pagamento",
    name: "contas-forma-pagamento",
    component: CadastrarFormaPagamento,
    meta: { requiresAuth: true },
  },
  {
    path: "/financeiro/contas-a-pagar/:id",
    name: "contas-pagar-edicao",
    component: EditarContasAPagar,
    meta: { requiresAuth: true },
  },

  // Recebimento Compra
  {
    path: "/compra/recebimento",
    name: "recebimento",
    component: InicioWizardEntradaNota,
    meta: { requiresAuth: true },
  },
  {
    path: "/compra/recebimento/:chave",
    name: "recebimento_chave",
    component: WizardEntradaNota,
    meta: { requiresAuth: true },
  },

  // Carga
  {
    path: "/carga/loja",
    name: "carga-loja",
    component: CargaLoja,
    meta: { requiresAuth: true },
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
    meta: { requiresAuth: true },
  },

  // Finalizadora
  {
    path: "/cadastro/finalizadora",
    name: "finalizadora-lista",
    component: ListaFinalizadora,
    meta: { requiresAuth: true },
  },
  {
    path: "/cadastro/finalizadora/:codigo",
    name: "finalizadora-edicao",
    component: CadastroFinalizadora,
    meta: { requiresAuth: true },
  },

  // Relatórios
  {
    path: "/relatorio/caixa/painel",
    name: "relatorio-caixa-painel",
    component: PainelVendas,
    meta: { requiresAuth: true },
  },
  {
    path: "/relatorio/caixa/controle",
    name: "relatorio-caixa-controle",
    component: PainelControle,
    meta: { requiresAuth: true },
  },
  {
    path: "/relatorio/estoque/painel",
    name: "relatorio-estoque-painel",
    component: PainelEstoque,
    meta: { requiresAuth: true },
  },
  {
    path: "/relatorio/financeiro/balancete",
    name: "relatorio-financeiro-balancete",
    component: ListarBalancete,
    meta: { requiresAuth: true },
  },
  {
    path: "/relatorio/produto/listagem",
    name: "relatorio-produto-listagem",
    component: RelatorioProdutoListagem,
    meta: { requiresAuth: true },
  },

  // Configurações
  {
    path: "/configuracoes",
    name: "configuracoes",
    component: Configuracoes,
    meta: { requiresAuth: true },
  },
];

const router = new VueRouter({
  mode: "history",
  routes,
});

router.beforeEach((to, from, next) => {
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
    next("/login");
  } else if (isTokenExists) {
    store.commit("setLogado", true);
    next();
  } else {
    store.commit("setLogado", false);
    next();
  }
});

export default router;
