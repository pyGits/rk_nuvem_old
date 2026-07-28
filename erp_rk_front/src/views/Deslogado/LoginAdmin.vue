<template>
  <v-container v-if="!token">
    <v-row justify="center" align="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <v-card>
          <v-card-title> Login </v-card-title>
          <v-card-text>
            <v-form>
              <v-text-field
                v-model="user"
                label="Usuário"
                outlined
                required
              ></v-text-field>
              <v-text-field
                v-model="password"
                label="Senha"
                type="password"
                outlined
                required
              ></v-text-field>
              <v-btn color="primary" @click="login()" block> Login </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
  <v-container v-else>
    <router-view name="rotas-admin"></router-view>
  </v-container>
</template>

<script>
export default {
  beforeCreate() {
    this.$store.commit("setAdminToken", "");
    this.$store.commit("setAdminUser", "");
    this.$store.commit("setAdminPassword", "");
    localStorage.removeItem("access_token_admin");
  },
  computed: {
    user: {
      get() {
        return this.$store.state.admin.admin.user;
      },
      set(valor) {
        this.$store.commit("setAdminUser", valor);
      },
    },
    password: {
      get() {
        return this.$store.state.admin.admin.password;
      },
      set(valor) {
        this.$store.commit("setAdminPassword", valor);
      },
    },
    token: {
      get() {
        return this.$store.state.admin.admin.token;
      },
    },
  },
  methods: {
    async login() {
      await this.$store
        .dispatch("loginAdmin")
        .then((res) => {
          if (res.data.token) {
            localStorage.setItem("access_token_admin", res.data.token);
            this.$store.commit("setAdminToken", res.data.token);
            this.$router.push("/administracao/clientes");
          }
        })
        .catch((error) => {
          console.log(error.response.data.message);
        });
    },
  },
};
</script>

<style></style>
