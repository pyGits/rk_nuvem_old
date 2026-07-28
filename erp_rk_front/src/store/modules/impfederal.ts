import Vue from "vue";

interface ImpFederal {
  codigo: string;
  nome: string;
  cstEntrada: string;
  cstSaida: string;
  pis: number;
  cofins: number;
}

const initialImpFederal: ImpFederal = {
  codigo: "",
  nome: "",
  cstEntrada: "",
  cstSaida: "",
  pis: 0,
  cofins: 0,
};
export default {
  state: (): {
    impfederal: ImpFederal;
    impfederalList: ImpFederal[];
  } => ({
    impfederal: Object.assign({}, initialImpFederal),
    impfederalList: [],
  }),

  mutations: {
    setImpFederal(state: any, payload: any) {
      Object.assign(state.impfederal, payload);
    },
    setImpFederalList(state: any, payload: any) {
      state.impfederalList = payload;
    },
    setImpFederalCodigo(state: any, payload: string) {
      state.impfederal.codigo = payload;
    },
    setImpFederalNome(state: any, payload: string) {
      state.impfederal.nome = payload;
      state.impfederal.nome = payload.toUpperCase();
      state.impfederal.nome = state.impfederal.nome.substring(0, 80);
    },
    setImpFederalCSTEntrada(state: any, payload: string) {
      state.impfederal.cstEntrada = payload;
      state.impfederal.cstEntrada = payload.toUpperCase();
      state.impfederal.cstEntrada = state.impfederal.cstEntrada.substring(0, 3);
    },
    setImpFederalCSTSaida(state: any, payload: string) {
      state.impfederal.cstSaida = payload;
      state.impfederal.cstSaida = payload.toUpperCase();
      state.impfederal.cstSaida = state.impfederal.cstSaida.substring(0, 3);
    },
    setImpFederalPis(state: any, payload: string) {
      state.impfederal.pis = payload;
    },
    setImpFederalCofins(state: any, payload: string) {
      state.impfederal.cofins = payload;
    },
    resetImpFederal(state: any) {
      state.impfederal = Object.assign({}, initialImpFederal);
    },
  },

  actions: {
    async getImpFederal({ commit }: any, payload: string) {
      await Vue.prototype.$http
        .get(`/impfederal/${payload}`)
        .then((res: any) => {
          commit("setImpFederal", res.data ?? initialImpFederal);
        });
    },

    async gravarImpFederal({ state, dispatch, commit }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/impfederal", state.impfederal)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetImpFederal");
          });
      } else {
        await Vue.prototype.$http
          .put("/impfederal/" + payload, state.impfederal)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetImpFederal");
          });
      }
    },

    async getImpFederais({ commit }: any) {
      await Vue.prototype.$http.get("/impfederal").then((res: any) => {
        commit("setImpFederalList", res.data);
      });
    },
  },
};
