<template>
  <div>
    <v-card>
      <v-card-title> Cadastrar Sub-Categoria Financeira </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="2">
            <span>Código</span>
            <InputText disabled v-model="subCategoriaFinanceiraira.codigo"></InputText>
          </v-col>
          <v-col cols="12" sm="6">
            <span>Nome</span>
            <InputText v-model="subCategoriaFinanceiraira.nome" upper-case :limit="80"></InputText>
          </v-col>
          <v-col cols="12" sm="4">
            <span>Tipo</span>
            <v-radio-group v-model="subCategoriaFinanceiraira.tipo" row dense class="mt-1">
              <v-radio label="Despesa" value="DESPESA"></v-radio>
              <v-radio label="Receita" value="RECEITA"></v-radio>
            </v-radio-group>
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
import SubCategoriaFinanceira from "@/infra/entity/SubCategoriaFinanceira";
import SubCategoriaFinanceiraService from "@/infra/service/SubCategoriaFinanceiraService";

export default {
  components: {
    InputText,
  },
  methods: {
    async gravar() {
      if (this.isInserting()) await SubCategoriaFinanceiraService.insert(this.subCategoriaFinanceiraira);
      if (!this.isInserting()) await SubCategoriaFinanceiraService.update(this.subCategoriaFinanceiraira);

      this.$emit("gravar");
    },
    abrir(categoria) {
      this.subCategoriaFinanceiraira = new SubCategoriaFinanceira(categoria.codigo, categoria.codigo_categoria, categoria.nome, categoria.tipo);
    },
    isInserting() {
      return this.subCategoriaFinanceiraira.codigo.trim() === "";
    },
  },
  data() {
    return {
      subCategoriaFinanceiraira: new SubCategoriaFinanceira(),
    };
  },
};
</script>

<style lang="scss" scoped></style>
