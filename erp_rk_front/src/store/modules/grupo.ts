import Vue from "vue";
interface Grupo {
  codigo: string;
  secao: number;
  nome: string;
  margem: number;
}

const initialGrupo: Grupo = {
  codigo: "0",
  secao: 0,
  nome: "",
  margem: 0,
};

export default {
  state: (): { grupo: Grupo; grupoList: Grupo[] } => ({
    grupo: { ...initialGrupo },
    grupoList: [],
  }),

  mutations: {
    setGrupoList(state: any, payload: any) {
      state.grupoList = payload;
    },
    setGrupo(state: any, payload: any) {
      Object.assign(state.grupo, payload);
    },
    setGrupoMargem(state: any, payload: any) {
      state.grupo.margem = payload;
    },
    setGrupoCodigo(state: any, payload: string) {
      state.grupo.codigo = payload;
      state.grupo.codigo = payload.replace(/[^0-9]/g, "");
      state.grupo.codigo = state.grupo.codigo.trim();
      state.grupo.codigo = state.grupo.codigo.substring(0, 3);
    },
    setGrupoNome(state: any, payload: string) {
      state.grupo.nome = payload;
      state.grupo.nome = payload.toUpperCase();
      state.grupo.nome = state.grupo.nome.substring(0, 50);
    },
    setGrupoSecao(state: any, payload: number) {
      state.grupo.secao = payload;
    },
    resetGrupo(state: any) {
      Object.assign(state.grupo, initialGrupo);
    },
    resetGrupoList(state: any) {
      state.grupoList = [];
    },
  },

  actions: {
    async deletarGrupo({ dispatch }: any, grupo: any) {
      await Vue.prototype.$http
        .delete("/secoes/" + grupo.codigo_secao + "/grupos/" + grupo.codigo)
        .then((res: any) => {
          dispatch("showToastMessage", res.data.message);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },
    async getGrupos({ commit, dispatch }: any, secao: string) {
      await Vue.prototype.$http
        .get("/secoes/" + secao + "/grupos")
        .then((res: any) => {
          commit("setGrupoList", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },
    async getGrupo({ commit, state, dispatch }: any, codigo: string) {
      await Vue.prototype.$http
        .get("/secoes/" + state.grupo.secao + "/grupos/" + codigo)
        .then((res: any) => {
          commit("setGrupo", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });
    },

    async gravarGrupo({ state, commit, dispatch }: any, payload: string) {
      if (payload === "INSERT") {
        await Vue.prototype.$http
          .post("/secoes/" + state.grupo.secao + "/grupos", state.grupo)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      } else if (payload === "UPDATE") {
        await Vue.prototype.$http
          .put(
            "/secoes/" + state.grupo.secao + "/grupos/" + state.grupo.codigo,
            state.grupo
          )
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
            return err;
          });
      }
    },
  },
};
