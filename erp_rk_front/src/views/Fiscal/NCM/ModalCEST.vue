<template>
  <v-container>
    <v-dialog v-model="localDialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Lista de CESTs</span>
        </v-card-title>
        <v-data-table
          id="tableCEST"
          :headers="header"
          :items="items"
          @click:row="selectCEST"
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
          text: "CEST",
          value: "CEST",
        },
        {
          text: "NCM",
          value: "NCM",
        },
        { text: "CEST", value: "DESCRICAO" },
      ],
    };
  },
  methods: {
    selectCEST(cest) {
      this.$store.commit("setTributacaoCEST", cest);
      this.localDialog = false;
    },
  },
  computed: {
    localDialog: {
      get() {
        return this.$store.state.Application.dialogCEST;
      },
      set(valor) {
        this.$store.commit("setDialogCEST", valor);
      },
    },
    items: {
      get() {
        return this.$store.state.tributacao.cest.cestList;
      },
    },
  },
  watch: {
    localDialog(val) {
      this.$store.dispatch("getCESTList");
    },
  },
};
</script>

<style lang="scss" scoped>
#tableCEST {
  cursor: pointer;
}
</style>
