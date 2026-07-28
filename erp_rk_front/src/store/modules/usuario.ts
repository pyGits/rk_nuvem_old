import Vue from "vue";
import Endereco from "./Abstract/endereco";
import Pessoa from "./Abstract/pessoa";
interface Usuario {
  codigo: number;
  user: string;
  password: string;
  endereco: Endereco;
  pessoa: Pessoa;
}

const initialUsuario: Usuario = {
  codigo: 0,
  user: "",
  password: "",
  endereco: new Endereco(),
  pessoa: new Pessoa(),
};

export default {
  state: (): { usuario: Usuario; usuarioList: Usuario[] } => ({
    usuario: { ...initialUsuario },
    usuarioList: [],
  }),

  mutations: {
    setUsuario(state: any, payload: any) {
      const { codigo, user } = payload;
      const usuario = { codigo, user };

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

      Object.assign(state.usuario.pessoa, pessoa);
      Object.assign(state.usuario.endereco, endereco);
      Object.assign(state.usuario, usuario);
    },
    resetUsuario(state: any) {
      state.usuario = Object.assign({}, initialUsuario);
    },
    setUsuarios(state: any, payload: any) {
      state.usuarioList = payload;
    },
    setUsuarioCodigo(state: any, payload: string) {
      state.usuario.codigo = payload;
    },
    setUsuarioCnpjcpf(state: any, payload: string) {
      state.usuario.pessoa.setCnpjcpf(payload);
    },
    setUsuarioNome(state: any, payload: string) {
      state.usuario.pessoa.setNome(payload);
    },
    setUsuarioFantasia(state: any, payload: string) {
      state.usuario.pessoa.setFantasia(payload);
    },
    setUsuarioIerg(state: any, payload: string) {
      state.usuario.pessoa.setIerg(payload);
    },
    setUsuarioTelefone(state: any, payload: string) {
      state.usuario.pessoa.setTelefone(payload);
    },
    setUsuarioCelular(state: any, payload: string) {
      state.usuario.pessoa.setCelular(payload);
    },
    setUsuarioEmail(state: any, payload: string) {
      state.usuario.pessoa.setEmail(payload);
    },

    setUsuarioLogradouro(state: any, payload: string) {
      state.usuario.endereco.setLogradouro(payload);
    },
    setUsuarioCidade(state: any, payload: string) {
      state.usuario.endereco.setCidade(payload);
    },
    setUsuarioUf(state: any, payload: string) {
      state.usuario.endereco.setUf(payload);
    },
    setUsuarioCep(state: any, payload: string) {
      state.usuario.endereco.setCep(payload);
    },
    setUsuarioBairro(state: any, payload: string) {
      state.usuario.endereco.setBairro(payload);
    },
    setUsuarioComplemento(state: any, payload: string) {
      state.usuario.endereco.setComplemento(payload);
    },
    setUsuarioUser(state: any, payload: string) {
      state.usuario.user = payload;
      state.usuario.user = state.usuario.user.replace(/\s+/g, "");
      state.usuario.user = state.usuario.user.substring(0, 20);
    },
    setUsuarioPassword(state: any, payload: string) {
      state.usuario.password = payload;
    },
  },

  actions: {
    async verificarUsuario({ state, commit }: any) {
      return await Vue.prototype.$http.post(
        "/usuarios/verificar",
        state.usuario
      );
    },
    async getUsuario({ commit, dispatch }: any, payload: string) {
      const usuario = await Vue.prototype.$http
        .get(`/usuarios/${payload}`)
        .then((res: any) => {
          commit("setUsuario", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
          return err;
        });

      return usuario;
    },
    async getUsuarios({ commit, dispatch }: any) {
      await Vue.prototype.$http
        .get(`/usuarios`)
        .then((res: any) => {
          commit("setUsuarios", res.data);
        })
        .catch((err: any) => {
          dispatch("showToastMessage", err.response.data.message);
        });
    },
    async gravarUsuario({ state, commit, dispatch }: any, payload: string) {
      if (payload === "novo") {
        return await Vue.prototype.$http.post("/usuarios", state.usuario);
      } else {
        return await Vue.prototype.$http.put(
          "/usuarios/" + payload,
          state.usuario
        );
        // .then((res: any) => {
        //   dispatch("showToastMessage", res.data.message);
        // })
        // .catch((err: any) => {
        //   dispatch("showToastMessage", err.response.data.message);
        // })
        // .finally(() => {
        //   commit("resetUsuario");
        // });
      }
    },
  },
};
