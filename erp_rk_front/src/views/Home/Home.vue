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
        .catch((erro) => {
          // Só o servidor pode dizer que a sessão acabou. Este catch era cego:
          // qualquer falha apagava o token e mandava para o login — e durante um
          // deploy, ou com o backend fora do ar, getTenant falha por rede, não
          // por credencial. O token continuava válido, mas era destruído aqui, e
          // todo mundo que abriu a tela naquele instante precisava logar de novo.
          const status = erro?.response?.status;
          if (status !== 401 && status !== 403) return;

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
