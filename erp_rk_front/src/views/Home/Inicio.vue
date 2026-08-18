<template>
  <div>
    <v-card flat class="mb-4">
      <div class="d-flex align-center flex-wrap px-6 py-5 boas-vindas">
        <v-avatar size="56" class="mr-4" color="primary">
          <v-img v-if="tenant.logo" :src="tenant.logo"></v-img>
          <v-icon v-else dark size="30">mdi-store</v-icon>
        </v-avatar>
        <div>
          <h2 class="text-h5 font-weight-medium mb-0">Olá, {{ tenant.name || "bem-vindo" }}!</h2>
          <span class="text-caption grey--text text--darken-1">
            Aqui está um resumo rápido do seu sistema RK Nuvem
          </span>
        </div>
      </div>
    </v-card>

    <v-row>
      <v-col cols="12" md="8">
        <v-card flat>
          <v-card-title class="text-subtitle-1">Acesso rápido</v-card-title>
          <v-divider></v-divider>
          <v-row class="pa-4" dense>
            <v-col v-for="atalho in atalhos" :key="atalho.to" cols="6" sm="4" md="3">
              <v-card outlined class="atalho text-center pa-3" @click="$router.push(atalho.to)">
                <v-icon size="28" color="primary">{{ atalho.icon }}</v-icon>
                <div class="text-caption mt-1">{{ atalho.name }}</div>
              </v-card>
            </v-col>
          </v-row>
        </v-card>

        <v-card flat class="mt-4" v-if="notificacoes.length">
          <v-card-title class="text-subtitle-1 d-flex align-center">
            <v-icon color="warning" class="mr-2">mdi-bell-alert-outline</v-icon>
            Pontos de atenção
            <v-spacer></v-spacer>
            <v-chip small color="error" dark>{{ notificacoes.length }}</v-chip>
          </v-card-title>
          <v-divider></v-divider>
          <v-list dense>
            <v-list-item v-for="notificacao in notificacoes.slice(0, 6)" :key="notificacao.id" :to="notificacao.link">
              <v-list-item-icon>
                <v-icon :color="notificacao.severidade === 'error' ? 'error' : 'warning'">
                  {{ notificacao.severidade === "error" ? "mdi-alert-circle" : "mdi-alert" }}
                </v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="text-body-2 font-weight-medium">{{ notificacao.titulo }}</v-list-item-title>
                <v-list-item-subtitle>{{ notificacao.mensagem }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card>
      </v-col>

      <v-col cols="12" md="4">
        <v-card flat>
          <v-card-title class="text-subtitle-1">
            <v-icon color="primary" class="mr-2">mdi-phone-outline</v-icon>
            Contato
          </v-card-title>
          <v-divider></v-divider>
          <v-list dense>
            <v-list-item>
              <v-list-item-icon>
                <v-icon small>mdi-map-marker-outline</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="text-body-2">Rua Doutor Olavo Egídio, 655</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-icon>
                <v-icon small>mdi-phone-outline</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="text-body-2">(11) 2628-1356 ou (11) 2506-1348</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-icon>
                <v-icon small>mdi-clock-outline</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="text-body-2">Seg - Sex: 9:00 - 18:00</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card>

        <v-card flat class="mt-4">
          <v-card-title class="text-subtitle-1">
            <v-icon color="primary" class="mr-2">mdi-cloud-download-outline</v-icon>
            Downloads
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <p class="text-body-2 mb-2">Instaladores e utilitários do RK Nuvem.</p>
            <v-btn small text color="primary" to="/downloads">
              Ver downloads
              <v-icon right small>mdi-arrow-right</v-icon>
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  name: "Inicio",
  data() {
    return {
      atalhos: [
        { name: "Produtos", to: "/cadastro/produto", icon: "mdi-package-variant-closed" },
        { name: "Clientes", to: "/cadastro/cliente", icon: "mdi-account-multiple" },
        { name: "Painel de Vendas", to: "/relatorio/caixa/painel", icon: "mdi-chart-bar" },
        { name: "Painel de Estoque", to: "/relatorio/estoque/painel", icon: "mdi-warehouse" },
        { name: "Contas a Pagar", to: "/financeiro/contas-a-pagar", icon: "mdi-credit-card-outline" },
        { name: "Carga", to: "/carga/loja", icon: "mdi-cloud-upload-outline" },
        { name: "Fornecedores", to: "/cadastro/fornecedor", icon: "mdi-truck-outline" },
        { name: "Downloads", to: "/downloads", icon: "mdi-cloud-download-outline" },
      ],
    };
  },
  async mounted() {
    await this.$store.dispatch("getNotificacoes");
  },
  computed: {
    tenant() {
      return this.$store.state.tenant.tenant;
    },
    notificacoes() {
      return this.$store.state.notificacao.notificacaoList;
    },
  },
};
</script>

<style scoped>
.boas-vindas {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

.atalho {
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.atalho:hover {
  background-color: rgba(25, 118, 210, 0.06);
}
</style>
