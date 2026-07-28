<template>
  <div>
    <v-card>
      <v-card-title> Cadastrar Categoria Financeira </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="2">
            <span>Código</span>
            <InputText disabled v-model="categoriaFinanceira.codigo"></InputText>
          </v-col>
          <v-col cols="12" sm="10">
            <span>Nome</span>
            <InputText v-model="categoriaFinanceira.nome" upper-case :limit="80"></InputText>
          </v-col>
        </v-row>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="gravar">Gravar</v-btn>
        </v-card-actions>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import InputText from "@/components/Input/InputText.vue";
import CategoriaFinanceira from "@/infra/entity/CategoriaFinanceira";
import CategoriaFinanceiraService from "@/infra/service/CategoriaFinanceiraService";

export default {
  components: {
    InputText,
  },
  methods: {
    async gravar() {
      if (this.isInserting()) await CategoriaFinanceiraService.insert(this.categoriaFinanceira);
      if (!this.isInserting()) await CategoriaFinanceiraService.update(this.categoriaFinanceira);

      this.$emit("gravar");
    },
    abrir(categoria) {
      this.categoriaFinanceira = new CategoriaFinanceira(categoria.codigo, categoria.nome);
    },
    isInserting() {
      return this.categoriaFinanceira.codigo.trim() === "";
    },
  },
  data() {
    return {
      categoriaFinanceira: new CategoriaFinanceira(),
    };
  },
};
</script>

<style lang="scss" scoped></style>
