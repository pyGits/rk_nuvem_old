<template>
  <v-card>
    <v-tabs v-model="tabIndex">
      <v-tab :key="0">Geral</v-tab>
      <v-tab :key="1">Endereço</v-tab>
      <!-- Quem define acesso e o login principal. O backend recusa de qualquer
           forma (somentePrincipal), isto so evita mostrar uma aba inutil. -->
      <v-tab v-if="souPrincipal" :key="2">Acessos</v-tab>

      <v-tab-item :key="0">
        <GeralTab />
      </v-tab-item>
      <v-tab-item :key="1">
        <EnderecoTab />
      </v-tab-item>
      <v-tab-item v-if="souPrincipal" :key="2">
        <AcessosTab />
      </v-tab-item>
    </v-tabs>
    <div class="d-flex flex-row-reverse container">
      <v-btn color="seccondary" class="mr-2" @click="cancelar">Cancelar</v-btn>
      <v-btn color="primary" class="mr-2" @click="gravar">Gravar</v-btn>
    </div>
  </v-card>
</template>

<script>
import GeralTab from "./CadastroUsuarioTabs/Principal.vue";
import EnderecoTab from "./CadastroUsuarioTabs/Endereco.vue";
import AcessosTab from "./CadastroUsuarioTabs/Acessos.vue";

export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    const usuario = await this.$store.dispatch(
      "getUsuario",
      this.$route.params.codigo
    );
    if (usuario?.response?.status === 404) {
      this.$router.push("/usuarios/usuariosweb");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
      // Usuario novo nasce sem acesso nenhum: o principal marca o que ele pode.
      this.$store.commit("setUsuarioAcessos", { acessoTotal: false, telas: [] });
    } else {
      this.$store.commit("setModeEdit");
      if (this.souPrincipal) {
        await this.$store.dispatch("getAcessosUsuario", this.$route.params.codigo);
      }
    }
    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    validaUsuario() {
      this.$store.commit("resetError");
      const isValidEmail =
        this.$store.state.usuario.usuario.pessoa.validaEmail();
      if (this.$store.state.usuario.usuario.codigo.trim() === "") {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código da Usuario não pode estar em branco !",
        });
        return false;
      }

      if (this.$store.state.usuario.usuario.pessoa.cnpjcpf.trim() === "") {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF da Usuario não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.usuario.usuario.pessoa.nome.trim() === "") {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "nome",
          chave_message: "nome_message",
          message: "Nome da Usuario não pode estar em branco !",
        });
        return false;
      }
      if (!isValidEmail) {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "email",
          chave_message: "email_message",
          message: "EMAIL Invalido !",
        });
        return false;
      }
      if (this.$store.state.usuario.usuario.user.trim() === "") {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "user",
          chave_message: "user_message",
          message: "Usuário não pode estar em branco",
        });
        return false;
      }
      if (this.$store.state.usuario.usuario.password.trim() === "") {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "password",
          chave_message: "password_message",
          message: "Senha não pode estar em branco",
        });
        return false;
      }

      return true;
    },
    async gravar() {
      if (!this.validaUsuario()) return;

      try {
        const res = await this.$store.dispatch("gravarUsuario", this.$route.params.codigo);

        // Os acessos vao numa segunda chamada, em /usuarios/:codigo/acessos.
        // No modo "novo" o codigo da rota e a palavra "novo": quem identifica o
        // registro gravado e o codigo do formulario.
        if (this.souPrincipal) {
          const codigo = this.$store.state.usuario.usuario.codigo;

          try {
            await this.$store.dispatch("gravarAcessosUsuario", codigo);
          } catch (erroAcessos) {
            console.log(erroAcessos);
            // O cadastro ja esta gravado; sem os acessos o usuario fica sem
            // enxergar nada - estado seguro, mas a pessoa precisa saber.
            this.$store.dispatch(
              "showToastMessage",
              "Usuário gravado, mas os acessos não foram salvos. Abra o cadastro e tente de novo."
            );
            return;
          }
        }

        this.$store.dispatch("showToastMessage", res.data.message);
        this.$router.push("/usuarios/usuariosweb");
      } catch (err) {
        console.log(err);
        this.$store.dispatch("showToastMessage", err.response.data.message);
      }
    },
    cancelar() {
      this.$router.push("/usuarios/usuariosweb");
    },
  },
  computed: {
    souPrincipal() {
      return this.$store.getters.souPrincipal;
    },
  },
  data() {
    return {
      tabIndex: 0,
    };
  },
  name: "Tabs",
  components: { GeralTab, EnderecoTab, AcessosTab },
};
</script>
