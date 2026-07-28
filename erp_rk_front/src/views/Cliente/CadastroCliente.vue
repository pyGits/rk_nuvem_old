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
import GeralTab from "./CadastroClienteTabs/Principal.vue";
import EnderecoTab from "./CadastroClienteTabs/Endereco.vue";

export default {
  async mounted() {
    const cliente = await this.$store.dispatch(
      "getCliente",
      this.$route.params.codigo
    );
    if (cliente?.response?.status === 404) {
      this.$router.push("/cadastro/cliente");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    validaCliente() {
      this.$store.commit("resetError");
      const isValidEmail =
        this.$store.state.cliente.cliente.pessoa.validaEmail();
      if (this.$store.state.cliente.cliente.codigo.trim() === "") {
        this.$store.dispatch("showError", {
          state: "cliente",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código da Cliente não pode estar em branco !",
        });
        return false;
      }

      if (this.$store.state.cliente.cliente.pessoa.cnpjcpf.trim() === "") {
        this.$store.dispatch("showError", {
          state: "cliente",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF da Cliente não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.cliente.cliente.pessoa.nome.trim() === "") {
        this.$store.dispatch("showError", {
          state: "cliente",
          chave: "nome",
          chave_message: "nome_message",
          message: "Nome da Cliente não pode estar em branco !",
        });
        return false;
      }
      if (!isValidEmail) {
        this.$store.dispatch("showError", {
          state: "cliente",
          chave: "email",
          chave_message: "email_message",
          message: "EMAIL Invalido !",
        });
        return false;
      }

      return true;
    },
    async gravar() {
      if (this.validaCliente()) {
        this.$store
          .dispatch("gravarCliente", this.$route.params.codigo)
          .then(() => {
            this.$router.push("/cadastro/cliente");
          });
      }
    },
    cancelar() {
      this.$router.push("/cadastro/cliente");
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
