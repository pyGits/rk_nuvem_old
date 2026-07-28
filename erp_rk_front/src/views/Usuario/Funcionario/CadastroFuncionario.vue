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
import GeralTab from "./Tabs/Principal.vue";
import EnderecoTab from "./Tabs/Endereco.vue";

export default {
  async mounted() {
    const funcionario = await this.$store.dispatch(
      "getFuncionario",
      this.$route.params.codigo
    );
    if (funcionario?.response?.status === 404) {
      this.$router.push("/usuarios/funcionario");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    validaFuncionario() {
      this.$store.dispatch("resetError");
      const isValidEmail =
        this.$store.state.funcionario.funcionario.pessoa.validaEmail();
      if (this.$store.state.funcionario.funcionario.codigo.trim() === "") {
        this.$store.dispatch("showError", {
          state: "funcionario",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código da Funcionario não pode estar em branco !",
        });
        return false;
      }

      if (
        this.$store.state.funcionario.funcionario.pessoa.cnpjcpf.trim() === ""
      ) {
        this.$store.dispatch("showError", {
          state: "funcionario",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF da Funcionario não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.funcionario.funcionario.pessoa.nome.trim() === "") {
        this.$store.dispatch("showError", {
          state: "funcionario",
          chave: "nome",
          chave_message: "nome_message",
          message: "Nome da Funcionario não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.funcionario.funcionario.password.trim() === "") {
        this.$store.dispatch("showError", {
          state: "funcionario",
          chave: "senha",
          chave_message: "senha_message",
          message: "Senha da Funcionario não pode estar em branco !",
        });
        return false;
      }
      if (!isValidEmail) {
        this.$store.dispatch("showError", {
          state: "funcionario",
          chave: "email",
          chave_message: "email_message",
          message: "EMAIL Invalido !",
        });
        return false;
      }

      return true;
    },
    async gravar() {
      if (this.validaFuncionario()) {
        this.$store
          .dispatch("gravarFuncionario", this.$route.params.codigo)
          .then(() => {
            this.$router.push("/usuarios/funcionario");
          });
      }
    },
    cancelar() {
      this.$router.push("/usuarios/funcionario");
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
