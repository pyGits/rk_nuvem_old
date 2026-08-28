import Vue from "vue";
import Vuex from "vuex";
import Application from "./modules/application";
import produto from "./modules/produto";
import loja from "./modules/loja";
import preco from "./modules/preco";
import secao from "./modules/secao";
import grupo from "./modules/grupo";
import cliente from "./modules/cliente";
import fornecedor from "./modules/fornecedor";
import usuario from "./modules/usuario";
import tributacao from "./modules/tributacao";
import funcionario from "./modules/funcionario";
import tenant from "./modules/tenant";
import finalizadora from "./modules/finalizadora";
import estoque from "./modules/estoque";
import impfederal from "./modules/impfederal";
import relatorio from "./modules/relatorio";
import admin from "./modules/admin";
import fechamento from "./modules/fechamento";
import naofiscal from "./modules/naofiscal";
import error from "./modules/error";
import download from "./modules/download";
import ibpt from "./modules/ibpt";
import erroPdv from "./modules/erroPdv";
import notificacao from "./modules/notificacao";
Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    Application,
    produto,
    loja,
    preco,
    secao,
    grupo,
    cliente,
    fornecedor,
    tributacao,
    usuario,
    funcionario,
    tenant,
    finalizadora,
    estoque,
    impfederal,
    relatorio,
    admin,
    fechamento,
    naofiscal,
    error,
    download,
    ibpt,
    erroPdv,
    notificacao,
  },
  state: {
    errorsx: {} as Record<string, string>,
  },
  mutations: {
    setErrorX(state, { field, message }: { field: string; message: string }) {
      Vue.set(state.errorsx, field, message);
    },
    clearErrorX(state, field: string) {
      Vue.delete(state.errorsx, field);
    },
    clearAllErrorsX(state) {
      state.errorsx = {};
    },
  },
  getters: {
    getErrorX: (state) => (field: string) => state.errorsx[field] || "",
    hasErrorX: (state) => (field: string) => !!state.errorsx[field],
  },
});
