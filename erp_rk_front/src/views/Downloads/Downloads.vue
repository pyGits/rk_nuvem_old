<template>
  <v-card flat>
    <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
      <v-icon large color="primary" class="mr-3">mdi-cloud-download-outline</v-icon>
      <div class="mr-4">
        <h2 class="text-h5 font-weight-medium mb-0">Downloads</h2>
        <span class="text-caption grey--text text--darken-1">
          Instaladores e utilitários do RK Nuvem
        </span>
      </div>
      <v-spacer></v-spacer>
      <v-btn color="primary" depressed :loading="carregando" @click="carregar">
        <v-icon left>mdi-refresh</v-icon>
        Atualizar
      </v-btn>
    </div>

    <div v-if="carregando && !downloads.length" class="py-12 text-center">
      <v-progress-circular indeterminate color="primary"></v-progress-circular>
    </div>

    <div v-else-if="!downloads.length" class="text-center py-12 grey--text">
      <v-icon size="56" color="grey lighten-1">mdi-package-variant</v-icon>
      <p class="mt-3 mb-0">Nenhum arquivo disponível no momento.</p>
    </div>

    <v-row v-else class="pa-4" dense>
      <v-col v-for="item in downloads" :key="item.id" cols="12" sm="6" md="4">
        <v-card outlined class="h-100 d-flex flex-column">
          <v-card-title class="text-subtitle-1 font-weight-medium">
            <v-icon color="primary" class="mr-2">mdi-folder-zip-outline</v-icon>
            {{ item.titulo }}
          </v-card-title>

          <v-card-subtitle v-if="item.versao" class="pb-0">
            <v-chip x-small label outlined>versão {{ item.versao }}</v-chip>
          </v-card-subtitle>

          <v-card-text class="flex-grow-1">
            <p v-if="item.descricao" class="mb-2">{{ item.descricao }}</p>
            <div class="text-caption grey--text text--darken-1">
              {{ formataTamanho(item.tamanho) }} · atualizado em
              {{ formataData(item.updated_at) }}
            </div>
          </v-card-text>

          <v-card-actions>
            <v-btn
              color="primary"
              text
              :loading="baixandoId === item.id"
              @click="baixar(item)"
            >
              <v-icon left>mdi-download</v-icon>
              Download
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      carregando: false,
      baixandoId: null,
    };
  },
  computed: {
    downloads() {
      return this.$store.state.download.downloadList;
    },
  },
  async mounted() {
    await this.carregar();
  },
  methods: {
    async carregar() {
      this.carregando = true;
      await this.$store.dispatch("getDownloads");
      this.carregando = false;
    },
    async baixar(item) {
      this.baixandoId = item.id;
      await this.$store.dispatch("baixarDownload", item);
      this.baixandoId = null;
    },
    formataTamanho(bytes) {
      const valor = Number(bytes) || 0;
      if (valor < 1024) return `${valor} B`;
      if (valor < 1024 * 1024) return `${(valor / 1024).toFixed(1)} KB`;
      if (valor < 1024 * 1024 * 1024) return `${(valor / 1024 / 1024).toFixed(1)} MB`;
      return `${(valor / 1024 / 1024 / 1024).toFixed(2)} GB`;
    },
    formataData(data) {
      if (!data) return "-";
      return new Date(data).toLocaleDateString("pt-BR");
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

.h-100 {
  height: 100%;
}
</style>
