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
import GeralTab from "./CadastroFornecedorTabs/Principal.vue";
import EnderecoTab from "./CadastroFornecedorTabs/Endereco.vue";

export default {
  async mounted() {
    const fornecedor = await this.$store.dispatch(
      "getFornecedor",
      this.$route.params.codigo
    );
    if (fornecedor?.response?.status === 404) {
      this.$router.push("/cadastro/fornecedor");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    validaFornecedor() {
      this.$store.commit("resetError");
      const isValidEmail =
        this.$store.state.fornecedor.fornecedor.pessoa.validaEmail();
      if (this.$store.state.fornecedor.fornecedor.codigo.trim() === "") {
        this.$store.dispatch("showError", {
          state: "fornecedor",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código do Fornecedor não pode estar em branco !",
        });
        return false;
      }

      if (
        this.$store.state.fornecedor.fornecedor.pessoa.cnpjcpf.trim() === ""
      ) {
        this.$store.dispatch("showError", {
          state: "fornecedor",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF do Fornecedor não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.fornecedor.fornecedor.pessoa.nome.trim() === "") {
        this.$store.dispatch("showError", {
          state: "fornecedor",
          chave: "nome",
          chave_message: "nome_message",
          message: "Nome do Fornecedor não pode estar em branco !",
        });
        return false;
      }
      if (!isValidEmail) {
        this.$store.dispatch("showError", {
          state: "fornecedor",
          chave: "email",
          chave_message: "email_message",
          message: "EMAIL Invalido !",
        });
        return false;
      }

      return true;
    },
    async gravar() {
      if (this.validaFornecedor()) {
        this.$store
          .dispatch("gravarFornecedor", this.$route.params.codigo)
          .then(() => {
            this.$router.push("/cadastro/fornecedor");
          });
      }
    },
    cancelar() {
      this.$router.push("/cadastro/fornecedor");
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
