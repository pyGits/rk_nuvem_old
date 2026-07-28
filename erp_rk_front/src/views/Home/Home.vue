<template>
  <v-app v-if="!logado">
    <router-view name="rotas-deslogado"></router-view>
    <Toast></Toast>
  </v-app>
  <v-app v-else
    ><Menu></Menu> <Header></Header
    ><Container><Toast></Toast><router-view></router-view></Container>
  </v-app>
</template>

<script>
import Menu from "./../../components/Menu/Menu.vue";
import Container from "./../../components/Container/Container.vue";
import Header from "./../../components/Header/Header.vue";
import Toast from "./../../components/Toast/Toast.vue";
import Vue from "vue";
export default {
  async mounted() {
    if (this.logado) {
      await this.$store
        .dispatch("getTenant")
        .then((res) => {
          this.$store.commit("setTenant", res.data);
        })
        .catch(() => {
          Vue.prototype.$http.defaults.headers.common["x-access-token"] = null;
          localStorage.removeItem("access_token");
          this.$router.push("/login");
        });
    }
  },
  computed: {
    logado: {
      get() {
        return this.$store.state.Application.logado;
      },
    },
  },

  components: {
    Menu,
    Header,
    Container,
    Toast,
  },
};
</script>

<style lang="scss" scoped></style>
