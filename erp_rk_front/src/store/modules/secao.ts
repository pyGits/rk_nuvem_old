import Vue from "vue";
interface Secao {
  codigo: string;
  nome: string;
  margem: number;
}

const initialSecao: Secao = {
  codigo: "0",
  nome: "",
  margem: 0,
};

export default {
  state: (): { secao: Secao; secaoList: Secao[] } => ({
    secao: { ...initialSecao },
    secaoList: [],
  }),

  mutations: {
    setSecaoCodigo(state: any, payload: string) {
      state.secao.codigo = payload;
      state.secao.codigo = payload.replace(/[^0-9]/g, "");
      state.secao.codigo = state.secao.codigo.trim();
      state.secao.codigo = state.secao.codigo.substring(0, 3);
    },
    setSecaoNome(state: any, payload: string) {
      state.secao.nome = payload;
      state.secao.nome = payload.toUpperCase();
      state.secao.nome = state.secao.nome.substring(0, 50);
    },
    setSecaoMargem(state: any, payload: number) {
      state.secao.margem = payload;
    },
    setSecao(state: any, payload: any) {
      Object.assign(state.secao, payload);
    },
    resetSecao(state: any) {
      Object.assign(state.secao, initialSecao);
    },
    resetSecaoList(state: any) {
      state.secaoList = [];
    },
    setSecaoList(state: any, payload: any) {
      state.secaoList = payload;
    },
  },

  actions: {
    async getSecao({ commit, dispatch }: any, codigo: string) {
      Vue.prototype.$http
        .get("/secoes/" + codigo)
        .then((res: any) => {
          commit("setSecao", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },

    async gravarSecao({ state, dispatch, commit }: any, payload: string) {
      if (payload === "INSERT") {
        await Vue.prototype.$http
          .post("/secoes", state.secao)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      } else if (payload === "UPDATE") {
        await Vue.prototype.$http
          .put("/secoes", state.secao)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      }
    },

    async getSecoes({ commit, dispatch }: any) {
      commit("resetSecaoList");
      await Vue.prototype.$http
        .get("/secoes")
        .then((res: any) => {
          commit("setSecaoList", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },

    async deletarSecao({ dispatch }: any, secao: any) {
      await Vue.prototype.$http
        .delete("/secoes/" + secao.codigo)
        .then((res: any) => {
          dispatch("showToastMessage", res.data.message);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },
  },
};
