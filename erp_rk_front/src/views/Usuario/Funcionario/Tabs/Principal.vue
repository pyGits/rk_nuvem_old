<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-codigo">Código:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Código do Funcionario"
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
        <label class="form-label" for="input-nome">Nome do Funcionario:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Nome do Funcionario"
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
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-celular">Comissão:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Comissao"
          v-model="comissao"
          id="input-comissao"
        />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-celular">Cargo:</label>
        <v-radio-group v-model="cargo" style="margin-top: 0">
          <v-radio label="Operador" value="0"></v-radio>
          <v-radio label="Fiscal" value="1"></v-radio>
          <v-radio label="Gerente" value="2"></v-radio>
        </v-radio-group>
      </v-col>

      <v-col cols="12" sm="5">
        <label class="form-label" for="input-celular">Senha:</label>
        <input
          type="password"
          class="form-control"
          placeholder="Senha"
          v-model="password"
          id="input-senha"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { maskMoney, maskMoneyToFloat, maskAmount } from "@/utils/masks";
export default {
  methods: {
    validaCNPJCPF() {
      const isValid =
        this.$store.state.funcionario.funcionario.pessoa.validaCNPJCPF();
      this.$store.commit("resetError");
      if (!isValid) {
        this.$store.dispatch("showError", {
          state: "funcionario",
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
        return this.$store.state.error.error.funcionario.email;
      },
    },
    errorEmailMessage: {
      get() {
        return this.$store.state.error.error.funcionario.email_message;
      },
    },
    errorNome: {
      get() {
        return this.$store.state.error.error.funcionario.nome;
      },
    },
    errorNomeMessage: {
      get() {
        return this.$store.state.error.error.funcionario.nome_message;
      },
    },
    errorCnpjcpf: {
      get() {
        return this.$store.state.error.error.funcionario.cnpjcpf;
      },
    },
    errorCnpjcpfMessage: {
      get() {
        return this.$store.state.error.error.funcionario.cnpjcpf_message;
      },
    },
    errorCodigo: {
      get() {
        return this.$store.state.error.error.funcionario.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.funcionario.codigo_message;
      },
    },
    codigo: {
      get() {
        return this.$store.state.funcionario.funcionario.codigo;
      },
      set(value) {
        this.$store.commit("setFuncionarioCodigo", value);
      },
    },
    comissao: {
      get() {
        return maskAmount(this.$store.state.funcionario.funcionario.comissao);
      },
      set(value) {
        this.$store.commit("setFuncionarioComissao", maskMoneyToFloat(value));
      },
    },
    cargo: {
      get() {
        return this.$store.state.funcionario.funcionario.cargo;
      },
      set(value) {
        this.$store.commit("setFuncionarioCargo", value);
      },
    },
    password: {
      get() {
        return this.$store.state.funcionario.funcionario.password;
      },
      set(value) {
        this.$store.commit("setFuncionarioSenha", value);
      },
    },
    cnpjcpf: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.cnpjcpf;
      },
      set(value) {
        this.$store.commit("setFuncionarioCnpjcpf", value);
      },
    },
    nome: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.nome;
      },
      set(value) {
        this.$store.commit("setFuncionarioNome", value);
      },
    },
    fantasia: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.fantasia;
      },
      set(value) {
        this.$store.commit("setFuncionarioFantasia", value);
      },
    },
    ierg: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.ierg;
      },
      set(value) {
        this.$store.commit("setFuncionarioIerg", value);
      },
    },
    telefone: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.telefone;
      },
      set(value) {
        this.$store.commit("setFuncionarioTelefone", value);
      },
    },
    celular: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.celular;
      },
      set(value) {
        this.$store.commit("setFuncionarioCelular", value);
      },
    },
    email: {
      get() {
        return this.$store.state.funcionario.funcionario.pessoa.email;
      },
      set(value) {
        this.$store.commit("setFuncionarioEmail", value);
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
