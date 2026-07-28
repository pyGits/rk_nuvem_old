<template>
  <v-container>
    <v-dialog v-model="localDialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Lista de Tributações</span>
        </v-card-title>
        <v-data-table
          id="tableTributacao"
          :headers="header"
          :items="items"
          @click:row="selecionarTributacao"
        ></v-data-table>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      header: [
        {
          text: "Código",
          value: "codigo",
        },
        {
          text: "Tributação",
          value: "nome",
        },
      ],
    };
  },
  methods: {
    selecionarTributacao(tributacao) {
      this.$store.commit("setTributacao", tributacao);
      this.localDialog = false;
    },
  },
  computed: {
    localDialog: {
      get() {
        return this.$store.state.Application.dialogTributacao;
      },
      set(valor) {
        this.$store.commit("setDialogTributacao", valor);
      },
    },
    items: {
      get() {
        return this.$store.state.tributacao.tributacaoList;
      },
    },
  },
  watch: {
    async localDialog() {
      await this.$store.dispatch("getTributacoes");
    },
  },
};
</script>

<style lang="scss" scoped>
#tableTributacao {
  cursor: pointer;
}
</style>
