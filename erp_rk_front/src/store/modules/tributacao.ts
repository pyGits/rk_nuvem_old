import Vue from "vue";
import { maskCEST, maskNCM } from "@/utils/masks";

interface Tributacao {
  codigo: string;
  nome: string;
  cst: string;
  cfop: string;
  csosn: string;
  icms: number;
}
interface NCM {
  codigo: string;
  nome: string;
  ncmList: [];
}
interface CEST {
  codigo: string;
  nome: string;
  cestList: [];
}

const initialTributacao: Tributacao = {
  codigo: "000",
  nome: "",
  cst: "",
  cfop: "",
  csosn: "",
  icms: 0,
};
const initialNCM: NCM = {
  codigo: "00000000",
  nome: "",
  ncmList: [],
};
const initialCest: CEST = {
  codigo: "0000000",
  nome: "",
  cestList: [],
};

export default {
  state: (): {
    tributacao: Tributacao;
    ncm: NCM;
    cest: CEST;
    tributacaoList: Tributacao[];
  } => ({
    tributacao: Object.assign({}, initialTributacao),
    ncm: Object.assign({}, initialNCM), // cria uma cópia do objeto initialNCM
    cest: Object.assign({}, initialCest), // cria uma cópia do objeto initialNCM
    tributacaoList: [],
  }),

  mutations: {
    setTributacao(state: any, payload: any) {
      Object.assign(state.tributacao, payload);
    },
    setTributacaoList(state: any, payload: any) {
      state.tributacaoList = payload;
    },
    setTributacaoCodigo(state: any, payload: string) {
      state.tributacao.codigo = payload;
    },
    setTributacaoNome(state: any, payload: string) {
      state.tributacao.nome = payload;
      state.tributacao.nome = payload.toUpperCase();
      state.tributacao.nome = state.tributacao.nome.substring(0, 80);
    },
    setTributacaoCST(state: any, payload: string) {
      state.tributacao.cst = payload;
    },
    setTributacaoCFOP(state: any, payload: string) {
      state.tributacao.cfop = payload;
    },
    setTributacaoCSOSN(state: any, payload: string) {
      state.tributacao.csosn = payload;
    },
    setTributacaoICMS(state: any, payload: number) {
      state.tributacao.icms = payload;
    },
    // --------------------------------

    setTributacaoNCM(state: any, payload: any) {
      state.ncm.codigo = maskNCM(payload.Codigo);
      state.ncm.nome = payload.Descricao;
    },
    setTributacaoCEST(state: any, payload: any) {
      state.cest.codigo = maskCEST(payload.CEST.toString());
      state.cest.nome = payload.DESCRICAO;
    },

    setNCMList(state: any, payload: any) {
      state.ncm.ncmList = payload;
    },
    setCESTList(state: any, payload: any) {
      state.cest.cestList = payload;
    },
    resetTributacao(state: any) {
      state.tributacao = Object.assign({}, initialTributacao);
      state.ncm = Object.assign({}, initialNCM); // cria uma nova cópia do objeto initialNCM
    },
  },

  actions: {
    async getNCM({ state, commit }: any, payload: string) {
      payload = maskNCM(payload);
      if (state.ncm.ncmList.length === 0) {
        await import("@/utils/NCM.json").then((module) => {
          commit("setNCMList", module.default.Nomenclaturas);
        });
      }
      const ncm = state.ncm.ncmList.find(
        (ncm: any) => ncm.Codigo.replace(/\./g, "").padStart(8, "0") === payload
      ) || { Codigo: "00000000", Descricao: "" };

      commit("setTributacaoNCM", ncm);
    },
    async getCEST({ state, commit }: any, payload: string) {
      commit("setCESTList", []);
      await import("@/utils/CEST.json").then((module) => {
        commit("setCESTList", module.default);
      });
      const cest = state.cest.cestList.find((element: any) => {
        const cestString = element.CEST.toString().padStart(7, "0");
        const ncmString = element.NCM.toString().padStart(8, "0");
        return cestString === payload && state.ncm.codigo === ncmString;
      });
      commit(
        "setTributacaoCEST",
        cest || {
          CEST: "0000000",
          NCM: "00000000",
          DESCRICAO: "",
        }
      );
    },

    async getCESTList({ state, commit }: any) {
      commit("setCESTList", []);
      await import("@/utils/CEST.json").then((module) => {
        commit("setCESTList", module.default);
      });

      const filteredCestList = state.cest.cestList.filter((element: any) => {
        const ncmString = element.NCM.toString().padStart(8, "0");
        return ncmString === state.ncm.codigo;
      });
      commit("setCESTList", filteredCestList);
    },

    async getTributacao({ commit }: any, payload: string) {
      await Vue.prototype.$http
        .get(`/tributacao/${payload}`)
        .then((res: any) => {
          commit("setTributacao", res.data ?? initialTributacao);
        });
    },

    async gravarTributacao({ state, dispatch, commit }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/tributacao", state.tributacao)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetTributacao");
          });
      } else {
        await Vue.prototype.$http
          .put("/tributacao/" + payload, state.tributacao)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetTributacao");
          });
      }
    },

    async getTributacoes({ commit }: any) {
      await Vue.prototype.$http.get("/tributacao").then((res: any) => {
        commit("setTributacaoList", res.data);
      });
    },
  },
};
