<template>
  <v-card>
    <v-card-title>Cadastro de Finalizadoras</v-card-title>
    <v-data-table
      id="tableFinalizadora"
      :headers="headers"
      :items="finalizadoraList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Finalizadoras por pág.',
      }"
      @click:row="selecionarFinalizadora"
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
      <v-btn color="primary" @click="novoFinalizadora" class="mr-2"
        >Nova Finalizadora</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getFinalizadoras").finally(() => {
      this.$store.commit("setContainerLoading", false);
    });
  },
  methods: {
    novoFinalizadora() {
      this.$router.push("/cadastro/finalizadora/novo");
    },
    selecionarFinalizadora(finalizadora) {
      this.$router.push(`/cadastro/finalizadora/${finalizadora.codigo}`);
    },
  },
  computed: {
    finalizadoraList: {
      get() {
        return this.$store.state.finalizadora.finalizadoraList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Finalizadora", value: "nome" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableFinalizadora {
  cursor: pointer;
}
</style>
