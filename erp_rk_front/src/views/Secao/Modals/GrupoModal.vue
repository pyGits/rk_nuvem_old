<template>
  <v-dialog v-model="localDialog" content-class="my-dialog">
    <v-card>
      <v-card-title>
        <span class="headline">Grupos</span>
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
          <v-col cols="12" sm="6">
            <label class="form-label" for="input-example">Nome do Grupo:</label>
            <input
              v-model="nome"
              type="text"
              class="form-control"
              placeholder="Nome do Grupo"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <label class="form-label" for="input-example">Markup:</label>
            <input
              v-model="markup"
              type="text"
              class="form-control"
              placeholder="Markup do Grupo"
            />
          </v-col> </v-row
      ></v-card-text>

      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="gravarGrupo">Gravar</v-btn>
      </v-card-actions>
    </v-card>
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
    async gravarGrupo() {
      this.localDialog = false;
      await this.$store.dispatch("gravarGrupo", this.mode);
      await this.$store.dispatch(
        "getGrupos",
        this.$store.state.grupo.grupo.secao
      );
    },
  },
  computed: {
    localDialog: {
      get() {
        return this.dialog;
      },
      set(valor) {
        this.$emit("updateDialog", valor);
      },
    },
    markup: {
      get() {
        return maskAmount(this.$store.state.grupo.grupo.margem);
      },
      set(valor) {
        this.$store.commit("setGrupoMargem", maskMoneyToFloat(valor));
      },
    },
    codigo: {
      get() {
        return this.$store.state.grupo.grupo.codigo;
      },
      set(valor) {
        this.$store.commit("setGrupoCodigo", valor);
      },
    },
    nome: {
      get() {
        return this.$store.state.grupo.grupo.nome;
      },
      set(valor) {
        this.$store.commit("setGrupoNome", valor);
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
