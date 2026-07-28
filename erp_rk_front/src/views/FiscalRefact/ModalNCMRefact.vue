<template>
  <v-container>
    <v-card>
      <v-card-title>
        <span class="headline">Lista de NCMS</span>
      </v-card-title>

      <v-text-field
        v-model="search"
        label="Pesquisar"
        clearable
      ></v-text-field>

      <v-data-table
        id="tableNCM"
        :headers="header"
        :items="filteredItems"
        @click:row="selectNCM"
      ></v-data-table>
    </v-card>
  </v-container>
</template>

<script>
import NCM from '@/infra/entity/NCM';

export default {
  data() {
    return {
      search: '',
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
  computed: {
    filteredItems() {
      // Se o campo estiver vazio, retorna todos os itens
      if (!this.search) {
        return NCM.list();
      }

      return NCM.filter(this.search);
    },
  },
  methods: {
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
