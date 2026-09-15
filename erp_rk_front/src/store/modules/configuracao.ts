import Vue from "vue";

// Configurações do cliente (tela "Configurações do Sistema").
//
// O estado fica aqui porque duas telas leem o mesmo dado: a de Configurações,
// onde o dono liga a carga automática, e a de Carga para as Lojas, que avisa
// que ela está ligada — sem esse aviso, a carga aparecendo sozinha na tela
// parece defeito.
export interface Configuracao {
  carga_automatica: boolean;
  carga_automatica_segundos: number;
}

const PADRAO: Configuracao = {
  carga_automatica: false,
  carga_automatica_segundos: 60,
};

export default {
  state: (): { configuracao: Configuracao; configuracaoCarregada: boolean } => ({
    configuracao: { ...PADRAO },
    configuracaoCarregada: false,
  }),

  mutations: {
    setConfiguracao(state: any, payload: any) {
      state.configuracao = {
        carga_automatica: payload?.carga_automatica === true,
        carga_automatica_segundos: Number(payload?.carga_automatica_segundos) || PADRAO.carga_automatica_segundos,
      };
      state.configuracaoCarregada = true;
    },
  },

  actions: {
    async getConfiguracao({ commit }: any) {
      const res = await Vue.prototype.$http.get("/configuracoes");
      commit("setConfiguracao", res.data);
      return res.data;
    },

    async salvarConfiguracao({ commit }: any, payload: Configuracao) {
      const res = await Vue.prototype.$http.put("/configuracoes", payload);
      // O backend devolve o que realmente ficou gravado (a janela passa por uma
      // normalização de mínimo/máximo). Mostrar o valor enviado em vez do
      // gravado faria a tela mentir.
      commit("setConfiguracao", res.data);
      return res;
    },
  },
};
