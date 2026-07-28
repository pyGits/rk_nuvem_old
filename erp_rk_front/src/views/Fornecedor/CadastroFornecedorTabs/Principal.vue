<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-codigo">Código:</label>
        <input type="text" class="form-control" placeholder="Código do Fornecedor" v-model="codigo" id="input-codigo" :disabled="editMode" />
        <div v-if="errorCodigo" class="form-text text-danger">
          {{ errorCodigoMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-cnpjcpf">CNPJ/CPF:</label>
        <input type="text" class="form-control" placeholder="CNPJ ou CPF" v-model="cnpjcpf" @blur="validaCNPJCPF" id="input-cnpjcpf" :disabled="editMode" />
        <div v-if="errorCnpjcpf" class="form-text text-danger">
          {{ errorCnpjcpfMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-nome">Nome do Fornecedor:</label>
        <input type="text" class="form-control" placeholder="Nome do Fornecedor" v-model="nome" id="input-nome" />
        <div v-if="errorNome" class="form-text text-danger">
          {{ errorNomeMessage }}
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="6">
        <label class="form-label" for="input-fantasia">Nome Fantasia:</label>
        <input type="text" class="form-control" placeholder="Nome Fantasia" v-model="fantasia" id="input-fantasia" />
      </v-col>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-ierg">RG/IE:</label>
        <input type="text" class="form-control" placeholder="RG ou IE" v-model="ierg" id="input-ierg" />
      </v-col>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-ierg">IM:</label>
        <input type="text" class="form-control" placeholder="IM" v-model="im" id="input-im" />
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-telefone">Telefone:</label>
        <input type="text" class="form-control" placeholder="Telefone" v-model="telefone" id="input-telefone" />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-telefone">Telefone 2:</label>
        <input type="text" class="form-control" placeholder="Telefone2" v-model="telefone2" id="input-telefone2" />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-celular">Celular:</label>
        <input type="text" class="form-control" placeholder="Celular" v-model="celular" id="input-celular" />
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-email">E-mail:</label>
        <input type="text" class="form-control" placeholder="E-mail" v-model="email" id="input-email" />
        <div v-if="errorEmail" class="form-text text-danger">
          {{ errorEmailMessage }}
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="12">
        <label class="form-label" for="input-email">Observacao</label>
        <input type="text" class="form-control" placeholder="Observações" v-model="observacao" id="input-observacao" />
        <div v-if="errorEmail" class="form-text text-danger">
          {{ errorEmailMessage }}
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-checkbox v-model="transportadora" true-value="S" false-value="N" label="Transportadora" class="mt-0"></v-checkbox>
    </v-row>
  </v-container>
</template>

<script>
export default {
  methods: {
    validaCNPJCPF() {
      const isValid = this.$store.state.fornecedor.fornecedor.pessoa.validaCNPJCPF();
      this.$store.commit("resetError");
      if (!isValid) {
        this.$store.dispatch("showError", {
          state: "fornecedor",
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
        return this.$store.state.error.error.fornecedor.email;
      },
    },
    errorEmailMessage: {
      get() {
        return this.$store.state.error.error.fornecedor.email_message;
      },
    },
    errorNome: {
      get() {
        return this.$store.state.error.error.fornecedor.nome;
      },
    },
    errorNomeMessage: {
      get() {
        return this.$store.state.error.error.fornecedor.nome_message;
      },
    },
    errorCnpjcpf: {
      get() {
        return this.$store.state.error.error.fornecedor.cnpjcpf;
      },
    },
    errorCnpjcpfMessage: {
      get() {
        return this.$store.state.error.error.fornecedor.cnpjcpf_message;
      },
    },
    errorCodigo: {
      get() {
        return this.$store.state.error.error.fornecedor.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.fornecedor.codigo_message;
      },
    },
    codigo: {
      get() {
        return this.$store.state.fornecedor.fornecedor.codigo;
      },
      set(value) {
        this.$store.commit("setFornecedorCodigo", value);
      },
    },
    cnpjcpf: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.cnpjcpf;
      },
      set(value) {
        this.$store.commit("setFornecedorCnpjcpf", value);
      },
    },
    nome: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.nome;
      },
      set(value) {
        this.$store.commit("setFornecedorNome", value);
      },
    },
    fantasia: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.fantasia;
      },
      set(value) {
        this.$store.commit("setFornecedorFantasia", value);
      },
    },
    ierg: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.ierg;
      },
      set(value) {
        this.$store.commit("setFornecedorIerg", value);
      },
    },
    im: {
      get() {
        return this.$store.state.fornecedor.fornecedor.im;
      },
      set(value) {
        this.$store.commit("setFornecedorIm", value);
      },
    },
    observacao: {
      get() {
        return this.$store.state.fornecedor.fornecedor.observacao;
      },
      set(value) {
        this.$store.commit("setFornecedorObservacao", value);
      },
    },
    telefone: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.telefone;
      },
      set(value) {
        this.$store.commit("setFornecedorTelefone", value);
      },
    },
    telefone2: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.telefone2;
      },
      set(value) {
        this.$store.commit("setFornecedorTelefone2", value);
      },
    },
    celular: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.celular;
      },
      set(value) {
        this.$store.commit("setFornecedorCelular", value);
      },
    },
    email: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.email;
      },
      set(value) {
        this.$store.commit("setFornecedorEmail", value);
      },
    },
    transportadora: {
      get() {
        return this.$store.state.fornecedor.fornecedor.transportadora;
      },
      set(value) {
        this.$store.commit("setFornecedorTransportadora", value);
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
