<template>
  <v-card>
    <v-card-title>Cadastro de Funcionarios</v-card-title>
    <v-data-table
      id="tableFuncionario"
      :headers="headers"
      :items="funcionarioList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Funcionarios por pág.',
      }"
      @click:row="selecionarFuncionario"
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
      <v-btn color="primary" @click="novoFuncionario" class="mr-2"
        >Novo Funcionario</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    await this.$store.dispatch("getFuncionarios");
  },
  methods: {
    novoFuncionario() {
      this.$router.push("/usuarios/funcionario/novo");
    },
    selecionarFuncionario(funcionario) {
      this.$router.push(`/usuarios/funcionario/${funcionario.codigo}`);
    },
  },
  computed: {
    funcionarioList: {
      get() {
        return this.$store.state.funcionario.funcionarioList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Funcionario", value: "nome" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableFuncionario {
  cursor: pointer;
}
</style>
