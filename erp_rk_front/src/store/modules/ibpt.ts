import Vue from "vue";

// Tabela IBPT (NCM + aliquotas da Lei da Transparencia). E global: sobe uma vez
// pelo painel administrativo e vale para todos os clientes.
export default {
  state: (): { ibptSituacao: any; ibptProdutosSemNcm: any } => ({
    ibptSituacao: null,
    ibptProdutosSemNcm: { tabelaCarregada: false, produtos: [], totais: { produtos: 0, clientes: 0 }, message: "" },
  }),

  mutations: {
    setIbptSituacao(state: any, payload: any) {
      state.ibptSituacao = payload;
    },
    setIbptProdutosSemNcm(state: any, payload: any) {
      state.ibptProdutosSemNcm = payload;
    },
  },

  actions: {
    async getIbptSituacao({ commit }: any) {
      const res = await Vue.prototype.$http.get("/admin/ibpt");
      commit("setIbptSituacao", res.data);
      return res.data;
    },

    // O arquivo do IBPT tem ~2 MB e a carga substitui 12 mil linhas, entao vale
    // acompanhar o progresso do envio em vez de deixar a tela parada.
    async publicarIbpt({ dispatch }: any, payload: any) {
      const form = new FormData();
      form.append("arquivo", payload.arquivo);

      const res = await Vue.prototype.$http.post("/admin/ibpt", form, {
        headers: { "Content-Type": "multipart/form-data" },
        onUploadProgress: payload.onProgress,
      });

      await dispatch("getIbptSituacao");
      return res.data;
    },

    // Grava os NCM escolhidos. A lista vai explicita: e alteracao de dado
    // fiscal de cliente, entao o servidor aplica o que o operador viu.
    async normalizarNcm(_: any, produtos: any[]) {
      const res = await Vue.prototype.$http.post("/admin/ibpt/normalizar", { produtos });
      return res.data;
    },

    async contarZeroAEsquerda(_: any, filtro: any = {}) {
      const res = await Vue.prototype.$http.get("/admin/ibpt/zero-esquerda", { params: filtro });
      return res.data;
    },

    async corrigirZeroAEsquerda(_: any, filtro: any = {}) {
      const res = await Vue.prototype.$http.post("/admin/ibpt/zero-esquerda", filtro);
      return res.data;
    },

    // Consulta a IA e grava. Depois disso, a conferência já traz a resposta.
    async buscarNcmComIA(_: any, payload: any) {
      const res = await Vue.prototype.$http.post("/admin/ibpt/buscar-ia", {
        produtos: payload.produtos,
        reconsultarVazios: payload.reconsultarVazios ? "1" : "0",
      });
      return res.data;
    },

    // Mutirão: começa no servidor e continua com a tela fechada.
    async iniciarMutiraoIA(_: any, payload: any = {}) {
      const res = await Vue.prototype.$http.post("/admin/ibpt/mutirao-ia", { reconsultarVazios: payload.reconsultarVazios ? "1" : "0" });
      return res.data;
    },
    async getMutiraoIA() {
      const res = await Vue.prototype.$http.get("/admin/ibpt/mutirao-ia");
      return res.data;
    },
    async pararMutiraoIA() {
      const res = await Vue.prototype.$http.delete("/admin/ibpt/mutirao-ia");
      return res.data;
    },

    // Busca pela SEFAZ: consulta o Cadastro Centralizado de GTIN pelo código de
    // barras. Também roda no servidor, com a tela fechada.
    async iniciarSefazGtin() {
      const res = await Vue.prototype.$http.post("/admin/ibpt/sefaz");
      return res.data;
    },
    async getSefazGtin() {
      const res = await Vue.prototype.$http.get("/admin/ibpt/sefaz");
      return res.data;
    },
    async pararSefazGtin() {
      const res = await Vue.prototype.$http.delete("/admin/ibpt/sefaz");
      return res.data;
    },

    async getIbptProdutosSemNcm({ commit }: any, filtro: any = {}) {
      const res = await Vue.prototype.$http.get("/admin/ibpt/produtos-sem-ncm", { params: filtro });
      commit("setIbptProdutosSemNcm", res.data);
      return res.data;
    },
  },
};
