<template>
  <v-container>
    <v-dialog v-model="localDialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Lista de NCMS</span>
        </v-card-title>
        <v-text-field v-model="search" label="Pesquisar" hint="Digite ao menos 2 caracteres do código ou da descrição" persistent-hint></v-text-field>
        <v-data-table
          id="tableNCM"
          :headers="header"
          :items="NCMs"
          :loading="carregando"
          @click:row="selectNCM"
        >
          <template v-slot:no-data>
            <span class="grey--text">{{ search.length >= 2 ? "Nenhum NCM encontrado." : "Digite para pesquisar." }}</span>
          </template>
        </v-data-table>
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
  },
  methods: {
    async pesquisar(termo) {
      this.carregando = true;
      try {
        await this.$store.dispatch("buscarNCM", termo);
      } finally {
        this.carregando = false;
      }
    },
    selectNCM(ncm) {
      this.$store.commit("setTributacaoNCM", ncm);
      this.localDialog = false;
    },
  },
  watch: {
    localDialog: function (newValue) {
      if (newValue) {
        this.search = "";
        this.$store.commit("setNCMList", []);
      }
    },
    // A tabela tem 12 mil NCM: quem filtra e o servidor. O atraso evita uma
    // consulta por tecla digitada.
    search: function (termo) {
      clearTimeout(this.debounce);
      this.debounce = setTimeout(() => this.pesquisar(termo), 350);
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
      carregando: false,
      debounce: null,
    };
  },
};
</script>

<style lang="scss" scoped>
#tableNCM {
  cursor: pointer;
}
</style>
