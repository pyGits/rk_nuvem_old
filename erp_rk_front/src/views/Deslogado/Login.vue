<template>
  <v-container fluid class="login-bg fill-height pa-4">
    <v-row justify="center" align="center" class="fill-height ma-0">
      <v-col cols="12" sm="8" md="5" lg="4" xl="3">
        <v-card class="login-card rounded-lg elevation-12">
          <div class="login-topo d-flex flex-column align-center py-8 px-4">
            <v-avatar size="72" color="white" class="elevation-3">
              <v-img :src="require('@/assets/logo.svg')" max-width="44" contain></v-img>
            </v-avatar>
            <h1 class="text-h6 white--text font-weight-medium mt-4 mb-0">RK Nuvem</h1>
            <span class="text-caption login-subtitulo">Acesse sua conta para continuar</span>
          </div>

          <v-card-text class="pt-8 px-8">
            <v-form ref="form" @submit.prevent="login">
              <v-text-field
                v-model="username"
                label="Usuário"
                outlined
                dense
                autofocus
                prepend-inner-icon="mdi-account-outline"
                class="mb-1"
              ></v-text-field>
              <v-text-field
                v-model="password"
                label="Senha"
                :type="mostrarSenha ? 'text' : 'password'"
                outlined
                dense
                prepend-inner-icon="mdi-lock-outline"
                :append-icon="mostrarSenha ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
                @click:append="mostrarSenha = !mostrarSenha"
              ></v-text-field>
              <v-btn
                color="primary"
                type="submit"
                block
                large
                depressed
                class="rounded-lg mt-2"
                :loading="loading"
                :disabled="loading"
              >
                Entrar
              </v-btn>
            </v-form>
            <!-- <router-link to="/administracao">Painel ADM</router-link> -->
          </v-card-text>

          <div class="text-center text-caption grey--text pb-5">
            © {{ anoAtual }} RK Nuvem
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import Vue from "vue";

export default {
  data() {
    return {
      username: "",
      password: "",
      loading: false,
      mostrarSenha: false,
    };
  },
  computed: {
    anoAtual() {
      return new Date().getFullYear();
    },
  },
  methods: {
    login() {
      this.loading = true;

      try {
        this.$http
          .post("/login", {
            user: this.username,
            password: this.password,
          })
          .then(async (res) => {
            if (res.status === 200) {
              localStorage.setItem("access_token", res.data.token);
              Vue.prototype.$http.defaults.headers.common["x-access-token"] =
                res.data.token;

              await this.$store
                .dispatch("getTenant")
                .then((res) => {
                  this.$store.commit("setTenant", res.data);
                })
                .catch(() => {
                  Vue.prototype.$http.defaults.headers.common[
                    "x-access-token"
                  ] = null;
                  localStorage.removeItem("access_token");
                  this.$router.push("/login");
                });

              this.$store.commit("setLogado", true);
              this.$router.push("/");
            }
          })
          .catch((err) => {
            if (err.response) {
              // O servidor respondeu com um status de erro
              this.$store.dispatch(
                "showToastMessage",
                err.response.data.message
              );
            } else {
              // Erro de conexão com o servidor
              this.$store.dispatch(
                "showToastMessage",
                "Erro ao conectar ao servidor. Verifique sua conexão de rede."
              );
            }
          })
          .finally(() => {
            this.loading = false;
          });
      } catch (error) {
        console.log(error);
        this.loading = false;
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.login-bg {
  min-height: 100vh;
  background: linear-gradient(135deg, #1867c0 0%, #1697f6 55%, #7bc6ff 100%);
}

.login-card {
  overflow: hidden;
}

.login-topo {
  background: linear-gradient(135deg, #1867c0 0%, #1697f6 100%);
}

.login-subtitulo {
  color: rgba(255, 255, 255, 0.85);
  margin-top: 2px;
}
</style>
