import Vue from "vue";
interface Finalizadora {
  codigo: string;
  nome: string;
  especie: string;
  tipo: string;
  utiliza99: string;
}

const initialFinalizadora: Finalizadora = {
  codigo: "000",
  nome: "",
  especie: "1",
  tipo: "N",
  utiliza99: "0",
};

export default {
  state: (): {
    finalizadora: Finalizadora;
    finalizadoraList: Finalizadora[];
  } => ({
    finalizadora: { ...initialFinalizadora },
    finalizadoraList: [],
  }),

  mutations: {
    setFinalizadoraCodigo(state: any, payload: string) {
      state.finalizadora.codigo = payload;
      state.finalizadora.codigo = payload.replace(/[^0-9]/g, "");
      state.finalizadora.codigo = state.finalizadora.codigo.trim();
      state.finalizadora.codigo = state.finalizadora.codigo.substring(0, 3);
    },
    setFinalizadoraNome(state: any, payload: string) {
      state.finalizadora.nome = payload;
      state.finalizadora.nome = payload.toUpperCase();
      state.finalizadora.nome = state.finalizadora.nome.substring(0, 20);
    },

    setFinalizadoraEspecie(state: any, payload: string) {
      state.finalizadora.especie = payload;
    },

    setFinalizadoraTipo(state: any, payload: string) {
      state.finalizadora.tipo = payload;
    },

    setFinalizadoraUtiliza99(state: any, payload: string) {
      state.finalizadora.utiliza99 = payload;
    },

    setFinalizadora(state: any, payload: any) {
      Object.assign(state.finalizadora, initialFinalizadora);
      Object.assign(state.finalizadora, payload);
    },
    resetFinalizadora(state: any) {
      Object.assign(state.finalizadora, initialFinalizadora);
    },
    resetFinalizadoraList(state: any) {
      state.finalizadoraList = [];
    },
    setFinalizadoraList(state: any, payload: any) {
      state.finalizadoraList = payload;
    },
  },

  actions: {
    async getFinalizadora({ commit, dispatch }: any, codigo: string) {
      await Vue.prototype.$http
        .get("/finalizadoras/" + codigo)
        .then((res: any) => {
          commit("setFinalizadora", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },

    async gravarFinalizadora({ state, dispatch }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/finalizadoras", state.finalizadora)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      } else {
        await Vue.prototype.$http
          .put("/finalizadoras", state.finalizadora)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      }
    },

    async getFinalizadoras({ commit, dispatch }: any) {
      commit("resetFinalizadoraList");
      await Vue.prototype.$http
        .get("/finalizadoras")
        .then((res: any) => {
          commit("setFinalizadoraList", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },
  },
};
