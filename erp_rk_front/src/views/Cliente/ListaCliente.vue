<template>
  <v-card>
    <v-card-title>Cadastro de Clientes</v-card-title>
    <v-data-table
      id="tableCliente"
      :headers="headers"
      :items="clienteList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Clientes por pág.',
      }"
      @click:row="selecionarCliente"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Pesquisar"
            single-line
            hide-details
          ></v-text-field>
        </v-toolbar>
      </template>
    </v-data-table>
    <div class="d-flex flex-row-reverse container">
      <v-btn color="primary" @click="novoCliente" class="mr-2"
        >Novo Cliente</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    await this.$store.dispatch("getClientes");
  },
  methods: {
    novoCliente() {
      this.$router.push("/cadastro/cliente/novo");
    },
    selecionarCliente(cliente) {
      this.$router.push(`/cadastro/cliente/${cliente.codigo}`);
    },
  },
  computed: {
    clienteList: {
      get() {
        return this.$store.state.cliente.clienteList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Cliente", value: "nome" },
        { text: "Apelido", value: "fantasia" },
        { text: "Telefone", value: "telefone" },
        { text: "Celular", value: "celular" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableCliente {
  cursor: pointer;
}
</style>
