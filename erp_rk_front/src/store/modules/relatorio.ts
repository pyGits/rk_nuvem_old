import Vue from "vue";
import { getCurrentDate } from "@/utils/date";
interface Relatorio {
  dtInicio: string;
  dtFim: string;
  // 0 = todas as lojas
  loja: number;
  numero: string;
  caixa: string;
  cpfConsumidor: string;
  vendedor: string;
  valorTotal: string;
  xmlVenda: string;
  cliente: string;
  clienteDescricao: string;
  finalizadora: string;
  finalizadoraDescricao: string;
  // "" = todos, "0" = normais, "1" = cancelados
  cancelado: string;
}

// Filtros de venda: ficam no topo do painel e valem para todas as abas. As
// abas agregadas (Lojas, Caixas, Produtos, Seção, Finalizadora) vêm somadas do
// banco, então quem aplica esses filtros é o backend, não a tela.
const filtroVendaInicial = {
  numero: "",
  caixa: "",
  cpfConsumidor: "",
  vendedor: "",
  valorTotal: "",
  xmlVenda: "",
  cliente: "",
  clienteDescricao: "",
  finalizadora: "",
  finalizadoraDescricao: "",
  cancelado: "0",
};

const initialRelatorio: Relatorio = {
  dtInicio: getCurrentDate(),
  dtFim: getCurrentDate(),
  loja: 0,
  ...filtroVendaInicial,
};

// Params comuns a todas as consultas do painel. As descrições de cliente e
// finalizadora existem só para o rótulo da tela e não vão para a consulta.
function paramsPainel(filtro: any) {
  const { clienteDescricao, finalizadoraDescricao, ...params } = filtro;
  return params;
}

export default {
  state: (): {
    filtro: Relatorio;
    relatorioPainelVendasLojas: any;
    relatorioPainelVendasProdutos: any;
    relatorioPainelVendasCaixas: any;
    relatorioPainelVendasFinalizadoras: any;
    relatorioPainelVendasSecoes: any;
    relatorioPainelVendasCupom: any;
    relatorioPainelVendasCupomAnalitico: any;
    relatorioCupomUnico: any;
  } => ({
    filtro: { ...initialRelatorio },
    relatorioPainelVendasLojas: [],
    relatorioPainelVendasProdutos: [],
    relatorioPainelVendasCaixas: [],
    relatorioPainelVendasFinalizadoras: [],
    relatorioPainelVendasSecoes: [],
    relatorioPainelVendasCupom: [],
    relatorioPainelVendasCupomAnalitico: { itens: [], formasPagamento: [] },
    relatorioCupomUnico: { itens: [], formasPagamento: [] },
  }),

  mutations: {
    setRelatorioDtInicio(state: any, payload: any) {
      state.filtro.dtInicio = payload;
    },
    setRelatorioDtFim(state: any, payload: any) {
      state.filtro.dtFim = payload;
    },
    setRelatorioLoja(state: any, payload: any) {
      state.filtro.loja = payload;
    },
    // Recebe só os campos alterados, para a barra de filtros não precisar
    // reenviar o filtro inteiro a cada aplicação.
    setRelatorioFiltroVenda(state: any, payload: any) {
      Object.keys(payload).forEach((campo) => {
        Vue.set(state.filtro, campo, payload[campo]);
      });
    },
    limparRelatorioFiltroVenda(state: any) {
      Object.assign(state.filtro, filtroVendaInicial);
    },
    setRelatorioPainelVendasLojas(state: any, payload: any) {
      state.relatorioPainelVendasLojas = payload;
    },
    setRelatorioPainelVendasProdutos(state: any, payload: any) {
      state.relatorioPainelVendasProdutos = payload;
    },
    setRelatorioPainelVendasCaixas(state: any, payload: any) {
      state.relatorioPainelVendasCaixas = payload;
    },
    setRelatorioPainelVendasFinalizadoras(state: any, payload: any) {
      state.relatorioPainelVendasFinalizadoras = payload;
    },
    setRelatorioPainelVendasSecoes(state: any, payload: any) {
      state.relatorioPainelVendasSecoes = payload;
    },
    setRelatorioPainelVendasCupom(state: any, payload: any) {
      state.relatorioPainelVendasCupom = payload;
    },
    setRelatorioPainelVendasCupomAnalitico(state: any, payload: any) {
      state.relatorioPainelVendasCupomAnalitico = payload;
    },
    setRelatorioCupomUnico(state: any, payload: any) {
      state.relatorioCupomUnico = payload;
    },
    resetRelatorio(state: any) {
      state.relatorioPainelVendasLojas = [];
      state.relatorioPainelVendasProdutos = [];
      state.relatorioPainelVendasCaixas = [];
      state.relatorioPainelVendasFinalizadoras = [];
      state.relatorioPainelVendasSecoes = [];
      state.relatorioPainelVendasCupom = [];
      state.relatorioPainelVendasCupomAnalitico = { itens: [], formasPagamento: [] };
      state.relatorioCupomUnico = { itens: [], formasPagamento: [] };
    },
  },
  actions: {
    async getPainelVendasProdutos({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/produtos", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasProdutos", res.data);
        });
    },
    async getPainelVendasLojas({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/lojas", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasLojas", res.data);
        });
    },
    async getPainelVendasCaixas({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/caixas", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCaixas", res.data);
        });
    },
    async getPainelVendasFinalizadoras({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/finalizadoras", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasFinalizadoras", res.data);
        });
    },
    async getPainelVendasSecoes({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/secoes", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasSecoes", res.data);
        });
    },

    async getPainelVendasCupom({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/cupom", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCupom", res.data);
        });
    },
    async getPainelVendasCupomAnalitico({ state, commit }: any) {
      await Vue.prototype.$http
        .get("/relatorios/painel/cupom/analitico", {
          params: paramsPainel(state.filtro),
        })
        .then((res: any) => {
          commit("setRelatorioPainelVendasCupomAnalitico", res.data);
        });
    },
    async getPainelEstoqueSaldo({ commit }: any, parametros: any) {
      return await Vue.prototype.$http.get("/relatorios/estoque/saldo", {
        params: parametros,
      });
    },
    async getRelatorioProdutoListagem({ commit }: any, parametros: any) {
      return await Vue.prototype.$http.get("/relatorios/produtos/listagem", {
        params: parametros,
      });
    },
    async getCupomUnico({ commit }: any, cupom: any) {
      return await Vue.prototype.$http
        .get("/relatorios/cupom", {
          params: cupom,
        })
        .then((res: any) => {
          commit("setRelatorioCupomUnico", res.data);
        });
    },
  },
};
