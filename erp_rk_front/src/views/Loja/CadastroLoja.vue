<template>
  <v-card>
    <v-tabs v-model="tabIndex">
      <v-tab :key="0">Geral</v-tab>
      <v-tab :key="1">Endereço</v-tab>
      <v-tab :key="2">Configuração</v-tab>

      <v-tab-item :key="0">
        <GeralTab />
      </v-tab-item>
      <v-tab-item :key="1">
        <EnderecoTab />
      </v-tab-item>
      <v-tab-item :key="2">
        <Configuracao></Configuracao>
      </v-tab-item>
    </v-tabs>

    <div class="d-flex flex-row-reverse container">
      <v-btn color="seccondary" class="mr-2" @click="cancelar">Cancelar</v-btn>
      <v-btn color="primary" class="mr-2" @click="gravar">Gravar</v-btn>
    </div>
  </v-card>
</template>

<script>
import GeralTab from "./CadastroLojaTabs/Principal.vue";
import EnderecoTab from "./CadastroLojaTabs/Endereco.vue";
import Configuracao from "./CadastroLojaTabs/Configuracao.vue";

export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    const loja = await this.$store.dispatch("getLoja", this.$route.params.codigo);
    if (loja?.response?.status === 404) {
      this.$router.push("/cadastro/loja");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }

    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    validaLoja() {
      this.$store.commit("resetError");
      const isValidEmail = this.$store.state.loja.loja.pessoa.validaEmail();
      if (this.$store.state.loja.loja.codigo.trim() === "") {
        this.$store.dispatch("showError", {
          state: "loja",
          chave: "codigo",
          chave_message: "codigo_message",
          message: "Código da Loja não pode estar em branco !",
        });
        return false;
      }

      if (this.$store.state.loja.loja.pessoa.cnpjcpf.trim() === "") {
        this.$store.dispatch("showError", {
          state: "loja",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF da Loja não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.loja.loja.pessoa.nome.trim() === "") {
        this.$store.dispatch("showError", {
          state: "loja",
          chave: "nome",
          chave_message: "nome_message",
          message: "Nome da Loja não pode estar em branco !",
        });
        return false;
      }
      if (this.$store.state.loja.loja.endereco.uf.trim() === "") {
        this.$store.dispatch("showError", {
          state: "loja",
          chave: "uf",
          chave_message: "uf_message",
          message: "UF Da loja é obrigatório !",
        });
        return false;
      }
      if (!isValidEmail) {
        this.$store.dispatch("showError", {
          state: "loja",
          chave: "email",
          chave_message: "email_message",
          message: "EMAIL Invalido !",
        });
        return false;
      }

      return true;
    },
    async gravar() {
      if (this.validaLoja()) {
        this.$store
          .dispatch("gravarLoja", this.$route.params.codigo)
          .then((res) => {
            this.$store.dispatch("showToastMessage", res.data.message);
            this.$router.push("/cadastro/loja");
          })
          .catch((err) => {
            console.log("err", err);
            this.$store.dispatch("showToastMessage", err.response.data.message);
          });
      }
    },
    cancelar() {
      this.$router.push("/cadastro/loja");
    },
  },
  data() {
    return {
      tabIndex: 0,
    };
  },
  name: "Tabs",
  components: { GeralTab, EnderecoTab, Configuracao },
};
</script>
