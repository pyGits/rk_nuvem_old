<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="primary" class="mr-3">mdi-message-text-outline</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Feedbacks</h2>
          <span class="text-caption grey--text text--darken-1">
            Sugestões e avaliações enviadas pelos clientes
          </span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" outlined :loading="carregando" @click="carregar">
          <v-icon left>mdi-refresh</v-icon>
          Atualizar
        </v-btn>
      </div>

      <div v-if="!carregando && !feedbacks.length" class="text-center py-12 grey--text">
        <v-icon size="56" color="grey lighten-1">mdi-message-outline</v-icon>
        <p class="mt-3 mb-0">Nenhum feedback recebido ainda.</p>
      </div>

      <v-list v-else two-line>
        <template v-for="(item, index) in feedbacks">
          <v-list-item :key="item.id" :class="{ 'feedback-lido': item.lido }">
            <v-list-item-icon>
              <v-icon :color="item.lido ? 'grey' : 'primary'">
                {{ item.lido ? "mdi-email-open-outline" : "mdi-email-outline" }}
              </v-icon>
            </v-list-item-icon>

            <v-list-item-content>
              <v-list-item-title class="d-flex align-center flex-wrap">
                <span class="font-weight-medium mr-2">{{ item.tenant_nome || "Cliente" }}</span>
                <v-rating
                  v-if="item.nota"
                  :value="item.nota"
                  readonly
                  dense
                  size="16"
                  color="amber"
                  background-color="grey lighten-1"
                  class="mr-2"
                ></v-rating>
                <span class="text-caption grey--text">{{ formataData(item.created_at) }}</span>
              </v-list-item-title>
              <v-list-item-subtitle class="text-wrap mt-1">
                {{ item.mensagem }}
              </v-list-item-subtitle>
            </v-list-item-content>

            <v-list-item-action>
              <v-btn v-if="!item.lido" small text color="primary" :loading="marcandoId === item.id" @click="marcarLido(item)">
                Marcar como lido
              </v-btn>
            </v-list-item-action>
          </v-list-item>
          <v-divider v-if="index < feedbacks.length - 1" :key="`div-${item.id}`"></v-divider>
        </template>
      </v-list>
    </v-card>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";

export default {
  components: { MenuAdmin },
  data() {
    return {
      carregando: false,
      marcandoId: null,
      feedbacks: [],
    };
  },
  async mounted() {
    await this.carregar();
  },
  methods: {
    async carregar() {
      this.carregando = true;
      try {
        const res = await this.$http.get("/admin/feedbacks");
        this.feedbacks = res.data;
      } finally {
        this.carregando = false;
      }
    },
    async marcarLido(item) {
      this.marcandoId = item.id;
      try {
        await this.$http.put(`/admin/feedbacks/${item.id}/lido`);
        item.lido = true;
      } finally {
        this.marcandoId = null;
      }
    },
    formataData(data) {
      if (!data) return "-";
      return new Date(data).toLocaleString("pt-BR");
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

.feedback-lido {
  opacity: 0.7;
}

.text-wrap {
  white-space: normal;
}
</style>
