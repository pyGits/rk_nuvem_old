import Vue from "vue";
import { maskMoneyToFloat, maskQuantityToFloat } from "@/utils/masks";
import { calculateMargemPraticada, calculateMarkDown, calculateMarkup } from "@/utils/calculate";
export interface Preco {
  codigo_loja: number;
  codigo_produto: string;
  nome_loja: string;
  preco: number;
  markup: number;
  custo: number;
  sugestao: number;
  margemPraticada: number;
  markDown: number;
  oferta: number;
  preco2: number;
  preco2_qtd: number;
}
const initialPreco = {
  codigo_loja: 0,
  codigo_produto: "",
  nome_loja: "",
  preco: 0,
  markup: 0,
  custo: 0,
  sugestao: 0,
  margemPraticada: 0,
  markDown: 0,
  oferta: 0,
  preco2: 0,
  preco2_qtd: 0,
};
export default {
  state: (): { preco: Preco; precoList: Preco[] } => ({
    preco: { ...initialPreco },
    precoList: [],
  }),
  mutations: {
    resetPreco(state: any) {
      Object.assign(state.preco, initialPreco);
    },
    setPreco(state: any, payload: any) {
      state.preco.codigo_loja = payload.codigo;
      state.preco.nome_loja = payload.loja;
      state.preco.preco = maskMoneyToFloat(payload.preco);
      state.preco.markup = payload.markupGrupoSubgrupo > 0 ? maskMoneyToFloat(payload.markupGrupoSubgrupo) : maskMoneyToFloat(payload.markup);

      state.preco.custo = maskMoneyToFloat(payload.custo);
      state.preco.oferta = maskMoneyToFloat(payload.oferta);

      state.preco.preco2 = maskMoneyToFloat(payload.preco2);
      state.preco.preco2_qtd = maskQuantityToFloat(payload.preco2_qtd);

      state.preco.sugestao = calculateMarkup(state.preco.custo, state.preco.markup);
      state.preco.margemPraticada = calculateMargemPraticada(state.preco);
      state.preco.markDown = calculateMarkDown(state.preco);
    },
    setPrecoPreco(state: any, payload: number) {
      state.preco.preco = payload;
      state.preco.margemPraticada = calculateMargemPraticada(state.preco);
      state.preco.markDown = calculateMarkDown(state.preco);
    },
    setPrecoPreco2(state: any, payload: number) {
      state.preco.preco2 = payload;
    },
    setPrecoPreco2Qtd(state: any, payload: number) {
      state.preco.preco2_qtd = payload;
    },
    setPrecoOferta(state: any, payload: number) {
      state.preco.oferta = payload;
      state.preco.margemPraticada = calculateMargemPraticada(state.preco);
      state.preco.markDown = calculateMarkDown(state.preco);
    },
    setPrecoSugestao(state: any, payload: number) {
      state.preco.sugestao = payload;
    },
    setPrecoMarkDown(state: any, payload: number) {
      state.preco.markDown = payload;
    },

    setPrecoMargemPraticada(state: any, payload: number) {
      state.preco.margemPraticada = payload;
    },
    setPrecoCusto(state: any, payload: number) {
      state.preco.custo = payload;
      state.preco.sugestao = calculateMarkup(state.preco.custo, state.preco.markup);

      state.preco.margemPraticada = calculateMargemPraticada(state.preco);

      state.preco.markDown = calculateMarkDown(state.preco);
    },
    setPrecoMarkup(state: any, payload: number) {
      state.preco.markup = payload;
      state.preco.sugestao = calculateMarkup(state.preco.custo, state.preco.markup);
    },
    setPrecoList(state: any, payload: any) {
      state.precoList = payload;
    },
    updatePrecoList(state: any, payload: any) {
      const index = state.precoList.findIndex((item: any) => item.codigo === payload.codigo_loja);

      state.precoList[index].preco = payload.preco;
      state.precoList[index].custo = payload.custo;
      state.precoList[index].markup = payload.markup;
      state.precoList[index].oferta = payload.oferta;
      state.precoList[index].preco2 = payload.preco2;
      state.precoList[index].preco2_qtd = payload.preco2_qtd;
    },
    updatePrecoListSugestao(state: any, payload: any) {
      const index = state.precoList.findIndex((item: any) => item.codigo === payload.codigo_loja);

      state.precoList[index].preco = payload.sugestao;
      state.precoList[index].custo = payload.custo;
      state.precoList[index].markup = payload.markup;
      state.precoList[index].oferta = payload.oferta;
      state.precoList[index].preco2 = payload.preco2;
      state.precoList[index].preco2_qtd = payload.preco2_qtd;
    },
    setPrecoCodigoProduto(state: any, payload: any) {
      state.precoList.map((preco: any) => {
        preco.codigo_produto = payload;
      });
    },
  },
  actions: {
    async gravarPreco({ state }: any, payload: any) {
      await Vue.prototype.$http.post("/precos", state.precoList);
    },
    async getPreco({ commit }: any, payload: string) {
      await Vue.prototype.$http.get("/precos/" + payload).then((res: any) => {
        commit("setPrecoList", res.data);
      });
    },
  },
};
