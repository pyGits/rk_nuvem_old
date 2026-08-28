<template>
  <div>
    <v-navigation-drawer v-model="drawer" app>
      <v-list>
        <v-list-item
          v-for="(item, index) in menuItems"
          :key="index"
          :to="item.route"
          link
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>Painel Administrativo</v-toolbar-title>
      <v-spacer></v-spacer>
      <!-- Adicione este elemento para criar espaço vazio flexível -->

      <v-btn icon to="/administracao">
        <v-icon>mdi-exit-to-app</v-icon>
        <!-- Ícone de saída -->
      </v-btn>
    </v-app-bar>
    <v-content>
      <v-container>
        <slot></slot>
      </v-container>
    </v-content>
  </div>
</template>

<script>
export default {
  data() {
    return {
      drawer: true,
      menuItems: [
        {
          title: "Cadastrar Cliente",
          icon: "mdi-view-dashboard",
          route: "/administracao/registrar",
        },
        {
          title: "Listar Clientes",
          icon: "mdi-account",
          route: "/administracao/clientes",
        },
        {
          title: "Downloads",
          icon: "mdi-cloud-download-outline",
          route: "/administracao/downloads",
        },
        {
          title: "Tabela IBPT",
          icon: "mdi-table-large",
          route: "/administracao/ibpt",
        },
        // Feature de feedback está desativada por enquanto (ver Header.vue,
        // featureFeedbackAtivo). Reativar os dois juntos.
        // {
        //   title: "Feedbacks",
        //   icon: "mdi-message-text-outline",
        //   route: "/administracao/feedbacks",
        // },
      ],
    };
  },
};
</script>
