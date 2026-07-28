import Vue from "vue";
import Endereco from "./Abstract/endereco";
import Pessoa from "./Abstract/pessoa";
interface Cliente {
  codigo: number;
  observacao: string;
  limiteCredito: number;
  utilizaPreco2: false;
  percDesconto: number;
  endereco: Endereco;
  pessoa: Pessoa;
  createdAt: Date;
}

const initialCliente: Cliente = {
  codigo: 0,
  observacao: "",
  limiteCredito: 0,
  percDesconto: 0,
  utilizaPreco2: false,
  createdAt: new Date(),
  endereco: new Endereco(),
  pessoa: new Pessoa(),
};

export default {
  state: (): { cliente: Cliente; clienteList: Cliente[] } => ({
    cliente: { ...initialCliente },
    clienteList: [],
  }),

  mutations: {
    setCliente(state: any, payload: any) {
      const { codigo, limiteCredito, utiliza_preco2, perc_desconto, observacao, createdAt } = payload;
      const cliente = {
        codigo,
        utilizaPreco2: utiliza_preco2 !== undefined ? utiliza_preco2 : false,
        limiteCredito: limiteCredito !== undefined ? limiteCredito : 0,
        percDesconto: perc_desconto !== undefined ? perc_desconto : 0,
        observacao: observacao !== undefined ? observacao : "",
        createdAt,
      };

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

      Object.assign(state.cliente.pessoa, pessoa);
      Object.assign(state.cliente.endereco, endereco);
      Object.assign(state.cliente, cliente);
    },
    resetCliente(state: any) {
      state.cliente = Object.assign({}, initialCliente);
    },
    setClientes(state: any, payload: any) {
      state.clienteList = payload;
    },
    setClienteCodigo(state: any, payload: string) {
      state.cliente.codigo = payload;
    },
    setClienteCnpjcpf(state: any, payload: string) {
      state.cliente.pessoa.setCnpjcpf(payload);
    },
    setClienteNome(state: any, payload: string) {
      state.cliente.pessoa.setNome(payload);
    },
    setClienteFantasia(state: any, payload: string) {
      state.cliente.pessoa.setFantasia(payload);
    },
    setClienteIerg(state: any, payload: string) {
      state.cliente.pessoa.setIerg(payload);
    },
    setClienteTelefone(state: any, payload: string) {
      state.cliente.pessoa.setTelefone(payload);
    },
    setClienteTelefone2(state: any, payload: string) {
      state.cliente.pessoa.setTelefone2(payload);
    },
    setClienteCelular(state: any, payload: string) {
      state.cliente.pessoa.setCelular(payload);
    },
    setClienteEmail(state: any, payload: string) {
      state.cliente.pessoa.setEmail(payload);
    },
    setClienteObservacao(state: any, payload: string) {
      state.cliente.observacao = payload;
      state.cliente.observacao = state.cliente.observacao.toUpperCase();
      state.cliente.observacao = state.cliente.observacao.substring(0, 80);
    },
    setClienteLimiteCredito(state: any, payload: number) {
      state.cliente.limiteCredito = payload;
    },
    setClientePercDesconto(state: any, payload: number) {
      state.cliente.percDesconto = payload;
    },
    setClienteUtilizaPreco2(state: any, payload: boolean) {
      state.cliente.utilizaPreco2 = payload;
    },
    setClienteLogradouro(state: any, payload: string) {
      state.cliente.endereco.setLogradouro(payload);
    },
    setClienteCidade(state: any, payload: string) {
      state.cliente.endereco.setCidade(payload);
    },
    setClienteUf(state: any, payload: string) {
      state.cliente.endereco.setUf(payload);
    },
    setClienteCep(state: any, payload: string) {
      state.cliente.endereco.setCep(payload);
    },
    setClienteBairro(state: any, payload: string) {
      state.cliente.endereco.setBairro(payload);
    },
    setClienteComplemento(state: any, payload: string) {
      state.cliente.endereco.setComplemento(payload);
    },
  },

  actions: {
    async getCliente({ commit, dispatch }: any, payload: string) {
      commit("setContainerLoading", true);
      const cliente = await Vue.prototype.$http
        .get(`/clientes/${payload}`)
        .then((res: any) => {
          commit("setCliente", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });

      return cliente;
    },
    async getClientes({ commit, dispatch }: any) {
      commit("setContainerLoading", true);
      await Vue.prototype.$http
        .get(`/clientes`)
        .then((res: any) => {
          commit("setClientes", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
        })
        .finally(() => {
          commit("setContainerLoading", false);
        });
    },
    async gravarCliente({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        await Vue.prototype.$http
          .post("/clientes", state.cliente)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .catch((err: any) => {
            dispatch("showToastMessage", err.response.data.message);
          })
          .finally(() => {
            commit("resetCliente");
          });
      } else {
        await Vue.prototype.$http
          .put("/clientes/" + payload, state.cliente)
          .then((res: any) => {
            dispatch("showToastMessage", res.data.message);
          })
          .finally(() => {
            commit("resetCliente");
          });
      }
    },
  },
};
