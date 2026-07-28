import { Module } from "vuex";

interface Error {
  produto: {
    codigo: boolean;
    codigo_message: string;
    descricao: boolean;
    descricao_message: string;
    ncm: boolean;
    ncm_message: string;
    tributacao: boolean;
    tributacao_message: string;
  };
}

interface State {
  error: Error;
}
const initialState = {
  error: {
    produto: {
      codigo: false,
      codigo_message: "",
      descricao: false,
      descricao_message: "",
      ncm: false,
      ncm_message: "",
      tributacao: false,
      tributacao_message: "",
    },
    loja: {
      nome: false,
      nome_message: "",
      cnpjcpf: false,
      cnpjcpf_message: "",
    },
    cliente: {
      nome: false,
      nome_message: "",
      cnpjcpf: false,
      cnpjcpf_message: "",
    },
    funcionario: {
      nome: false,
      nome_message: "",
      cnpjcpf: false,
      cnpjcpf_message: "",
      senha: false,
      senha_message: "",
    },
    fornecedor: {
      nome: false,
      nome_message: "",
      cnpjcpf: false,
      cnpjcpf_message: "",
    },
    usuario: {
      nome: false,
      nome_message: "",
      cnpjcpf: false,
      cnpjcpf_message: "",
      user: false,
      user_message: "",
      password: false,
      password_message: "",
    },
  },
};

const module: Module<State, any> = {
  state: JSON.parse(JSON.stringify(initialState)), // faz uma cópia sem referência
  mutations: {
    setError(state: any, payload: any) {
      state.error[payload.state][payload.chave] = true;
      state.error[payload.state][payload.chave_message] = payload.message;
    },
    resetError(state: any) {
      // state.error.produto.ncm = false;
      state.error = JSON.parse(JSON.stringify(initialState.error));
    },
  },
  actions: {
    showError({ commit, dispatch }: any, payload: any) {
      dispatch("showToastMessage", payload.message);
      commit("setError", payload);
    },

    validateProduto({ commit, dispatch }: any, payload: any) {
      commit("resetError");
      if (String(payload.codigo).trim() === "") {
        dispatch("showError", {
          state: "produto",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código do Produto não pode estar em branco !",
        });
        return false;
      }

      if (payload.descricao.trim() === "") {
        dispatch("showError", {
          state: "produto",
          chave: "descricao",
          chave_message: "descricao_message",
          message: "Descrição do Produto não pode estar em branco !",
        });
        return false;
      }
      if (payload.ncm === "00000000" || payload.ncm === "") {
        dispatch("showError", {
          state: "produto",
          chave: "ncm",
          chave_message: "ncm_message",
          message: "NCM é de preenchimento obrigatório !",
        });
        return false;
      }
      if (payload.tributacao === "000" || payload.ncm === "") {
        dispatch("showError", {
          state: "produto",
          chave: "tributacao",
          chave_message: "tributacao_message",
          message: "TRIBUTAÇÃO é de preenchimento obrigatório !",
        });
        return false;
      }

      return true;
    },
  },
};

export default module;
