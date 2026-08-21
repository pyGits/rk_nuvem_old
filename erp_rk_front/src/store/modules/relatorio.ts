import Vue from "vue";
import { getCurrentDate } from "@/utils/date";
interface Relatorio {
  dtInicio: string;
  dtFim: string;
  // 0 = todas as lojas
  loja: number;
}
const initialRelatorio: Relatorio = {
  dtInicio: getCurrentDate(),
  dtFim: getCurrentDate(),
  loja: 0,
};

export default {
  state: (): {
    filtro: Relatorio;
    relatorioPainelVendasLojas: any;
    relatorioPainelVendasProdutos: any;
    relatorioPainelVendasCaixas: any;
    relatorioPainelVendasFinalizadoras: any;
    relatorioPainelVendasSecoes: any;
    relatorioPainelVendasCupom: any;
    relatorioPainelVendasCupomAnalitico: any;
    relatorioCupomUnico: any;
  } => ({
    filtro: { ...initialRelatorio },
    relatorioPainelVendasLojas: [],
    relatorioPainelVendasProdutos: [],
    relatorioPainelVendasCaixas: [],
    relatorioPainelVendasFinalizadoras: [],
    relatorioPainelVendasSecoes: [],
    relatorioPainelVendasCupom: [],
    relatorioPainelVendasCupomAnalitico: { itens: [], formasPagamento: [] },
    relatorioCupomUnico: { itens: [], formasPagamento: [] },
  }),

  mutations: {
    setRelatorioDtInicio(state: any, payload: any) {
      state.filtro.dtInicio = payload;
    },
    setRelatorioDtFim(state: any, payload: any) {
      state.filtro.dtFim = payload;
    },
    setRelatorioLoja(state: any, payload: any) {
      state.filtro.loja = payload;
    },
    setRelatorioPainelVendasLojas(state: any, payload: any) {
      state.relatorioPainelVendasLojas = payload;
    },
    setRelatorioPainelVendasProdutos(state: any, payload: any) {
      state.relatorioPainelVendasProdutos = payload;
    },
    setRelatorioPainelVendasCaixas(state: any, payload: any) {
      state.relatorioPainelVendasCaixas = payload;
    },
    setRelatorioPainelVendasFinalizadoras(state: any, payload: any) {
      state.relatorioPainelVendasFinalizadoras = payload;
    },
    setRelatorioPainelVendasSecoes(state: any, payload: any) {
      state.relatorioPainelVendasSecoes = payload;
    },
    setRelatorioPainelVendasCupom(state: any, payload: any) {
      state.relatorioPainelVendasCupom = payload;
    },
    setRelatorioPainelVendasCupomAnalitico(state: any, payload: any) {
      state.relatorioPainelVendasCupomAnalitico = payload;
    },
    setRelatorioCupomUnico(state: any, payload: any) {
      state.relatorioCupomUnico = payload;
    },
    resetRelatorio(state: any) {
      state.relatorioPainelVendasLojas = [];
      state.relatorioPainelVendasProdutos = [];
      state.relatorioPainelVendasCaixas = [];
      state.relatorioPainelVendasFinalizadoras = [];
      state.relatorioPainelVendasSecoes = [];
      state.relatorioPainelVendasCupom = [];
      state.relatorioPainelVendasCupomAnalitico = { itens: [], formasPagamento: [] };
      state.relatorioCupomUnico = { itens: [], formasPagamento: [] };
    },
  },
  actions: {
    async getPainelVendasProdutos({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/produtos", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasProdutos", res.data);
        });
    },
    async getPainelVendasLojas({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/lojas", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasLojas", res.data);
        });
    },
    async getPainelVendasCaixas({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/caixas", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCaixas", res.data);
        });
    },
    async getPainelVendasFinalizadoras({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/finalizadoras", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasFinalizadoras", res.data);
        });
    },
    async getPainelVendasSecoes({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/secoes", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasSecoes", res.data);
        });
    },

    async getPainelVendasCupom({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/cupom", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCupom", res.data);
        });
    },
    async getPainelVendasCupomAnalitico({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/cupom/analitico", {
          params: {
            dtInicio: state.filtro.dtInicio,
            dtFim: state.filtro.dtFim,
            loja: state.filtro.loja,
          },
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCupomAnalitico", res.data);
        });
    },
    async getPainelEstoqueSaldo({ commit }: any, parametros: any) {
      return await Vue.prototype.$http.get("/relatorios/estoque/saldo", {
        params: parametros,
      });
    },
    async getRelatorioProdutoListagem({ commit }: any, parametros: any) {
      return await Vue.prototype.$http.get("/relatorios/produtos/listagem", {
        params: parametros,
      });
    },
    async getCupomUnico({ commit }: any, cupom: any) {
      return await Vue.prototype.$http
        .get("/relatorios/cupom", {
          params: cupom,
        })
        .then((res: any) => {
          commit("setRelatorioCupomUnico", res.data);
        });
    },
  },
};
