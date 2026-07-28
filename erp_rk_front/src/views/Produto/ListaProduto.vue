<template>
  <v-card>
    <v-card-title>Cadastro de Produtos</v-card-title>
    <v-data-table
      id="tableProduto"
      :headers="headers"
      :items="items"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Produtos por pág.',
      }"
      @click:row="selecionarProduto"
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
      <v-btn color="primary" @click="novoProduto" class="mr-2"
        >Novo Produto</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getProdutos");
    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    selecionarProduto(produto) {
      this.$router.push({ path: "/cadastro/produto/" + produto.codigo });
    },
    novoProduto() {
      this.$router.push({ path: "/cadastro/produto/novo" });
    },
  },
  computed: {
    items: {
      get() {
        return this.$store.state.produto.produtoList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código Barras", value: "codigo_barras" },
        { text: "Produto", value: "descricao" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableProduto {
  cursor: pointer;
}
</style>
