import Vue from "vue";

export default {
  state: (): { downloadList: any[] } => ({
    downloadList: [],
  }),

  mutations: {
    setDownloadList(state: any, payload: any) {
      state.downloadList = payload;
    },
  },

  actions: {
    // Lista vista pelo cliente logado
    async getDownloads({ commit, dispatch }: any) {
      await Vue.prototype.$http
        .get("/downloads")
        .then((res: any) => {
          commit("setDownloadList", res.data);
        })
        .catch(() => {
          dispatch("showToastMessage", "Não foi possível carregar os downloads.");
        });
    },

    // O arquivo e baixado pelo proprio navegador: o backend devolve um token
    // curto porque nao da para mandar o header de autenticacao num download.
    async baixarDownload({ dispatch }: any, payload: any) {
      return await Vue.prototype.$http
        .post(`/downloads/${payload.id}/link`)
        .then((res: any) => {
          const baseURL = Vue.prototype.$http.defaults.baseURL || "/api";
          window.location.href = `${baseURL}/downloads/arquivo/${res.data.token}`;
        })
        .catch(() => {
          dispatch("showToastMessage", "Não foi possível iniciar o download.");
        });
    },

    // ---- Painel administrativo ----
    async getDownloadsAdmin({ commit }: any) {
      await Vue.prototype.$http.get("/admin/downloads").then((res: any) => {
        commit("setDownloadList", res.data);
      });
    },

    async publicarDownload(context: any, payload: any) {
      const form = new FormData();
      form.append("titulo", payload.titulo);
      form.append("descricao", payload.descricao || "");
      form.append("versao", payload.versao || "");
      form.append("arquivo", payload.arquivo);
      if (payload.id) form.append("id", payload.id);

      return await Vue.prototype.$http.post("/admin/downloads", form, {
        headers: { "Content-Type": "multipart/form-data" },
        // Instalador e arquivo grande: garante que nenhum timeout derrube o
        // envio no meio, independente do padrao configurado no axios.
        timeout: 0,
        onUploadProgress: payload.onProgress,
      });
    },

    async atualizarDownload(context: any, payload: any) {
      return await Vue.prototype.$http.put(`/admin/downloads/${payload.id}`, {
        titulo: payload.titulo,
        descricao: payload.descricao,
        versao: payload.versao,
        ativo: payload.ativo,
      });
    },

    async removerDownload(context: any, payload: any) {
      return await Vue.prototype.$http.delete(`/admin/downloads/${payload.id}`);
    },
  },
};
