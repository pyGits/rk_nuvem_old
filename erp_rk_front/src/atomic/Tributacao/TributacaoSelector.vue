<template>
  <div>
    <v-row>
      <v-col cols="12" md="2">
        Tributação:
        <InputNumber search-enabled @buscar="abrirTributacaoDialog" ref="inputCodigo" :limit="14" v-model="tributacao.codigo" @blur="carregarTributacao" />
      </v-col>
      <v-col cols="12" md="8">
        Tributacao:
        <InputText :value="tributacao.nome" disabled />
      </v-col>
    </v-row>
    <v-dialog v-model="dialogTributacao">
      <LocalizarTributacao @selecionar="selecionarTributacao"></LocalizarTributacao>
    </v-dialog>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import Tributacao from "@/infra/entity/Tributacao";
import LocalizarTributacao from "@/views/Fiscal/Tributacao/LocalizarTributacao.vue";

export default {
  inject: ["tributacaoController"],
  components: {
    LocalizarTributacao,
    InputNumber,
    InputText,
  },
  data() {
    return {
      tributacao: new Tributacao(),
      dialogTributacao: false,
    };
  },
  methods: {
    selecionarTributacao(prod) {
      this.tributacao = prod;
      this.dialogTributacao = false;
    },
    abrirTributacaoDialog() {
      this.dialogTributacao = true;
    },
    async carregarTributacao() {
      try {
        const res = await this.tributacaoController.getByCodigo(this.tributacao.codigo);
        this.tributacao = res.data;
      } catch (error) {
        this.tributacao = new Tributacao();
        this.$refs.inputCodigo.focus();
        throw error;
      }
    },

    onInput() {
      this.$emit("input", this.tributacao);
    },
  },
};
</script>

<style lang="scss" scoped></style>
