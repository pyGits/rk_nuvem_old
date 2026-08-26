<template>
  <v-card>
    <v-card-title class="d-flex justify-space-between align-center">
      <span>Localizar Cliente</span>
      <v-btn icon small @click="fechar">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </v-card-title>

    <v-card-text>
      <v-text-field v-model="busca" label="Pesquisar por código, nome ou CPF/CNPJ" prepend-inner-icon="mdi-magnify" outlined dense clearable autofocus hide-details class="mb-4"></v-text-field>

      <v-data-table :headers="headers" :items="clientesFiltrados" :items-per-page="10" dense class="elevation-1 linha-clicavel" @click:row="selecionar">
        <template v-slot:no-data>
          <span class="grey--text">Nenhum cliente encontrado</span>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
</template>

<script>
// Localizador de cliente reaproveitável (filtros e lançamento de contas a
// receber). A lista vem do store que já existe — nenhuma chamada nova à API.
export default {
  name: "LocalizarCliente",
  data() {
    return {
      busca: "",
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Cliente", value: "nome" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
      ],
    };
  },
  computed: {
    clienteList() {
      return this.$store.state.cliente.clienteList || [];
    },
    clientesFiltrados() {
      if (!this.busca) return this.clienteList;
      const termo = String(this.busca).toLowerCase();
      return this.clienteList.filter((cliente) => `${cliente.codigo} ${cliente.nome || ""} ${cliente.cnpjcpf || ""}`.toLowerCase().includes(termo));
    },
  },
  async mounted() {
    if (!this.clienteList.length) await this.$store.dispatch("getClientes");
  },
  methods: {
    selecionar(cliente) {
      this.$emit("selecionar", cliente);
    },
    fechar() {
      this.$emit("fechar");
    },
  },
};
</script>

<style scoped>
.linha-clicavel >>> tbody tr {
  cursor: pointer;
}
</style>
