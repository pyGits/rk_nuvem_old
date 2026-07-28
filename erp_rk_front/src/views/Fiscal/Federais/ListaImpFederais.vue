<template>
  <v-card>
    <v-card-title>Cadastro Impostos Federais</v-card-title>
    <v-data-table
      id="tableImpFederal"
      @click:row="selecionarTributacao"
      :headers="headers"
      :items="items"
    >
    </v-data-table>

    <div class="d-flex flex-row-reverse container">
      <v-btn color="primary" @click="novaTributacao" class="mr-2"
        >Novo Imp Federal</v-btn
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
    await this.$store.dispatch("getImpFederais").finally(() => {
      this.$store.commit("setContainerLoading", false);
    });
  },
  methods: {
    selecionarTributacao(impfederal) {
      this.$router.push(`/fiscal/impfederal/${impfederal.codigo}`);
    },
    novaTributacao() {
      this.$router.push("/fiscal/impfederal/novo");
    },
  },

  computed: {
    items: {
      get() {
        return this.$store.state.impfederal.impfederalList;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tableImpFederal {
  cursor: pointer;
}
</style>
