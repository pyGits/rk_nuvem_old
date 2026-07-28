<template>
  <div>
    <v-row>
      <v-col cols="12" md="2">
        Tributação:
        <InputNumber search-enabled @buscar="abrirTributacaoDialog" ref="inputCodigo" :value="value" :limit="2" @input="onInput" @blur="carregarTributacao" />
      </v-col>

      <v-col cols="12" md="10">
        Tributação:
        <InputText :value="descricao" disabled />
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
import LocalizarTributacao from "@/views/Fiscal/Tributacao/LocalizarTributacao.vue";

export default {
  inject: ["tributacaoController"],
  props: {
    value: {
      type: [String, Number],
      default: "",
    },
  },
  components: {
    LocalizarTributacao,
    InputNumber,
    InputText,
  },
  data() {
    return {
      descricao: "",
      dialogTributacao: false,
    };
  },
  watch: {
    value(novo, antigo) {
      console.log("v-model mudou de", antigo, "para", novo);
      // this.carregarTributacao();
    },
  },
  methods: {
    teste() {
      console.log("teste selecctor tribu");
    },
    selecionarTributacao(trb) {
      this.onInput(trb.codigo);
      this.descricao = trb.nome;
      this.dialogTributacao = false;
    },
    abrirTributacaoDialog() {
      this.dialogTributacao = true;
    },
    async carregarTributacao() {
      if (this.value !== "") {
        try {
          const res = await this.tributacaoController.getByCodigo(this.value);
          const trb = res.data;
          this.onInput(trb.codigo);
          this.descricao = trb.nome;
        } catch (error) {
          this.onInput("");
          this.descricao = "";
          this.$refs.inputCodigo.focus();
          throw error;
        }
      }
    },
    onInput(novoValor) {
      console.log("aaaaa");
      this.$emit("input", novoValor); // permite v-model funcionar
    },
  },
};
</script>

<style lang="scss" scoped></style>
