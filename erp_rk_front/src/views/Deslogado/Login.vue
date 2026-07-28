<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" sm="8" md="4">
        <v-card>
          <v-img
            :src="require('@/assets/logo.png')"
            height="100"
            contain
          ></v-img>
          <v-card-title class="text-center">Login</v-card-title>
          <v-card-text>
            <v-form ref="form" @submit.prevent="login">
              <v-text-field v-model="username" label="Usuário"></v-text-field>
              <v-text-field
                v-model="password"
                label="Senha"
                type="password"
              ></v-text-field>
              <v-btn
                color="primary"
                type="submit"
                block
                :loading="loading"
                :disabled="loading"
              >
                <template v-if="!loading"> Login </template>
                <template v-else>
                  <v-progress-circular
                    indeterminate
                    size="24"
                  ></v-progress-circular>
                </template>
              </v-btn>
            </v-form>
          </v-card-text>
          <!-- <v-card-actions>
            <v-spacer></v-spacer>
            <router-link to="/administracao">Painel ADM</router-link>
          </v-card-actions> -->
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
    };
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
