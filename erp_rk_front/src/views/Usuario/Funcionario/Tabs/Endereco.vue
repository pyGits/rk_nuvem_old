<template>
  <div>
    <v-container>
      <v-row>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-cep">CEP:</label>
          <input
            type="text"
            class="form-control"
            placeholder="CEP"
            v-model="cep"
            @blur="buscarCEP"
            @keydown.enter="buscarCEP"
            id="input-cep"
          />
        </v-col>
        <v-col cols="12" sm="6">
          <label class="form-label" for="input-logradouro">Logradouro:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Logradouro"
            v-model="logradouro"
            id="input-logradouro"
          />
        </v-col>
        <v-col cols="12" sm="1">
          <label class="form-label" for="input-uf">UF:</label>
          <v-autocomplete
            v-model="uf"
            :items="listaUFs"
            density="compact"
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="3" class="teste">
          <label class="form-label" for="input-uf">Cidade:</label>
          <v-autocomplete
            v-model="cidade"
            :items="listaCidades"
            density="compact"
          ></v-autocomplete>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" sm="6">
          <label class="form-label" for="input-bairro">Bairro:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Bairro"
            v-model="bairro"
            id="input-bairro"
          />
        </v-col>
        <v-col cols="12" sm="6">
          <label class="form-label" for="input-complemento">Complemento:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Complemento"
            v-model="complemento"
            id="input-complemento"
          />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>
<style lang="scss" scoped></style>
<script>
export default {
  methods: {
    async buscarCEP() {
      try {
        await this.$store.state.funcionario.funcionario.endereco.buscarEnderecoPorCep();
      } catch (error) {
        this.$store.dispatch("showToastMessage", error.message);
      }
    },
  },
  computed: {
    listaUFs: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.listaUFs;
      },
    },
    listaCidades: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.listaCidades;
      },
    },
    logradouro: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.logradouro;
      },
      set(value) {
        this.$store.commit("setFuncionarioLogradouro", value);
      },
    },
    cidade: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.cidade;
      },
      set(value) {
        this.$store.commit("setFuncionarioCidade", value);
      },
    },
    uf: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.uf;
      },
      set(value) {
        this.$store.commit("setFuncionarioUf", value);
      },
    },
    cep: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.cep;
      },
      set(value) {
        this.$store.commit("setFuncionarioCep", value);
      },
    },
    bairro: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.bairro;
      },
      set(value) {
        this.$store.commit("setFuncionarioBairro", value);
      },
    },
    complemento: {
      get() {
        return this.$store.state.funcionario.funcionario.endereco.complemento;
      },
      set(value) {
        this.$store.commit("setFuncionarioComplemento", value);
      },
    },
  },
};
</script>
