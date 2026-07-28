<template>
  <v-dialog v-model="showLocalDialog">
    <v-card>
      <v-card-title>
        <span class="headline">Lista de Fornecedores</span>
      </v-card-title>
      <v-text-field v-model="search" label="Pesquisar"></v-text-field>
      <v-data-table id="tableFornecedor" :headers="header" :items="filteredFornecedorList" @click:row="selectFornecedor"></v-data-table>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  methods: {
    selectFornecedor(fornecedor) {
      this.$store.commit("setFornecedor", fornecedor);
      this.showLocalDialog = false;
    },
  },
  computed: {
    fornecedorList() {
      return this.$store.state.fornecedor.fornecedorList;
    },
    filteredFornecedorList() {
      if (!this.search) {
        return this.fornecedorList;
      }
      const searchTerm = this.search.toLowerCase();
      return this.fornecedorList.filter((fornecedor) => {
        return fornecedor.codigo.toLowerCase().includes(searchTerm) || fornecedor.cnpjcpf.toLowerCase().includes(searchTerm) || fornecedor.nome.toLowerCase().includes(searchTerm);
      });
    },
    showLocalDialog: {
      get() {
        return this.$store.state.Application.dialogFornecedor;
      },
      set(valor) {
        this.$store.commit("setDialogFornecedor", valor);
      },
    },
  },
  watch: {
    async showLocalDialog(newValue, oldValue) {
      if (newValue) {
        await this.$store.dispatch("getFornecedors");
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
#tableFornecedor {
  cursor: pointer;
}
</style>
