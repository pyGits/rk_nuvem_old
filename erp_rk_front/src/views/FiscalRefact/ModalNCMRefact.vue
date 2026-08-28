<template>
  <v-container>
    <v-card>
      <v-card-title>
        <span class="headline">Lista de NCMS</span>
      </v-card-title>

      <v-text-field
        v-model="search"
        label="Pesquisar"
        hint="Digite ao menos 2 caracteres do código ou da descrição"
        persistent-hint
        clearable
      ></v-text-field>

      <v-data-table
        id="tableNCM"
        :headers="header"
        :items="itens"
        :loading="carregando"
        @click:row="selectNCM"
      >
        <template v-slot:no-data>
          <span class="grey--text">{{ (search || "").length >= 2 ? "Nenhum NCM encontrado." : "Digite para pesquisar." }}</span>
        </template>
      </v-data-table>
    </v-card>
  </v-container>
</template>

<script>
import NCM from '@/infra/entity/NCM';

export default {
  data() {
    return {
      search: '',
      itens: [],
      carregando: false,
      debounce: null,
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
    };
  },
  watch: {
    // São 12 mil NCM: quem filtra é o servidor, com um atraso para não
    // consultar a cada tecla.
    search(termo) {
      clearTimeout(this.debounce);
      this.debounce = setTimeout(() => this.pesquisar(termo), 350);
    },
  },
  methods: {
    async pesquisar(termo) {
      this.carregando = true;
      try {
        this.itens = await NCM.filter(termo || '');
      } finally {
        this.carregando = false;
      }
    },
    selectNCM(ncm) {
      this.$emit('selecionar-ncm', ncm);
    },
  },
};
</script>

<style lang="scss" scoped>
#tableNCM {
  cursor: pointer;
}
</style>
