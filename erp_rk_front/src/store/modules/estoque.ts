import Vue from "vue";
import { maskMoneyToFloat, maskQuantityToFloat } from "@/utils/masks";
export interface Estoque {
  codigo_loja: number;
  codigo_produto: string;
  nome_loja: string;
  estoque: number;
  estoque_minimo: number;
  estoque_maximo: number;
}
const initialEstoque = {
  codigo_loja: 0,
  codigo_produto: "",
  nome_loja: "",
  estoque: 0,
  estoque_minimo: 0,
  estoque_maximo: 0,
};
export default {
  state: (): { estoque: Estoque; estoqueList: Estoque[] } => ({
    estoque: { ...initialEstoque },
    estoqueList: [],
  }),
  mutations: {
    resetEstoque(state: any) {
      Object.assign(state.estoque, initialEstoque);
    },
    setEstoque(state: any, payload: any) {
      state.estoque.codigo_loja = payload.codigo;
      state.estoque.nome_loja = payload.loja;
      console.log("mark", maskQuantityToFloat(payload.estoque, 3), payload.estoque);
      state.estoque.estoque = maskQuantityToFloat(payload.estoque, 3);
      state.estoque.estoque_minimo = maskQuantityToFloat(payload.estoque_minimo, 3);
      state.estoque.estoque_maximo = maskQuantityToFloat(payload.estoque_maximo, 3);
    },
    setEstoqueEstoque(state: any, payload: number) {
      state.estoque.estoque = payload;
    },
    setEstoqueMinimo(state: any, payload: number) {
      state.estoque.estoque_minimo = payload;
    },
    setEstoqueMaximo(state: any, payload: number) {
      state.estoque.estoque_maximo = payload;
    },

    setEstoqueList(state: any, payload: any) {
      state.estoqueList = payload;
    },
    updateEstoqueList(state: any, payload: any) {
      const index = state.estoqueList.findIndex((item: any) => item.codigo === payload.codigo_loja);

      state.estoqueList[index].estoque = payload.estoque;
      state.estoqueList[index].estoque_maximo = payload.estoque_maximo;
      state.estoqueList[index].estoque_minimo = payload.estoque_minimo;
    },
    setEstoqueCodigoProduto(state: any, payload: any) {
      state.estoqueList.map((estoque: any) => {
        estoque.codigo_produto = payload;
      });
    },
  },
  actions: {
    async gravarEstoque({ state }: any, payload: any) {
      await Vue.prototype.$http.post("/estoques", state.estoqueList);
    },
    async getEstoque({ commit }: any, payload: string) {
      await Vue.prototype.$http.get("/estoques/" + payload).then((res: any) => {
        commit("setEstoqueList", res.data);
      });
    },
  },
};
