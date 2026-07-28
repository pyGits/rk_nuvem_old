<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-codigo">Código:</label>
        <input type="text" class="form-control" placeholder="Código do Cliente" v-model="codigo" id="input-codigo" :disabled="editMode" />
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
        <label class="form-label" for="input-nome">Nome do Cliente:</label>
        <input type="text" class="form-control" placeholder="Nome do Cliente" v-model="nome" id="input-nome" />
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
        <label class="form-label" for="input-ierg">Limite Crédito</label>
        <input type="text" class="form-control" placeholder="Limite Crédito" v-model="limiteCredito" id="input-limite" />
      </v-col>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-ierg">Desconto (%):</label>
        <input type="text" class="form-control" placeholder="Desconto (%)" v-model="percDesconto" id="input-percDesconto" />
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-telefone">Telefone:</label>
        <input type="text" class="form-control" placeholder="Telefone" v-model="telefone" id="input-telefone" />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-telefone">Telefone 2:</label>
        <input type="text" class="form-control" placeholder="Telefone" v-model="telefone2" id="input-telefone" />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-celular">Celular:</label>
        <input type="text" class="form-control" placeholder="Celular" v-model="celular" id="input-celular" />
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-utiliza-preco-2"></label>
        <v-checkbox v-model="utilizaPreco2" label="Utiliza Preço 2"></v-checkbox>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="7">
        <label class="form-label" for="input-email">E-mail:</label>
        <input type="text" class="form-control" placeholder="E-mail" v-model="email" id="input-email" />
        <div v-if="errorEmail" class="form-text text-danger">
          {{ errorEmailMessage }}
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="12">
        <label class="form-label" for="input-email">Observacao:</label>
        <input type="text" class="form-control" placeholder="Observação" v-model="observacao" id="input-observacao" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { maskAmount, maskMoneyToFloat, maskQtd } from "@/utils/masks";

export default {
  methods: {
    validaCNPJCPF() {
      const isValid = this.$store.state.cliente.cliente.pessoa.validaCNPJCPF();
      this.$store.commit("resetError");
      if (!isValid) {
        this.$store.dispatch("showError", {
          state: "cliente",
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
        return this.$store.state.error.error.cliente.email;
      },
    },
    errorEmailMessage: {
      get() {
        return this.$store.state.error.error.cliente.email_message;
      },
    },
    errorNome: {
      get() {
        return this.$store.state.error.error.cliente.nome;
      },
    },
    errorNomeMessage: {
      get() {
        return this.$store.state.error.error.cliente.nome_message;
      },
    },
    errorCnpjcpf: {
      get() {
        return this.$store.state.error.error.cliente.cnpjcpf;
      },
    },
    errorCnpjcpfMessage: {
      get() {
        return this.$store.state.error.error.cliente.cnpjcpf_message;
      },
    },
    errorCodigo: {
      get() {
        return this.$store.state.error.error.cliente.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.cliente.codigo_message;
      },
    },
    codigo: {
      get() {
        return this.$store.state.cliente.cliente.codigo;
      },
      set(value) {
        this.$store.commit("setClienteCodigo", value);
      },
    },
    cnpjcpf: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.cnpjcpf;
      },
      set(value) {
        this.$store.commit("setClienteCnpjcpf", value);
      },
    },
    nome: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.nome;
      },
      set(value) {
        this.$store.commit("setClienteNome", value);
      },
    },
    fantasia: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.fantasia;
      },
      set(value) {
        this.$store.commit("setClienteFantasia", value);
      },
    },
    ierg: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.ierg;
      },
      set(value) {
        this.$store.commit("setClienteIerg", value);
      },
    },
    telefone: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.telefone;
      },
      set(value) {
        this.$store.commit("setClienteTelefone", value);
      },
    },
    telefone2: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.telefone2;
      },
      set(value) {
        this.$store.commit("setClienteTelefone2", value);
      },
    },
    celular: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.celular;
      },
      set(value) {
        this.$store.commit("setClienteCelular", value);
      },
    },
    email: {
      get() {
        return this.$store.state.cliente.cliente.pessoa.email;
      },
      set(value) {
        this.$store.commit("setClienteEmail", value);
      },
    },
    observacao: {
      get() {
        return this.$store.state.cliente.cliente.observacao;
      },
      set(value) {
        this.$store.commit("setClienteObservacao", value);
      },
    },
    limiteCredito: {
      get() {
        return maskQtd(this.$store.state.cliente.cliente.limiteCredito);
      },
      set(value) {
        this.$store.commit("setClienteLimiteCredito", maskMoneyToFloat(value));
      },
    },
    utilizaPreco2: {
      get() {
        return this.$store.state.cliente.cliente.utilizaPreco2;
      },
      set(value) {
        this.$store.commit("setClienteUtilizaPreco2", value);
      },
    },
    percDesconto: {
      get() {
        return maskQtd(this.$store.state.cliente.cliente.percDesconto);
      },
      set(value) {
        this.$store.commit("setClientePercDesconto", maskMoneyToFloat(value));
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
