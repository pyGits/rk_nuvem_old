<template>
  <v-card>
    <v-tabs v-model="tabIndex">
      <v-tab :key="0">Geral</v-tab>
      <v-tab :key="1">Endereço</v-tab>

      <v-tab-item :key="0">
        <GeralTab />
      </v-tab-item>
      <v-tab-item :key="1">
        <EnderecoTab />
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
    } else {
      this.$store.commit("setModeEdit");
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
      if (this.validaUsuario()) {
        this.$store
          .dispatch("gravarUsuario", this.$route.params.codigo)
          .then((res) => {
            this.$store.dispatch("showToastMessage", res.data.message);
            this.$router.push("/usuarios/usuariosweb");
          })
          .catch((err) => {
            console.log(err);
            this.$store.dispatch("showToastMessage", err.response.data.message);
          });
      }
    },
    cancelar() {
      this.$router.push("/usuarios/usuariosweb");
    },
  },
  data() {
    return {
      tabIndex: 0,
    };
  },
  name: "Tabs",
  components: { GeralTab, EnderecoTab },
};
</script>
