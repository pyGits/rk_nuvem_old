<template>
  <v-dialog v-model="dialog">
    <v-container>
      <v-card>
        <v-card-title>
          <span class="headline">Lista de Tributações</span>
        </v-card-title>
        <v-data-table id="tableTributacao" :headers="header" :items="items" @click:row="selecionarTributacao"></v-data-table>
      </v-card>
    </v-container>
  </v-dialog>
</template>

<script>
export default {
  inject: ["tributacaoController"],
  data() {
    return {
      dialog: false,
      items: [],
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
    async abrir() {
      this.dialog = true;
      await this.carregarTributacoes();
    },
    selecionarTributacao(tributacao) {
      this.$emit("selecionar-tributacao", tributacao);
      this.dialog = false;
    },
    async carregar() {
      await this.carregarTributacoes();
    },
    async carregarTributacoes() {
      const res = await this.tributacaoController.getAll();
      this.items = res.data;
    },
  },
};
</script>

<style lang="scss" scoped>
#tableTributacao {
  cursor: pointer;
}
</style>
