<template>
  <div>
    <v-row>
      <v-col cols="12" md="4">
        Cód:
        <InputNumber search-enabled @buscar="abrirTransportadoraDialog" ref="inputCodigo" :limit="14" v-model="transportadora.codigo" @blur="carregarTransportadora" />
      </v-col>
      <v-col cols="12" md="8">
        Transportadora:
        <InputText :value="transportadora.nome" disabled />
      </v-col>
    </v-row>
    <v-dialog v-model="dialogTransportadora">
      <LocalizarTransportadora ref="frmLocalizarTransportadora" @selecionar="selecionarTransportadora"></LocalizarTransportadora>
    </v-dialog>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import Fornecedor from "@/infra/entity/Fornecedor";
import LocalizarTransportadora from "./LocalizarTransportadora.vue";

export default {
  inject: ["fornecedorController"],
  components: {
    LocalizarTransportadora,
    InputNumber,
    InputText,
  },
  data() {
    return {
      transportadora: new Fornecedor(),
      dialogTransportadora: false,
    };
  },

  methods: {
    selecionarTransportadora(trans) {
      this.transportadora = trans;
      this.dialogTransportadora = false;
    },
    async abrirTransportadoraDialog() {
      this.dialogTransportadora = true;
      this.$nextTick(async () => {
        await this.$refs.frmLocalizarTransportadora.abrir();
      });
    },
    async carregarTransportadora() {
      try {
        const res = await this.fornecedorController.getTransportadoraByCodigo(this.transportadora.codigo);
        this.transportadora = res.data;
      } catch (error) {
        this.transportadora = new Fornecedor();
        this.$refs.inputCodigo.focus();
        throw error;
      }
    },

    onInput() {
      this.$emit("input", this.transportadora);
    },
  },
};
</script>

<style lang="scss" scoped></style>
