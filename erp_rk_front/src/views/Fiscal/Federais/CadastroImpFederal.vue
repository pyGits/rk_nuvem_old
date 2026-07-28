<template>
  <v-card>
    <v-card-title>Cadastro Imposto Federal</v-card-title>
    <v-container>
      <v-row>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example">Código:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Código do Imp Federal"
            v-model="codigo"
            :disabled="mode === 'UPDATE'"
          />
        </v-col>
        <v-col cols="12" sm="9">
          <label class="form-label" for="input-example">Nome:</label>
          <input
            type="text"
            class="form-control"
            placeholder="Nome do Imp Federal"
            v-model="nome"
          />
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="4">
          <label class="form-label" for="input-example">CST Entrada:</label>
          <v-select
            id="cst"
            v-model="cstEntrada"
            :items="listEntrada"
            item-text="texto"
            item-value="codigo"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="4">
          <label class="form-label" for="input-example">CST Saída:</label>
          <v-select
            id="cst"
            :items="listSaida"
            v-model="cstSaida"
            item-text="texto"
            item-value="codigo"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">PIS:</label>
          <input
            type="text"
            class="form-control"
            placeholder="% PIS"
            v-model="pis"
          />
        </v-col>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">COFINS:</label>
          <input
            type="text"
            class="form-control"
            placeholder="% Cofins"
            v-model="cofins"
          />
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
import { maskQtd, maskMoneyToFloat } from "@/utils/masks";
import impfederal from "@/utils/ImpFederal.json";
export default {
  data() {
    return { listEntrada: impfederal.entrada, listSaida: impfederal.saida };
  },
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    const tributacao = await this.$store
      .dispatch("getImpFederal", this.$route.params.codigo)
      .finally(() => {
        this.$store.commit("setContainerLoading", false);
      });

    if (tributacao?.response?.status === 404) {
      this.$router.push("/fiscal/impfederal");
    }

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    cancelar() {
      this.$router.push("/fiscal/impfederal");
    },
    async gravar() {
      await this.$store
        .dispatch("gravarImpFederal", this.$route.params.codigo)
        .then(() => {
          this.$router.push("/fiscal/impfederal");
        });
    },
  },

  computed: {
    codigo: {
      get() {
        return this.$store.state.impfederal.impfederal.codigo;
      },
      set(valor) {
        this.$store.commit("setImpFederalCodigo", valor);
      },
    },
    nome: {
      get() {
        return this.$store.state.impfederal.impfederal.nome;
      },
      set(valor) {
        this.$store.commit("setImpFederalNome", valor);
      },
    },
    cstEntrada: {
      get() {
        return this.$store.state.impfederal.impfederal.cstEntrada;
      },
      set(valor) {
        this.$store.commit("setImpFederalCSTEntrada", valor);
      },
    },
    cstSaida: {
      get() {
        return this.$store.state.impfederal.impfederal.cstSaida;
      },
      set(valor) {
        this.$store.commit("setImpFederalCSTSaida", valor);
      },
    },
    pis: {
      get() {
        return maskQtd(this.$store.state.impfederal.impfederal.pis);
      },
      set(valor) {
        this.$store.commit("setImpFederalPis", maskMoneyToFloat(valor));
      },
    },
    cofins: {
      get() {
        return maskQtd(this.$store.state.impfederal.impfederal.cofins);
      },
      set(valor) {
        this.$store.commit("setImpFederalCofins", maskMoneyToFloat(valor));
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
