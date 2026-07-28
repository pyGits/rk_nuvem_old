<template>
  <div>
    <v-app-bar app color="primary" dark class="position-fixed">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-autocomplete
        v-model="search"
        :items="searchSubItemsByText"
        item-text="name"
        item-value="to"
        label=""
        prepend-icon="mdi-magnify"
        hide-details
        clearable
        return-object
        label-color="white"
      >
      </v-autocomplete>
      <v-spacer></v-spacer>
      <v-menu offset-y>
        <template v-slot:activator="{ on }">
          <v-btn icon v-on="on">
            <v-icon>mdi-bell</v-icon>
          </v-btn>
        </template>
        <v-card>
          <v-list>
            <v-list-item
              v-for="(notification, index) in notifications"
              :key="index"
            >
              <v-list-item-title>{{ notification }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-card>
      </v-menu>
      <v-btn color="secondary" text @click="logout">
        Sair
        <v-icon>mdi-logout</v-icon>
      </v-btn>
    </v-app-bar>
  </div>
</template>

<script>
import Vue from "vue";
import menuItems from "@/components/Menu/Menu.json"; // importa o arquivo com os itens do menu

export default {
  data() {
    return {
      search: "", // o texto de pesquisa do usuário
      notifications: ["Notificação 1", "Notificação 2", "Notificação 3"],
    };
  },
  watch: {
    search(newValue) {
      this.$router.push(newValue.to);
    },
  },
  methods: {
    logout() {
      Vue.prototype.$http.defaults.headers.common["x-access-token"] = null;
      localStorage.removeItem("access_token");
      this.$router.push("/login");
    },
  },
  computed: {
    drawer: {
      get() {
        return this.$store.state.Application.drawer;
      },
      set(value) {
        this.$store.commit("setDrawerApplication", value);
      },
    },
    searchSubItemsByText() {
      let menuFiltrado = [];
      // filtra os subitens que correspondem ao texto de pesquisa do usuário
      menuItems.map((item) => {
        if (item.subItems) {
          item.subItems.map((subItem) => {
            menuFiltrado.push(subItem);
          });
        }
      });
      return menuFiltrado;
    },
  },
};
</script>

<style lang="scss" scoped>
.v-app-bar {
  background-color: #1976d2 !important; // Define a cor de fundo da barra como azul
}
.max-width {
  max-width: 300px; // Define a largura máxima do campo de pesquisa
}
.v-input .v-label {
  color: white !important ;
}
</style>
