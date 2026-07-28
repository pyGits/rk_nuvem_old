<template>
  <v-container>
    <v-dialog v-model="localDialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Lista de NCMS</span>
        </v-card-title>
        <v-text-field v-model="search" label="Pesquisar"></v-text-field>
        <v-data-table
          id="tableNCM"
          :headers="header"
          :items="filteredNCMs"
          @click:row="selectNCM"
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
        return this.$store.state.Application.dialogNCM;
      },
      set(valor) {
        this.$store.commit("setDialogNCM", valor);
      },
    },
    NCMs: {
      get() {
        return this.$store.state.tributacao.ncm.ncmList;
      },
    },
    filteredNCMs() {
      // Filtra os NCMs de acordo com o que o usuário digitar no campo de pesquisa
      return this.NCMs.filter((NCM) => {
        const codigoSemPonto = NCM.Codigo.replace(/\./g, "");
        return (
          codigoSemPonto.toLowerCase().includes(this.search.toLowerCase()) ||
          NCM.Descricao.toLowerCase().includes(this.search.toLowerCase())
        );
      });
    },
  },
  methods: {
    selectNCM(ncm) {
      this.$store.commit("setTributacaoNCM", ncm);
      this.localDialog = false;
    },
  },
  watch: {
    localDialog: function (newValue, oldValue) {
      if (newValue) {
        this.$store.dispatch("getNCM", "00000000");
      }
    },
  },
  data() {
    return {
      header: [
        {
          text: "Código",
          value: "Codigo",
        },
        {
          text: "Nome",
          value: "Descricao",
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
