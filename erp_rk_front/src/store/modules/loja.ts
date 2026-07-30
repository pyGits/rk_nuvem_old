import Vue from "vue";
import Endereco from "./Abstract/endereco";
import Pessoa from "./Abstract/pessoa";
interface Loja {
  codigo: number;
  endereco: Endereco;
  pessoa: Pessoa;
  token: string;
}

const initialLoja: Loja = {
  codigo: 0,
  endereco: new Endereco(),
  pessoa: new Pessoa(),
  token: "",
};

export default {
  state: (): { loja: Loja; lojaList: Loja[] } => ({
    loja: { ...initialLoja },
    lojaList: [],
  }),

  mutations: {
    setLoja(state: any, payload: any) {
      const { codigo, token } = payload;
      const loja = { codigo, token };

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

      Object.assign(state.loja.pessoa, pessoa);
      Object.assign(state.loja.endereco, endereco);
      Object.assign(state.loja, loja);
    },
    resetLoja(state: any) {
      initialLoja.pessoa = new Pessoa();
      initialLoja.endereco = new Endereco();
      state.loja = Object.assign({}, initialLoja);
    },
    setLojas(state: any, payload: any) {
      state.lojaList = payload;
    },
    setLojaCodigo(state: any, payload: string) {
      state.loja.codigo = payload;
    },
    setLojaCnpjcpf(state: any, payload: string) {
      state.loja.pessoa.setCnpjcpf(payload);
    },
    setLojaNome(state: any, payload: string) {
      state.loja.pessoa.setNome(payload);
    },
    setLojaFantasia(state: any, payload: string) {
      state.loja.pessoa.setFantasia(payload);
    },
    setLojaIerg(state: any, payload: string) {
      state.loja.pessoa.setIerg(payload);
    },
    setLojaTelefone(state: any, payload: string) {
      state.loja.pessoa.setTelefone(payload);
    },
    setLojaCelular(state: any, payload: string) {
      state.loja.pessoa.setCelular(payload);
    },
    setLojaEmail(state: any, payload: string) {
      state.loja.pessoa.setEmail(payload);
    },

    setLojaLogradouro(state: any, payload: string) {
      state.loja.endereco.setLogradouro(payload);
    },
    setLojaCidade(state: any, payload: string) {
      state.loja.endereco.setCidade(payload);
    },
    setLojaUf(state: any, payload: string) {
      state.loja.endereco.setUf(payload);
    },
    setLojaCep(state: any, payload: string) {
      state.loja.endereco.setCep(payload);
    },
    setLojaBairro(state: any, payload: string) {
      state.loja.endereco.setBairro(payload);
    },
    setLojaComplemento(state: any, payload: string) {
      state.loja.endereco.setComplemento(payload);
    },
    setLojaStatus(state: any, payload: any) {
      const cargas = Array.isArray(payload) ? payload : [];

      state.lojaList.map((loja: any) => {
        const carga = cargas.find(
          (item: any) => String(item.codigo) === String(loja.codigo)
        );

        // Esses campos nao vem da API de lojas, entao precisam de Vue.set para
        // a barra de progresso reagir as trocas de estado.
        Vue.set(loja, "cargaStatus", carga ? carga.status : "CONCLUIDA");
        Vue.set(loja, "cargaEtapa", carga ? carga.etapa : null);
        Vue.set(loja, "cargaIndice", carga ? carga.indice : null);
        Vue.set(loja, "cargaTotal", carga ? carga.total : null);
        Vue.set(loja, "cargaPercentual", carga ? carga.percentual : null);
      });
    },
  },

  actions: {
    async enviaCargaCompleta({ state }: any, payload: any) {
      await Vue.prototype.$http.post("/cargaCompleta", payload);
    },
    async enviaCargaAlterados({ state }: any, payload: any) {
      await Vue.prototype.$http.post("/cargaAlterados", payload);
    },
    async verificaCargaStatus({ commit }: any, payload: any) {
      await Vue.prototype.$http.get("/carga/status").then((res: any) => {
        // console.log(res.data);
        commit("setLojaStatus", res.data);
      });
    },
    async getLoja({ commit, dispatch }: any, payload: string) {
      const loja = await Vue.prototype.$http
        .get(`/lojas/${payload}`)
        .then((res: any) => {
          commit("setLoja", res.data);
        })
        .catch((err: any) => {
          commit("resetLoja");
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });

      return loja;
    },
    async getLojas({ commit, dispatch }: any) {
      await Vue.prototype.$http
        .get(`/lojas`)
        .then((res: any) => {
          commit("setLojas", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
        });
    },
    async gravarLoja({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        return await Vue.prototype.$http.post("/lojas", state.loja);
      } else {
        return await Vue.prototype.$http.put("/lojas/" + payload, state.loja);
      }
    },
  },
};
