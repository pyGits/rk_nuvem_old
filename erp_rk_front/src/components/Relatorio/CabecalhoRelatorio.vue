<template>
  <div class="cabecalho-relatorio px-6 py-4">
    <div class="d-flex align-center flex-wrap">
      <v-icon large color="primary" class="mr-3">{{ icone }}</v-icon>
      <div class="mr-4">
        <h2 class="text-h5 font-weight-medium mb-0">{{ titulo }}</h2>
        <span v-if="subtitulo" class="text-caption grey--text text--darken-1">{{ subtitulo }}</span>
      </div>
      <v-spacer></v-spacer>

      <slot name="acoes"></slot>

      <v-btn v-if="mostrarAtualizar" color="primary" depressed class="mr-2" :loading="carregando" @click="$emit('atualizar')">
        <v-icon left>mdi-refresh</v-icon>
        {{ textoAtualizar }}
      </v-btn>
      <v-btn v-if="mostrarExportar" color="green darken-1" outlined :disabled="carregando || semDados" @click="$emit('exportar')">
        <v-icon left>mdi-file-excel-outline</v-icon>
        Excel
      </v-btn>
    </div>
  </div>
</template>

<script>
// Cabeçalho padrão das telas de relatório: título, contexto do filtro aplicado
// e as ações de atualizar/exportar sempre no mesmo lugar.
export default {
  name: "CabecalhoRelatorio",
  props: {
    titulo: { type: String, required: true },
    subtitulo: { type: String, default: "" },
    icone: { type: String, default: "mdi-chart-box-outline" },
    carregando: { type: Boolean, default: false },
    semDados: { type: Boolean, default: false },
    textoAtualizar: { type: String, default: "Atualizar" },
    mostrarAtualizar: { type: Boolean, default: true },
    mostrarExportar: { type: Boolean, default: true },
  },
};
</script>

<style scoped>
.cabecalho-relatorio {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
</style>
