<template>
  <div>
    <v-row>
      <v-col cols="12" md="4">
        Cód Barras:
        <InputNumber search-enabled @buscar="abrirProdutoDialog" ref="inputCodigo" :limit="14" v-model="produto.codigo_barras" @blur="carregarProduto" />
      </v-col>
      <v-col cols="12" md="8">
        Produto:
        <InputText :value="produto.descricao" disabled />
      </v-col>
    </v-row>
    <v-dialog v-model="dialogProduto">
      <LocalizarProduto @selecionar="selecionarProduto"></LocalizarProduto>
    </v-dialog>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import Produto from "@/infra/entity/Produto";
import LocalizarProduto from "@/views/ProdutoRefact/LocalizarProduto.vue";

export default {
  inject: ["produtoController"],
  components: {
    LocalizarProduto,
    InputNumber,
    InputText,
  },
  data() {
    return {
      produto: new Produto(),
      dialogProduto: false,
    };
  },

  methods: {
    selecionarProduto(prod) {
      this.produto = prod;
      this.dialogProduto = false;
    },
    abrirProdutoDialog() {
      this.dialogProduto = true;
    },
    async carregarProduto() {
      try {
        const res = await this.produtoController.getByCodigo(this.produto.codigo_barras);
        this.produto = res.data;
      } catch (error) {
        this.produto = new Produto();
        this.$refs.inputCodigo.focus();
        throw error;
      }
    },

    onInput() {
      this.$emit("input", this.produto);
    },
  },
};
</script>

<style lang="scss" scoped></style>
