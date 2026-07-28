import Vue from "vue";
export default {
  state: (): {
    fechamento: any;
    fechamentoList: [];
    fechamentoFormaList: [];
  } => ({
    fechamento: {},
    fechamentoList: [],
    fechamentoFormaList: [],
  }),
  mutations: {
    setFechamento(state: any, payload: any) {
      state.fechamento = payload;
    },
    setFechamentoList(state: any, payload: any) {
      state.fechamentoList = payload;
    },
    setFechamentoFormaList(state: any, payload: any) {
      state.fechamentoFormaList = payload;
    },
  },

  actions: {
    async getFechamentoFormas({ commit }: any, payload: any) {
      await Vue.prototype.$http
        .get("/fechamento-formas", { params: payload })
        .then((res: any) => {
          commit("setFechamentoFormaList", res.data);
        });
    },
    async getFechamentos({ commit }: any, payload: any) {
      await Vue.prototype.$http
        .get("/fechamento", { params: payload })
        .then((res: any) => {
          commit("setFechamentoList", res.data);
        });
    },
  },
};
