<template>
  <v-container>
    <v-dialog v-model="localDialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Lista de Impostos Federais</span>
        </v-card-title>
        <v-text-field v-model="search" label="Pesquisar"></v-text-field>
        <v-data-table
          id="tableFed"
          :headers="header"
          :items="federaisList"
          @click:row="selectFed"
        ></v-data-table>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  computed: {
    localDialog: {
      get() {
        return this.$store.state.Application.dialogFederal;
      },
      set(valor) {
        this.$store.commit("setDialogFederal", valor);
      },
    },
    federaisList: {
      get() {
        return this.$store.state.impfederal.impfederalList;
      },
    },
  },
  methods: {
    selectFed(fed) {
      this.$store.commit("setProdutoImpFederal", fed.codigo);
      this.$store.commit("setImpFederal", fed);
      this.localDialog = false;
    },
  },
  watch: {
    localDialog: function (newValue, oldValue) {
      if (newValue) {
        this.$store.dispatch("getImpFederais");
      }
    },
  },
  data() {
    return {
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
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableNCM {
  cursor: pointer;
}
</style>
