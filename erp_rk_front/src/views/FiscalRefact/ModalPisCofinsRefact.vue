<template>
  <v-container>
    <v-card>
      <v-card-title>
        <span class="headline">Lista de Impostos Federais</span>
      </v-card-title>
      <v-text-field v-model="search" label="Pesquisar"></v-text-field>
      <v-data-table id="tableFed" :headers="header" :items="federaisList" @click:row="selectFed"></v-data-table>
    </v-card>
  </v-container>
</template>

<script>
export default {
  inject: ["impostosFederaisController"],
  methods: {
    async carregar() {
      const res = await this.impostosFederaisController.getAll();
      this.federaisList = res.data;
    },
    selectFed(federal) {
      this.$emit("selecionar-impostosfederais", federal);
    },
  },

  data() {
    return {
      search: "",
      federaisList: [],
      header: [
        {
          text: "Código",
          value: "codigo",
        },
        {
          text: "Nome",
          value: "nome",
        },
      ],
    };
  },
};
</script>

<style lang="scss" scoped>
#tableNCM {
  cursor: pointer;
}
</style>
