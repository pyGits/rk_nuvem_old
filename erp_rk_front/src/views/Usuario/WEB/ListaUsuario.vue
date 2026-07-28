<template>
  <v-card>
    <v-card-title>Cadastro de Usuarios</v-card-title>
    <v-data-table
      id="tableUsuario"
      :headers="headers"
      :items="usuarioList"
      :search="search"
      :footer-props="{
        'items-per-page-text': 'Usuarios por pág.',
      }"
      @click:row="selecionarUsuario"
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
      <v-btn color="primary" @click="novoUsuario" class="mr-2"
        >Novo Usuario</v-btn
      >
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getUsuarios");
    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    novoUsuario() {
      this.$router.push("/usuarios/usuariosweb/novo");
    },
    selecionarUsuario(usuario) {
      this.$router.push(`/usuarios/usuariosweb/${usuario.codigo}`);
    },
  },
  computed: {
    usuarioList: {
      get() {
        return this.$store.state.usuario.usuarioList;
      },
    },
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Usuario", value: "user" },
      ],
      search: "",
    };
  },
};
</script>

<style lang="scss" scoped>
#tableUsuario {
  cursor: pointer;
}
</style>
