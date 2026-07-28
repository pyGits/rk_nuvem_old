<template>
  <v-card>
    <v-card-title>Cadastro de Lojas</v-card-title>
    <v-data-table
      id="tableLoja"
      :headers="headers"
      :items="lojaList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Lojas por pág.',
      }"
      @click:row="selecionarLoja"
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
      <v-btn color="primary" @click="novaLoja" class="mr-2">Nova Loja</v-btn>
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getLojas");
    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    novaLoja() {
      this.$router.push("/cadastro/loja/novo");
    },
    selecionarLoja(loja) {
      this.$router.push(`/cadastro/loja/${loja.codigo}`);
    },
  },
  computed: {
    lojaList: {
      get() {
        return this.$store.state.loja.lojaList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Loja", value: "nome" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableLoja {
  cursor: pointer;
}
</style>
