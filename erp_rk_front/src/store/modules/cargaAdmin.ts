import Vue from "vue";

// Carga para as lojas pelo painel administrativo. E a mesma fila do fluxo do
// cliente (cargaList do CargaController), so que enxergando as lojas de todos
// os clientes de uma vez. O modulo do cliente (loja.ts) continua intocado.
export default {
  state: (): { cargaAdminLojas: any[] } => ({
    cargaAdminLojas: [],
  }),

  mutations: {
    setCargaAdminLojas(state: any, payload: any) {
      state.cargaAdminLojas = payload || [];
    },
    // O status vem de uma rota separada e leve, para o polling de 2s nao bater
    // no banco. Vue.set porque a barra precisa reagir a troca de estado.
    setCargaAdminStatus(state: any, payload: any) {
      const cargas = Array.isArray(payload) ? payload : [];

      state.cargaAdminLojas.forEach((loja: any) => {
        const carga = cargas.find((item: any) => item.chave === loja.chave);

        Vue.set(loja, "cargaStatus", carga ? carga.cargaStatus : "CONCLUIDA");
        Vue.set(loja, "cargaTipo", carga ? carga.cargaTipo : null);
        Vue.set(loja, "cargaEtapa", carga ? carga.cargaEtapa : null);
        Vue.set(loja, "cargaIndice", carga ? carga.cargaIndice : null);
        Vue.set(loja, "cargaTotal", carga ? carga.cargaTotal : null);
        Vue.set(loja, "cargaPercentual", carga ? carga.cargaPercentual : null);
      });
    },
  },

  actions: {
    async getCargaAdminLojas({ commit }: any) {
      const res = await Vue.prototype.$http.get("/admin/carga/lojas");
      commit("setCargaAdminLojas", res.data || []);
      return res.data;
    },

    async getCargaAdminStatus({ commit }: any) {
      const res = await Vue.prototype.$http.get("/admin/carga/status");
      commit("setCargaAdminStatus", res.data || []);
      return res.data;
    },

    // payload: { carga: "COMPLETA" | "ALTERADOS", todas?: boolean, lojas?: [] }
    async enviaCargaAdmin(_: any, payload: any) {
      const res = await Vue.prototype.$http.post("/admin/carga", payload);
      return res.data;
    },
  },
};
