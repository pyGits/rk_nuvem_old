import Vue from "vue";

interface Produto {
  codigo: string;
  codigo_barras: string;
  descricao: string;
  secao: string;
  grupo: number;
  fornecedor: string;
  subgrupo: number;
  unidade: string;
  formaVenda: string;
  ncm: string;
  cest: string;
  tributacao: string;
  balanca: string;
  balanca_validade: number;
  diversos: string;
  ativo: string;
  impfederal: string;
  codigos_barras_auxiliares: string[];
}
const initialProduto: Produto = {
  codigo: "",
  codigo_barras: "",
  descricao: "",
  secao: "1",
  fornecedor: "0",
  grupo: 0,
  subgrupo: 0,
  unidade: "UN",
  formaVenda: "N",
  ncm: "00000000",
  cest: "0000000",
  tributacao: "000",
  balanca: "N",
  balanca_validade: 0,
  diversos: "N",
  ativo: "S",
  impfederal: "1",
  codigos_barras_auxiliares: [],
};

// Sempre devolve um produto novo com um array de auxiliares próprio (evita que
// o array do initialProduto seja compartilhado entre instâncias por referência).
function criarProdutoInicial(): Produto {
  return { ...initialProduto, codigos_barras_auxiliares: [] };
}

export default {
  state: (): { produto: Produto; produtoList: Produto[] } => ({
    produto: criarProdutoInicial(),
    produtoList: [],
  }),
  mutations: {
    setProdutoCodigo(state: any, payload: string) {
      state.produto.codigo = String(payload);
      state.produto.codigo = payload.replace(/[^0-9]/g, "");
      state.produto.codigo = state.produto.codigo.trim();
      state.produto.codigo = state.produto.codigo.substring(0, 6);
    },
    setProdutoCodigoBarras(state: any, payload: string) {
      state.produto.codigo_barras = String(payload);
      state.produto.codigo_barras = payload.replace(/[^0-9]/g, "");
      state.produto.codigo_barras = state.produto.codigo_barras.trim();
      state.produto.codigo_barras = state.produto.codigo_barras.substring(
        0,
        14
      );
    },
    setProdutoDescricao(state: any, payload: string) {
      state.produto.descricao = payload;
      state.produto.descricao = payload.toUpperCase();
      state.produto.descricao = state.produto.descricao.substring(0, 80);
    },
    setProdutoSecao(state: any, payload: string) {
      state.produto.secao = payload;
    },
    setProdutoGrupo(state: any, payload: number) {
      state.produto.grupo = payload;
    },
    setProdutoSubgrupo(state: any, payload: number) {
      state.produto.subgrupo = payload;
    },
    setProdutoUnidade(state: any, payload: string) {
      state.produto.unidade = payload;
    },
    setProdutoFormaVenda(state: any, payload: string) {
      state.produto.formaVenda = payload;
    },
    setProdutoNCM(state: any, payload: string) {
      state.produto.ncm = payload;
      state.produto.ncm = payload.replace(/[^0-9]/g, "");
      state.produto.ncm = state.produto.ncm.substring(0, 8);
    },
    setProdutoCEST(state: any, payload: string) {
      state.produto.cest = payload;
      state.produto.cest = payload.replace(/[^0-9]/g, "");
      state.produto.cest = state.produto.cest.substring(0, 7);
    },
    setProdutoTributacao(state: any, payload: string) {
      state.produto.tributacao = payload;
    },
    setProdutoBalanca(state: any, payload: any) {
      state.produto.balanca = payload;
    },

    setProdutoBalancaValidade(state: any, payload: number) {
      state.produto.balanca_validade = payload;
    },

    setProdutoDiversos(state: any, payload: any) {
      state.produto.diversos = payload;
    },

    setProdutoAtivo(state: any, payload: any) {
      state.produto.ativo = payload;
    },

    setProdutoImpFederal(state: any, payload: any) {
      state.produto.impfederal = payload;
    },

    setProdutoFornecedor(state: any, payload: any) {
      state.produto.fornecedor = payload;
    },

    resetProduto(state: any) {
      Object.assign(state.produto, criarProdutoInicial());
    },
    setProduto(state: any, payload: any) {
      Object.assign(state.produto, payload);
      // Garante que o campo seja sempre um array (produtos antigos podem vir sem ele)
      state.produto.codigos_barras_auxiliares = Array.isArray(payload?.codigos_barras_auxiliares) ? [...payload.codigos_barras_auxiliares] : [];
    },
    addProdutoCodigoAuxiliar(state: any, payload: string) {
      const codigo = String(payload || "")
        .replace(/[^0-9]/g, "")
        .substring(0, 14);
      if (codigo === "") return;
      // Bloqueia auxiliar igual ao código de barras principal do produto,
      // ignorando zeros à esquerda (mesma normalização do backend).
      const semZeros = (v: string) => String(v || "").replace(/[^0-9]/g, "").replace(/^0+/, "");
      const principalNormalizado = semZeros(state.produto.codigo_barras);
      if (principalNormalizado !== "" && semZeros(codigo) === principalNormalizado) return;
      if (state.produto.codigos_barras_auxiliares.includes(codigo)) return;
      state.produto.codigos_barras_auxiliares = [...state.produto.codigos_barras_auxiliares, codigo];
    },
    removeProdutoCodigoAuxiliar(state: any, payload: string) {
      state.produto.codigos_barras_auxiliares = state.produto.codigos_barras_auxiliares.filter((codigo: string) => codigo !== payload);
    },
    setProdutoList(state: any, payload: Produto[]) {
      state.produtoList = payload;
    },
  },
  actions: {
    async getProdutos({ commit }: any) {
      await Vue.prototype.$http.get("/produtos").then((res: any) => {
        commit("setProdutoList", res.data);
      });
    },
    // Retorna true se o código já estiver em uso por OUTRO produto (principal ou
    // auxiliar). Em caso de falha de rede, retorna false para não travar o
    // cadastro — a validação final ocorre no backend ao salvar.
    async verificarCodigoBarrasEmUso(
      _ctx: any,
      payload: { codigo: string; ignorarCodigoProduto: string }
    ) {
      try {
        const res = await Vue.prototype.$http.get("/produtos/verificar-codigo-barras", {
          params: {
            codigo: payload.codigo,
            ignorarCodigoProduto: payload.ignorarCodigoProduto,
          },
        });
        return res.data.emUso === true;
      } catch (err) {
        return false;
      }
    },
    async getProduto({ commit }: any, payload: string) {
      commit("resetProduto");
      await Vue.prototype.$http.get("/produtos/" + payload).then((res: any) => {
        commit("setProduto", res.data);
      });
    },
    async gravarProduto({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/produtos", state.produto)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetProduto");
          });
      } else {
        await Vue.prototype.$http
          .put("/produtos/" + payload, state.produto)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetProduto");
          });
      }
    },
  },
};
