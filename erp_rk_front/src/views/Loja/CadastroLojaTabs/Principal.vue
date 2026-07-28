<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-codigo">Código:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Código da Loja"
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
        <label class="form-label" for="input-nome">Nome da Loja:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Nome da Loja"
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
  </v-container>
</template>

<script>
export default {
  methods: {
    validaCNPJCPF() {
      const isValid = this.$store.state.loja.loja.pessoa.validaCNPJCPF();
      this.$store.commit("resetError");
      if (!isValid) {
        this.$store.dispatch("showError", {
          state: "loja",
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
    errorEmail: {
      get() {
        return this.$store.state.error.error.loja.email;
      },
    },
    errorEmailMessage: {
      get() {
        return this.$store.state.error.error.loja.email_message;
      },
    },
    errorNome: {
      get() {
        return this.$store.state.error.error.loja.nome;
      },
    },
    errorNomeMessage: {
      get() {
        return this.$store.state.error.error.loja.nome_message;
      },
    },
    errorCnpjcpf: {
      get() {
        return this.$store.state.error.error.loja.cnpjcpf;
      },
    },
    errorCnpjcpfMessage: {
      get() {
        return this.$store.state.error.error.loja.cnpjcpf_message;
      },
    },
    errorCodigo: {
      get() {
        return this.$store.state.error.error.loja.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.loja.codigo_message;
      },
    },
    codigo: {
      get() {
        return this.$store.state.loja.loja.codigo;
      },
      set(value) {
        this.$store.commit("setLojaCodigo", value);
      },
    },
    cnpjcpf: {
      get() {
        return this.$store.state.loja.loja.pessoa.cnpjcpf;
      },
      set(value) {
        this.$store.commit("setLojaCnpjcpf", value);
      },
    },
    nome: {
      get() {
        return this.$store.state.loja.loja.pessoa.nome;
      },
      set(value) {
        this.$store.commit("setLojaNome", value);
      },
    },
    fantasia: {
      get() {
        return this.$store.state.loja.loja.pessoa.fantasia;
      },
      set(value) {
        this.$store.commit("setLojaFantasia", value);
      },
    },
    ierg: {
      get() {
        return this.$store.state.loja.loja.pessoa.ierg;
      },
      set(value) {
        this.$store.commit("setLojaIerg", value);
      },
    },
    telefone: {
      get() {
        return this.$store.state.loja.loja.pessoa.telefone;
      },
      set(value) {
        this.$store.commit("setLojaTelefone", value);
      },
    },
    celular: {
      get() {
        return this.$store.state.loja.loja.pessoa.celular;
      },
      set(value) {
        this.$store.commit("setLojaCelular", value);
      },
    },
    email: {
      get() {
        return this.$store.state.loja.loja.pessoa.email;
      },
      set(value) {
        this.$store.commit("setLojaEmail", value);
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
