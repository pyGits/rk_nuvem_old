<template>
  <v-dialog v-model="localDialog" content-class="my-dialog">
    <v-card>
      <v-card-title>
        <span class="headline">Seção</span>
      </v-card-title>

      <v-card-text>
        <v-row>
          <v-col cols="12" sm="2">
            <label class="form-label" for="input-example">Codigo:</label>
            <input
              :disabled="mode === 'UPDATE'"
              v-model="codigo"
              type="text"
              class="form-control"
              placeholder="Código Seção"
            />
          </v-col>
          <v-col cols="12" sm="8">
            <label class="form-label" for="input-example">Nome da Seção:</label>
            <input
              v-model="nome"
              type="text"
              class="form-control"
              placeholder="Nome da Seção"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <label class="form-label" for="input-example">Margem:</label>
            <input
              v-model="margem"
              type="text"
              class="form-control"
              placeholder="Margem da Seção"
            />
          </v-col> </v-row
      ></v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="gravarSecao">Gravar</v-btn>
      </v-card-actions>
    </v-card>
    <v-overlay :value="showSpinner">
      <v-progress-circular indeterminate color="primary"></v-progress-circular>
    </v-overlay>
  </v-dialog>
</template>

<script>
import { maskAmount, maskMoneyToFloat } from "@/utils/masks";

export default {
  props: {
    dialog: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    async gravarSecao() {
      this.localDialog = false;
      await this.$store.dispatch("gravarSecao", this.mode);
      await this.$store.dispatch("getSecoes");
    },
  },
  computed: {
    showSpinner: {
      get() {
        return this.$store.state.Application.containerLoading;
      },
    },
    localDialog: {
      get() {
        return this.dialog;
      },
      set(valor) {
        this.$emit("updateDialog", valor);
      },
    },
    codigo: {
      get() {
        return this.$store.state.secao.secao.codigo;
      },
      set(valor) {
        this.$store.commit("setSecaoCodigo", valor);
      },
    },
    nome: {
      get() {
        return this.$store.state.secao.secao.nome;
      },
      set(valor) {
        this.$store.commit("setSecaoNome", valor);
      },
    },
    margem: {
      get() {
        return maskAmount(this.$store.state.secao.secao.margem);
      },
      set(valor) {
        this.$store.commit("setSecaoMargem", maskMoneyToFloat(valor));
      },
    },
    mode: {
      get() {
        return this.$store.state.Application.mode;
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
