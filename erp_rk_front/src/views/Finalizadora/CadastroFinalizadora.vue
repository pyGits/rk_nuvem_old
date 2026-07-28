<template>
  <v-card>
    <v-card-title>Cadastro Finalizadora</v-card-title>
    <v-container>
      <v-row>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example">Código:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Código da Tributacao"
            v-model="codigo"
            :disabled="mode === 'UPDATE'"
          />
        </v-col>
        <v-col cols="12" sm="9">
          <label class="form-label" for="input-example">Nome:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Nome da Tributacao"
            v-model="nome"
          />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example"
            >Espécie da finalizadora (SAT):</label
          >
          <v-radio-group
            v-model="especie"
            style="margin-top: 0"
            label-color="black"
          >
            <v-radio label="Dinheiro" value="1"></v-radio>
            <v-radio label="Cheque" value="2"></v-radio>
            <v-radio label="Cartão de Crédito" value="3"></v-radio>
            <v-radio label="Cartão de Débito" value="4"></v-radio>
            <v-radio label="Crédito Loja" value="5"></v-radio>
            <v-radio label="Vale Alimentação" value="10"></v-radio>
            <v-radio label="Vale Refeição" value="11"></v-radio>
            <v-radio label="Outros" value="99"></v-radio>
          </v-radio-group>
        </v-col>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example"
            >Tipo de Finalizadora:</label
          >
          <v-radio-group v-model="tipo" style="margin-top: 0">
            <v-radio label="Normal" value="N"></v-radio>
            <v-radio label="Convênio" value="C"></v-radio>
          </v-radio-group>
        </v-col>
        <v-col cols="12" sm="3">
          <v-checkbox
            style="margin-top: 0"
            v-model="utiliza99"
            label="Utiliza 99"
            true-value="1"
            false-value="0"
          ></v-checkbox>
        </v-col>
      </v-row>
    </v-container>
    <div class="d-flex flex-row-reverse container">
      <v-btn color="seccondary" @click="cancelar" class="mr-2">Cancelar</v-btn>
      <v-btn color="primary" @click="gravar" class="mr-2">Gravar</v-btn>
    </div>
  </v-card>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    const finalizadora = await this.$store
      .dispatch("getFinalizadora", this.$route.params.codigo)
      .finally(() => {
        this.$store.commit("setContainerLoading", false);
      });

    if (finalizadora?.response?.status === 404) {
      this.$router.push("/cadastro/finalizadora");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    cancelar() {
      this.$router.push("/cadastro/finalizadora");
    },
    async gravar() {
      await this.$store
        .dispatch("gravarFinalizadora", this.$route.params.codigo)
        .then(() => {
          this.$router.push("/cadastro/finalizadora");
        });
    },
  },

  computed: {
    codigo: {
      get() {
        return this.$store.state.finalizadora.finalizadora.codigo;
      },
      set(valor) {
        this.$store.commit("setFinalizadoraCodigo", valor);
      },
    },
    nome: {
      get() {
        return this.$store.state.finalizadora.finalizadora.nome;
      },
      set(valor) {
        this.$store.commit("setFinalizadoraNome", valor);
      },
    },
    tipo: {
      get() {
        return this.$store.state.finalizadora.finalizadora.tipo;
      },
      set(valor) {
        this.$store.commit("setFinalizadoraTipo", valor);
      },
    },
    especie: {
      get() {
        return this.$store.state.finalizadora.finalizadora.especie;
      },
      set(valor) {
        this.$store.commit("setFinalizadoraEspecie", valor);
      },
    },
    utiliza99: {
      get() {
        return this.$store.state.finalizadora.finalizadora.utiliza99;
      },
      set(valor) {
        this.$store.commit("setFinalizadoraUtiliza99", valor);
      },
    },

    mode: {
      get() {
        return this.$store.state.Application.mode;
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
