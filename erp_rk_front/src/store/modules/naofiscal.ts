import Vue from "vue";
export default {
  state: (): {
    reforcoList: [];
    sangriaList: [];
  } => ({
    reforcoList: [],
    sangriaList: [],
  }),
  mutations: {
    setReforcoList(state: any, payload: any) {
      state.reforcoList = payload;
    },
    setSangriaList(state: any, payload: any) {
      state.sangriaList = payload;
    },
  },

  actions: {
    async getReforcos({ commit }: any, payload: any) {
      await Vue.prototype.$http
        .get("/reforcos", { params: payload })
        .then((res: any) => {
          commit("setReforcoList", res.data);
        });
    },
    async getSangrias({ commit }: any, payload: any) {
      await Vue.prototype.$http
        .get("/sangrias", { params: payload })
        .then((res: any) => {
          commit("setSangriaList", res.data);
        });
    },
  },
};
