import Vue from "vue";

export default {
  state: (): { notificacaoList: any[] } => ({
    notificacaoList: [],
  }),

  mutations: {
    setNotificacaoList(state: any, payload: any) {
      state.notificacaoList = payload;
    },
  },

  actions: {
    // Alertas reais do negócio do tenant (contas a pagar vencendo/vencidas,
    // estoque baixo/negativo) — ver NotificacaoController no backend.
    async getNotificacoes({ commit }: any) {
      await Vue.prototype.$http
        .get("/notificacoes")
        .then((res: any) => {
          commit("setNotificacaoList", res.data);
        })
        .catch(() => {
          // Sininho sem notificação não deve travar o login nem poluir a
          // tela com toast de erro.
        });
    },
  },
};
