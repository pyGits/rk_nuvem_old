import Vue from "vue";
import Endereco from "./Abstract/endereco";
import Pessoa from "./Abstract/pessoa";
interface Funcionario {
  codigo: number;
  endereco: Endereco;
  pessoa: Pessoa;
  comissao: number;
  cargo: string;
  password: string;
}

const initialFuncionario: Funcionario = {
  codigo: 0,
  comissao: 0,
  cargo: "0",
  password: "",
  endereco: new Endereco(),
  pessoa: new Pessoa(),
};

export default {
  state: (): { funcionario: Funcionario; funcionarioList: Funcionario[] } => ({
    funcionario: { ...initialFuncionario },
    funcionarioList: [],
  }),

  mutations: {
    setFuncionario(state: any, payload: any) {
      const { codigo, comissao, cargo } = payload;
      const funcionario = {
        codigo,
        comissao: comissao ?? 0,
        cargo: cargo ?? "0",
      };

      const { celular, cnpjcpf, email, fantasia, ierg, nome } = payload;
      const pessoa = {
        celular: celular ? celular : "",
        cnpjcpf: cnpjcpf ? cnpjcpf : "",
        email: email ? email : "",
        fantasia: fantasia ? fantasia : "",
        ierg: ierg ? ierg : "",
        nome: nome ? nome : "",
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

      Object.assign(state.funcionario.pessoa, pessoa);
      Object.assign(state.funcionario.endereco, endereco);
      Object.assign(state.funcionario, funcionario);
    },
    resetFuncionario(state: any) {
      state.funcionario = Object.assign({}, initialFuncionario);
    },
    setFuncionarios(state: any, payload: any) {
      state.funcionarioList = payload;
    },
    setFuncionarioCodigo(state: any, payload: string) {
      state.funcionario.codigo = payload;
    },
    setFuncionarioCnpjcpf(state: any, payload: string) {
      state.funcionario.pessoa.setCnpjcpf(payload);
    },
    setFuncionarioNome(state: any, payload: string) {
      state.funcionario.pessoa.setNome(payload);
    },
    setFuncionarioFantasia(state: any, payload: string) {
      state.funcionario.pessoa.setFantasia(payload);
    },
    setFuncionarioIerg(state: any, payload: string) {
      state.funcionario.pessoa.setIerg(payload);
    },
    setFuncionarioTelefone(state: any, payload: string) {
      state.funcionario.pessoa.setTelefone(payload);
    },
    setFuncionarioCelular(state: any, payload: string) {
      state.funcionario.pessoa.setCelular(payload);
    },
    setFuncionarioEmail(state: any, payload: string) {
      state.funcionario.pessoa.setEmail(payload);
    },

    setFuncionarioLogradouro(state: any, payload: string) {
      state.funcionario.endereco.setLogradouro(payload);
    },
    setFuncionarioCidade(state: any, payload: string) {
      state.funcionario.endereco.setCidade(payload);
    },
    setFuncionarioUf(state: any, payload: string) {
      state.funcionario.endereco.setUf(payload);
    },
    setFuncionarioCep(state: any, payload: string) {
      state.funcionario.endereco.setCep(payload);
    },
    setFuncionarioBairro(state: any, payload: string) {
      state.funcionario.endereco.setBairro(payload);
    },
    setFuncionarioComplemento(state: any, payload: string) {
      state.funcionario.endereco.setComplemento(payload);
    },
    setFuncionarioComissao(state: any, payload: number) {
      state.funcionario.comissao = payload;
    },
    setFuncionarioCargo(state: any, payload: number) {
      state.funcionario.cargo = payload;
    },
    setFuncionarioSenha(state: any, payload: string) {
      state.funcionario.password = payload;
    },
  },

  actions: {
    async getFuncionario({ commit, dispatch }: any, payload: string) {
      commit("setContainerLoading", true);
      const funcionario = await Vue.prototype.$http
        .get(`/funcionarios/${payload}`)
        .then((res: any) => {
          commit("setFuncionario", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });

      return funcionario;
    },
    async getFuncionarios({ commit, dispatch }: any) {
      commit("setContainerLoading", true);
      await Vue.prototype.$http
        .get(`/funcionarios`)
        .then((res: any) => {
          commit("setFuncionarios", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });
    },
    async gravarFuncionario({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/funcionarios", state.funcionario)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetFuncionario");
          });
      } else {
        await Vue.prototype.$http
          .put("/funcionarios/" + payload, state.funcionario)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetFuncionario");
          });
      }
    },
  },
};
