<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-codigo">Código:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Código do Usuario"
          v-model="codigo"
          id="input-codigo"
          :disabled="editMode"
        />
        <div v-if="errorCodigo" class="form-text text-danger">
          {{ errorCodigoMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-cnpjcpf">CNPJ/CPF:</label>
        <input
          type="text"
          class="form-control"
          placeholder="CNPJ ou CPF"
          v-model="cnpjcpf"
          @blur="validaCNPJCPF"
          id="input-cnpjcpf"
          :disabled="editMode"
        />
        <div v-if="errorCnpjcpf" class="form-text text-danger">
          {{ errorCnpjcpfMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-nome">Nome:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Nome"
          v-model="nome"
          id="input-nome"
        />
        <div v-if="errorNome" class="form-text text-danger">
          {{ errorNomeMessage }}
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="6">
        <label class="form-label" for="input-fantasia">Nome Fantasia:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Nome Fantasia"
          v-model="fantasia"
          id="input-fantasia"
        />
      </v-col>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-ierg">RG/IE:</label>
        <input
          type="text"
          class="form-control"
          placeholder="RG ou IE"
          v-model="ierg"
          id="input-ierg"
        />
      </v-col>
      <v-col cols="12" sm="4">
        <label class="form-label" for="input-telefone">Telefone:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Telefone"
          v-model="telefone"
          id="input-telefone"
        />
      </v-col>
      <v-col cols="12" sm="4">
        <label class="form-label" for="input-celular">Celular:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Celular"
          v-model="celular"
          id="input-celular"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-email">E-mail:</label>
        <input
          type="text"
          class="form-control"
          placeholder="E-mail"
          v-model="email"
          id="input-email"
        />
        <div v-if="errorEmail" class="form-text text-danger">
          {{ errorEmailMessage }}
        </div>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" sm="4">
        <label class="form-label" for="input-email">Login:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Login de acesso ao sistema"
          v-model="user"
          id="input-user"
        />
        <div v-if="errorUser" class="form-text text-danger">
          {{ errorUserMessage }}
        </div>
        <div class="form-text">
          <v-btn @click="validaUser">Verificar</v-btn>
        </div>
      </v-col>
      <v-col cols="12" sm="4">
        <label class="form-label" for="input-email">Senha:</label>
        <input
          type="password"
          class="form-control"
          placeholder="Senha para acessar o sistema"
          v-model="password"
          id="input-user"
        />
        <div v-if="errorPassword" class="form-text text-danger">
          {{ errorPasswordMessage }}
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  methods: {
    async validaUser() {
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("resetError");
      await this.$store
        .dispatch("verificarUsuario")
        .catch((err) => {
          this.$store.dispatch("showError", {
            state: "usuario",
            chave: "user",
            chave_message: "user_message",
            message: err.response.data.message,
          });
        })
        .then((res) => {
          if (res.status === 200) {
            this.$store.dispatch(
              "showToastMessage",
              "Usuário Válido para login ! "
            );
          }
        })
        .finally(() => {
          this.$store.commit("setContainerLoading", false);
        });
    },
    validaCNPJCPF() {
      const isValid = this.$store.state.usuario.usuario.pessoa.validaCNPJCPF();
      this.$store.commit("resetError");
      if (!isValid) {
        this.$store.dispatch("showError", {
          state: "usuario",
          chave: "cnpjcpf",
          chave_message: "cnpjcpf_message",
          message: "CNPJ/CPF Não validado !",
        });
      }
    },
  },
  computed: {
    editMode: {
      get() {
        return this.$store.state.Application.mode === "UPDATE" ? true : false;
      },
    },
    errorPassword: {
      get() {
        return this.$store.state.error.error.usuario.password;
      },
    },
    errorPasswordMessage: {
      get() {
        return this.$store.state.error.error.usuario.password_message;
      },
    },
    errorUser: {
      get() {
        return this.$store.state.error.error.usuario.user;
      },
    },
    errorUserMessage: {
      get() {
        return this.$store.state.error.error.usuario.user_message;
      },
    },
    errorEmail: {
      get() {
        return this.$store.state.error.error.usuario.email;
      },
    },
    errorEmailMessage: {
      get() {
        return this.$store.state.error.error.usuario.email_message;
      },
    },
    errorNome: {
      get() {
        return this.$store.state.error.error.usuario.nome;
      },
    },
    errorNomeMessage: {
      get() {
        return this.$store.state.error.error.usuario.nome_message;
      },
    },
    errorCnpjcpf: {
      get() {
        return this.$store.state.error.error.usuario.cnpjcpf;
      },
    },
    errorCnpjcpfMessage: {
      get() {
        return this.$store.state.error.error.usuario.cnpjcpf_message;
      },
    },
    errorCodigo: {
      get() {
        return this.$store.state.error.error.usuario.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.usuario.codigo_message;
      },
    },
    codigo: {
      get() {
        return this.$store.state.usuario.usuario.codigo;
      },
      set(value) {
        this.$store.commit("setUsuarioCodigo", value);
      },
    },
    cnpjcpf: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.cnpjcpf;
      },
      set(value) {
        this.$store.commit("setUsuarioCnpjcpf", value);
      },
    },
    nome: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.nome;
      },
      set(value) {
        this.$store.commit("setUsuarioNome", value);
      },
    },
    fantasia: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.fantasia;
      },
      set(value) {
        this.$store.commit("setUsuarioFantasia", value);
      },
    },
    ierg: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.ierg;
      },
      set(value) {
        this.$store.commit("setUsuarioIerg", value);
      },
    },
    telefone: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.telefone;
      },
      set(value) {
        this.$store.commit("setUsuarioTelefone", value);
      },
    },
    celular: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.celular;
      },
      set(value) {
        this.$store.commit("setUsuarioCelular", value);
      },
    },
    email: {
      get() {
        return this.$store.state.usuario.usuario.pessoa.email;
      },
      set(value) {
        this.$store.commit("setUsuarioEmail", value);
      },
    },
    user: {
      get() {
        return this.$store.state.usuario.usuario.user;
      },
      set(value) {
        this.$store.commit("setUsuarioUser", value);
      },
    },
    password: {
      get() {
        return this.$store.state.usuario.usuario.password;
      },
      set(value) {
        this.$store.commit("setUsuarioPassword", value);
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
