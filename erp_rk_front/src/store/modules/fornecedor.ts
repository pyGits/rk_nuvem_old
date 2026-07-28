import Vue from "vue";
import Endereco from "./Abstract/endereco";
import Pessoa from "./Abstract/pessoa";
interface Fornecedor {
  codigo: number;
  observacao: string;
  im: string;
  endereco: Endereco;
  transportadora: string;
  pessoa: Pessoa;
}

const initialFornecedor: Fornecedor = {
  codigo: 0,
  observacao: "",
  im: "",
  transportadora: "N",
  endereco: new Endereco(),
  pessoa: new Pessoa(),
};

export default {
  state: (): { fornecedor: Fornecedor; fornecedorList: Fornecedor[] } => ({
    fornecedor: { ...initialFornecedor },
    fornecedorList: [],
  }),

  mutations: {
    setFornecedor(state: any, payload: any) {
      const { codigo, observacao, transportadora, im } = payload;
      const fornecedor = { codigo, observacao, transportadora, im };

      const { celular, cnpjcpf, email, fantasia, ierg, nome, telefone, telefone2 } = payload;
      const pessoa = {
        celular: celular ? celular : "",
        cnpjcpf: cnpjcpf ? cnpjcpf : "",
        email: email ? email : "",
        fantasia: fantasia ? fantasia : "",
        ierg: ierg ? ierg : "",
        nome: nome ? nome : "",
        telefone: telefone ? telefone : "",
        telefone2: telefone2 ? telefone2 : "",
      };

      const { logradouro, cep, uf, cidade, bairro, complemento } = payload;
      const endereco = {
        logradouro: logradouro ? logradouro : "",
        cep: cep ? cep : "",
        uf: uf ? uf : "",
        cidade: cidade ? cidade : "",
        bairro: bairro ? bairro : "",
        complemento: complemento ? complemento : "",
      };

      Object.assign(state.fornecedor.pessoa, pessoa);
      Object.assign(state.fornecedor.endereco, endereco);
      Object.assign(state.fornecedor, fornecedor);
    },
    resetFornecedor(state: any) {
      initialFornecedor.pessoa = new Pessoa();
      initialFornecedor.endereco = new Endereco();
      state.fornecedor = Object.assign({}, initialFornecedor);
    },
    setFornecedors(state: any, payload: any) {
      state.fornecedorList = payload;
    },
    setFornecedorCodigo(state: any, payload: string) {
      state.fornecedor.codigo = payload;
    },
    setFornecedorIm(state: any, payload: string) {
      state.fornecedor.im = payload;
      state.fornecedor.im = state.fornecedor.im.replace(/[^0-9]/g, "");
      state.fornecedor.im = state.fornecedor.im.substring(0, 10);
    },
    setFornecedorObservacao(state: any, payload: string) {
      state.fornecedor.observacao = payload;
      state.fornecedor.observacao = state.fornecedor.observacao.toUpperCase();
      state.fornecedor.observacao = state.fornecedor.observacao.substring(0, 80);
    },
    setFornecedorTransportadora(state: any, payload: string) {
      state.fornecedor.transportadora = payload;
    },
    setFornecedorCnpjcpf(state: any, payload: string) {
      state.fornecedor.pessoa.setCnpjcpf(payload);
    },
    setFornecedorNome(state: any, payload: string) {
      state.fornecedor.pessoa.setNome(payload);
    },
    setFornecedorFantasia(state: any, payload: string) {
      state.fornecedor.pessoa.setFantasia(payload);
    },
    setFornecedorIerg(state: any, payload: string) {
      state.fornecedor.pessoa.setIerg(payload);
    },
    setFornecedorTelefone(state: any, payload: string) {
      state.fornecedor.pessoa.setTelefone(payload);
    },
    setFornecedorTelefone2(state: any, payload: string) {
      state.fornecedor.pessoa.setTelefone2(payload);
    },
    setFornecedorCelular(state: any, payload: string) {
      state.fornecedor.pessoa.setCelular(payload);
    },
    setFornecedorEmail(state: any, payload: string) {
      state.fornecedor.pessoa.setEmail(payload);
    },

    setFornecedorLogradouro(state: any, payload: string) {
      state.fornecedor.endereco.setLogradouro(payload);
    },
    setFornecedorCidade(state: any, payload: string) {
      state.fornecedor.endereco.setCidade(payload);
    },
    setFornecedorUf(state: any, payload: string) {
      state.fornecedor.endereco.setUf(payload);
    },
    setFornecedorCep(state: any, payload: string) {
      state.fornecedor.endereco.setCep(payload);
    },
    setFornecedorBairro(state: any, payload: string) {
      state.fornecedor.endereco.setBairro(payload);
    },
    setFornecedorComplemento(state: any, payload: string) {
      state.fornecedor.endereco.setComplemento(payload);
    },
  },

  actions: {
    async getFornecedor({ commit, dispatch }: any, payload: string) {
      commit("setContainerLoading", true);
      const fornecedor = await Vue.prototype.$http
        .get(`/fornecedors/${payload}`)
        .then((res: any) => {
          commit("setFornecedor", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          commit("resetFornecedor");
          return err;
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });

      return fornecedor;
    },
    async getFornecedors({ commit, dispatch }: any) {
      commit("setContainerLoading", true);
      await Vue.prototype.$http
        .get(`/fornecedors`)
        .then((res: any) => {
          commit("setFornecedors", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });
    },
    async gravarFornecedor({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/fornecedors", state.fornecedor)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetFornecedor");
          });
      } else {
        await Vue.prototype.$http
          .put("/fornecedors/" + payload, state.fornecedor)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetFornecedor");
          });
      }
    },
  },
};
