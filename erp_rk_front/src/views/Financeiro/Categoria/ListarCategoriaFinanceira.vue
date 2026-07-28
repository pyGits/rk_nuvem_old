<template>
  <v-card>
    <v-card-title>Categoria Financeira</v-card-title>
    <v-row>
      <v-col cols="6">
        <v-card-title>Categoria</v-card-title>
        <v-data-table id="tableSecao" :headers="categoriaHeaders" :items="categorias" item-key="id" @click:row="selecionarCategoria">
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon @click.stop="editarCategoriaFinanceira(item)">mdi-pencil</v-icon>
            <v-icon @click.stop="deletarCategoriaFinanceira(item)">mdi-delete</v-icon>
          </template>
        </v-data-table>
        <v-btn @click="novaCategoria">Nova Categoria</v-btn>
      </v-col>
      <v-col cols="6">
        <v-card-title>{{ categoria.nome }}</v-card-title>
        <v-data-table :headers="subCategoriaHeaders" :items="subcategorias">
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon @click.stop="editarSubCategoriaFinanceira(item)">mdi-pencil</v-icon>
            <v-icon @click.stop="deletarSubCategoriaFinanceira(item)">mdi-delete</v-icon>
          </template>
        </v-data-table>
        <v-btn @click="novaSubCategoria">Nova Sub-Categoria</v-btn>
      </v-col>
    </v-row>

    <v-dialog v-model="modalCategoriaFinanceira">
      <CadastrarCategoriaFinanceira ref="categoriaFinanceira" @gravar="gravarCategoria"></CadastrarCategoriaFinanceira>
    </v-dialog>
    <v-dialog v-model="modalSubCategoriaFinanceira">
      <CadastrarSubCategoriaFinanceira ref="subCategoriaFinanceira" @gravar="gravarSubCategoria"></CadastrarSubCategoriaFinanceira>
    </v-dialog>
  </v-card>
</template>

<script>
import CategoriaFinanceiraService from "@/infra/service/CategoriaFinanceiraService";
import CadastrarCategoriaFinanceira from "./CadastrarCategoriaFinanceira.vue";
import CategoriaFinanceira from "@/infra/entity/CategoriaFinanceira";
import SubCategoriaFinanceira from "@/infra/entity/SubCategoriaFinanceira";
import SubCategoriaFinanceiraService from "@/infra/service/SubCategoriaFinanceiraService";
import CadastrarSubCategoriaFinanceira from "./CadastrarSubCategoriaFinanceira.vue";

export default {
  async mounted() {
    await this.carregar();
  },

  data() {
    return {
      categoriaHeaders: [
        { text: "Cód", value: "codigo" },
        { text: "Categoria", value: "nome" },
        { text: "Ações", value: "actions", sortable: false },
      ],
      subCategoriaHeaders: [
        { text: "Cód", value: "codigo" },
        { text: "Sub-Categoria", value: "nome" },
        { text: "Ações", value: "actions", sortable: false },
      ],
      categorias: [],
      subcategorias: [],
      categoria: new CategoriaFinanceira(),
      modalCategoriaFinanceira: false,
      modalSubCategoriaFinanceira: false,
    };
  },
  methods: {
    novaCategoria() {
      this.modalCategoriaFinanceira = true;
      this.$nextTick(() => {
        this.$refs.categoriaFinanceira.abrir(new CategoriaFinanceira());
      });
    },
    novaSubCategoria() {
      if (this.categoria.codigo.trim() === "") throw new Error("Selecione a Categoria primeiro");
      this.modalSubCategoriaFinanceira = true;
      this.$nextTick(() => {
        this.$refs.subCategoriaFinanceira.abrir(new SubCategoriaFinanceira("", this.categoria.codigo, ""));
      });
    },

    async gravarCategoria() {
      this.modalCategoriaFinanceira = false;
      await this.carregar();
    },
    async gravarSubCategoria() {
      this.modalSubCategoriaFinanceira = false;
      this.subcategorias = await SubCategoriaFinanceiraService.getAllByCategoria(this.categoria.codigo);
    },

    editarCategoriaFinanceira(categoria) {
      this.modalCategoriaFinanceira = true;
      this.$nextTick(() => {
        this.$refs.categoriaFinanceira.abrir(categoria);
      });
    },
    editarSubCategoriaFinanceira(subcategoria) {
      this.modalSubCategoriaFinanceira = true;
      this.$nextTick(() => {
        this.$refs.subCategoriaFinanceira.abrir(subcategoria);
      });
    },
    async deletarCategoriaFinanceira(categoria) {
      await CategoriaFinanceiraService.delete(categoria);
      await this.carregar();
    },
    async deletarSubCategoriaFinanceira(subCategoria) {
      await SubCategoriaFinanceiraService.delete(subCategoria);
      this.subcategorias = await SubCategoriaFinanceiraService.getAllByCategoria(this.categoria.codigo);
    },

    async selecionarCategoria(categoria) {
      this.categoria = categoria;
      this.subcategorias = await SubCategoriaFinanceiraService.getAllByCategoria(this.categoria.codigo);
    },
    async carregar() {
      this.categorias = await CategoriaFinanceiraService.getAll();
      this.subcategorias = [];
      this.categoria = new CategoriaFinanceira();
    },
  },
  components: {
    CadastrarCategoriaFinanceira,
    CadastrarSubCategoriaFinanceira,
  },
};
</script>

<style lang="scss" scoped></style>
