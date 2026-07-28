<template>
  <v-card>
    <v-card-title>Cadastro de Fornecedor</v-card-title>
    <v-data-table
      id="tableFornecedor"
      :headers="headers"
      :items="fornecedorList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Fornecedor por pág.',
      }"
      @click:row="selecionarFornecedor"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Pesquisar"
            single-line
            hide-details
          ></v-text-field>
        </v-toolbar>
      </template>
    </v-data-table>
    <div class="d-flex flex-row-reverse container">
      <v-btn color="primary" @click="novoFornecedor" class="mr-2"
        >Novo Fornecedor</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    await this.$store.dispatch("getFornecedors");
  },
  methods: {
    novoFornecedor() {
      this.$router.push("/cadastro/fornecedor/novo");
    },
    selecionarFornecedor(fornecedor) {
      this.$router.push(`/cadastro/fornecedor/${fornecedor.codigo}`);
    },
  },
  computed: {
    fornecedorList: {
      get() {
        return this.$store.state.fornecedor.fornecedorList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Fornecedor", value: "nome" },
        { text: "Nome Fantasia", value: "fantasia" },
        { text: "Telefone", value: "telefone" },
        { text: "Telefone 2", value: "telefone2" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableFornecedor {
  cursor: pointer;
}
</style>
