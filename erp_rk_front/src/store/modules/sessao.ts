import Vue from "vue";

// Quem esta logado e a que telas essa pessoa tem acesso.
//
// Antes o front so conhecia a EMPRESA: o token carregava apenas o tenant_id e o
// Header mostrava o nome da empresa como se fosse o do usuario. Sem saber quem
// logou nao havia como esconder nada de ninguem.
//
// A lista de telas vem do backend a cada carga da sessao (GET /me) - nunca de
// uma copia aqui no front. Se esta lista e o catalogo do backend divergissem, o
// defeito apareceria como "o dono marcou o acesso e o usuario continua sem ver
// a tela", que e o mais caro de diagnosticar desta feature inteira.

interface UsuarioSessao {
  codigo: string;
  user: string;
  nome: string;
}

interface Tela {
  id: string;
  grupo: string;
  rotulo: string;
}

interface EstadoSessao {
  carregada: boolean;
  principal: boolean;
  acessoTotal: boolean;
  usuario: UsuarioSessao | null;
  telasLiberadas: string[];
  catalogo: Tela[];
}

const estadoInicial: EstadoSessao = {
  carregada: false,
  principal: false,
  acessoTotal: false,
  usuario: null,
  telasLiberadas: [],
  catalogo: [],
};

export default {
  state: (): EstadoSessao => ({ ...estadoInicial, telasLiberadas: [], catalogo: [] }),

  mutations: {
    setSessao(state: EstadoSessao, payload: any) {
      state.principal = !!payload.principal;
      state.acessoTotal = !!payload.acessoTotal;
      state.usuario = payload.usuario || null;
      state.telasLiberadas = payload.telasLiberadas || [];
      state.catalogo = payload.catalogo || [];
      state.carregada = true;
    },

    // Chamado no logout. NAO deve entrar no resetState de application.ts: aquele
    // roda no beforeEach de main.ts, a cada navegacao, e apagaria a sessao a
    // cada clique do usuario.
    resetSessao(state: EstadoSessao) {
      state.carregada = false;
      state.principal = false;
      state.acessoTotal = false;
      state.usuario = null;
      state.telasLiberadas = [];
      state.catalogo = [];
    },
  },

  actions: {
    async carregarSessao({ commit }: any) {
      const res = await Vue.prototype.$http.get("/me");

      commit("setSessao", res.data);
      // O /me ja traz a empresa: evita uma segunda chamada no boot e mantem o
      // modulo tenant alimentado para o Menu e o Header.
      if (res.data.tenant) commit("setTenant", res.data.tenant);

      return res.data;
    },
  },

  getters: {
    souPrincipal: (state: EstadoSessao) => state.principal,

    // Antes de a sessao carregar ninguem pode nada - e o guard do router que
    // segura a navegacao ate ela chegar. Liberar por padrao aqui faria o menu
    // piscar completo no primeiro instante de cada F5.
    podeAcessar: (state: EstadoSessao) => (tela: string) => {
      if (state.principal || state.acessoTotal) return true;
      if (!tela) return true;
      return state.telasLiberadas.indexOf(tela) >= 0;
    },

    catalogoTelas: (state: EstadoSessao) => state.catalogo,
  },
};
