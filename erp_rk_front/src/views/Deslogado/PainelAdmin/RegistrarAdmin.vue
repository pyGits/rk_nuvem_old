<template>
  <div>
    <MenuAdmin>
      <v-row>
        <v-col cols="12" sm="12" md="12">
          <v-card>
            <v-toolbar color="primary" dark>
              <v-toolbar-title>Registro</v-toolbar-title>
            </v-toolbar>
            <v-card-text>
              <v-form ref="form" v-model="valid">
                <v-text-field v-model="name" :rules="nameRules" label="Nome da Loja" required></v-text-field>
                <v-text-field v-model="username" :rules="usernameRules" label="Nome de usuário para Login" required></v-text-field>
                <v-text-field v-model="cnpjcpf" :rules="cnpjcpfRules" label="CNPJ/CPF de usuário" required></v-text-field>
                <v-text-field v-model="email" :rules="emailRules" label="E-mail" required></v-text-field>
                <v-text-field v-model="password" :rules="passwordRules" label="Senha" type="password" required></v-text-field>
                <v-text-field v-model="confirmPassword" :rules="confirmPasswordRules" label="Confirme a senha" type="password" required></v-text-field>
                <v-text-field v-model="qtdUsuarios" label="Quantidade usuários permitidos" type="number" required></v-text-field>
                <v-text-field v-model="qtdLojas" label="Quantidade de Lojas permitidas" type="number" required></v-text-field>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="primary" :loading="loading" :disabled="loading" @click="register">
                <template v-if="!loading"> Registrar </template>
                <template v-else>
                  <v-progress-circular indeterminate size="24"></v-progress-circular>
                </template>
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </MenuAdmin>
  </div>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";
import { validarCpfCnpj } from "@/utils/validate";

export default {
  components: {
    MenuAdmin,
  },

  data() {
    return {
      valid: false,
      name: "regis",
      nameRules: [(v) => !!v || "O nome é obrigatório", (v) => v.length <= 50 || "O nome deve ter no máximo 20 caracteres"],
      username: "123",
      usernameRules: [(v) => !!v || "O nome de usuário é obrigatório", (v) => !/\s/.test(v) || "O nome de usuário não pode ter espaços"],
      email: "regis@gmail.com",
      emailRules: [(v) => !!v || "O e-mail é obrigatório", (v) => /.+@.+/.test(v) || "Insira um e-mail válido"],
      password: "123456",
      passwordRules: [(v) => !!v || "A senha é obrigatória", (v) => v.length >= 4 || "A senha deve ter pelo menos 4 caracteres"],
      confirmPassword: "123456",
      confirmPasswordRules: [(v) => !!v || "Confirme a senha", (v) => v === this.password || "As senhas não coincidem"],
      cnpjcpf: "08115094000156",
      cnpjcpfRules: [(v) => !!v || "Informe o CNPJ/CPF", (v) => validarCpfCnpj(v) || "Informe um CNPJ válido"],
      qtdUsuarios: 2,
      qtdLojas: 2,
      loading: false,
    };
  },
  methods: {
    register() {
      const newUser = {
        name: this.name,
        user: this.username,
        email: this.email,
        password: this.password,
        cnpjcpf: this.cnpjcpf,
        confirmpassword: this.confirmPassword,
        qtdUsuarios: this.qtdUsuarios,
        qtdLojas: this.qtdLojas,
      };
      if (this.$refs.form.validate()) {
        this.loading = true;

        this.$http
          .post("/register", newUser)
          .then((res) => {
            if (res.status === 201) {
              this.$router.push("/administracao/clientes");
              this.$store.dispatch("showToastMessage", res.data.message);
            }
          })
          .catch((err) => {
            if (err.response) {
              this.$store.dispatch("showToastMessage", err.response.data.message);
            } else {
              this.$store.dispatch("showToastMessage", "Erro ao conectar ao servidor. Verifique sua conexão de rede.");
            }
          })
          .finally(() => {
            this.loading = false;
          });
      }
    },
  },
};
</script>

<style lang="scss" scoped></style>
