<template>
  <v-card>
    <v-card-title>Cadastro Tributação</v-card-title>
    <v-data-table
      id="tableTributacao"
      @click:row="selecionarTributacao"
      :headers="headers"
      :items="items"
    >
    </v-data-table>

    <div class="d-flex flex-row-reverse container">
      <v-btn color="primary" @click="novaTributacao" class="mr-2"
        >Nova Tributação</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Tributação", value: "nome" },
      ],
    };
  },
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getTributacoes").finally(() => {
      this.$store.commit("setContainerLoading", false);
    });
  },
  methods: {
    selecionarTributacao(tributacao) {
      this.$router.push(`/fiscal/tributacao/${tributacao.codigo}`);
    },
    novaTributacao() {
      this.$router.push("/fiscal/tributacao/novo");
    },
  },

  computed: {
    items: {
      get() {
        return this.$store.state.tributacao.tributacaoList;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tableTributacao {
  cursor: pointer;
}
</style>
