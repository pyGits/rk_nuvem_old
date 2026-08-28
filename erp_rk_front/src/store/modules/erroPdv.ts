import Vue from "vue";

// Erros ocorridos nos PDVs dos clientes, subidos pelo Sync_NUVEM.
export default {
  state: (): { erroPdvList: any[] } => ({
    erroPdvList: [],
  }),

  mutations: {
    setErroPdvList(state: any, payload: any) {
      state.erroPdvList = payload;
    },
  },

  actions: {
    async getErrosPdv({ commit }: any, filtro: any = {}) {
      const res = await Vue.prototype.$http.get("/admin/erros-pdv", { params: filtro });
      commit("setErroPdvList", res.data || []);
      return res.data;
    },
  },
};
