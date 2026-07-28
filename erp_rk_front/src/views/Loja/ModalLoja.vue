<template>
  <v-dialog v-model="showLocalDialog">
    <v-card>
      <v-card-title>
        <span class="headline">Lista de Lojas</span>
      </v-card-title>
      <v-text-field v-model="search" label="Pesquisar"></v-text-field>
      <v-data-table
        id="tableLoja"
        :headers="header"
        :items="filteredLojas"
        @click:row="selectLoja"
      ></v-data-table>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  methods: {
    selectLoja(loja) {
      this.$store.commit("setLoja", loja);
      this.showLocalDialog = false;
    },
  },
  computed: {
    lojaList() {
      return this.$store.state.loja.lojaList;
    },
    filteredLojas() {
      if (!this.search) {
        return this.lojaList;
      }
      const searchTerm = this.search.toLowerCase();
      return this.lojaList.filter((loja) => {
        return (
          loja.codigo.toLowerCase().includes(searchTerm) ||
          loja.cnpjcpf.toLowerCase().includes(searchTerm) ||
          loja.nome.toLowerCase().includes(searchTerm)
        );
      });
    },
    showLocalDialog: {
      get() {
        return this.$store.state.Application.dialogLoja;
      },
      set(valor) {
        this.$store.commit("setDialogLoja", valor);
      },
    },
  },
  watch: {
    async showLocalDialog(newValue, oldValue) {
      if (newValue) {
        await this.$store.dispatch("getLojas");
      }
    },
  },
  data() {
    return {
      search: "", // Adicionado o valor inicial do campo de pesquisa
      header: [
        {
          text: "Código",
          value: "codigo",
        },
        {
          text: "CNPJ/CPF",
          value: "cnpjcpf",
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
#tableLoja {
  cursor: pointer;
}
</style>
