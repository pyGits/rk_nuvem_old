<template>
  <v-card>
    <v-card-title>Cadastro Tributação</v-card-title>
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
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">CST:</label>
          <v-select
            id="cst"
            v-model="cst"
            item-text="nome"
            item-value="codigo"
            :items="cstList"
            @change="selectCST"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">CFOP:</label>
          <v-select
            id="cfop"
            v-model="cfop"
            item-text="nome"
            item-value="codigo"
            :items="cfopList"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">CSOSN:</label>
          <v-select
            id="csosn"
            v-model="csosn"
            item-text="nome"
            item-value="codigo"
            :items="csosnList"
          ></v-select>
        </v-col>
        <v-col cols="12" sm="2">
          <label class="form-label" for="input-example">ICMS:</label>
          <input
            type="text"
            class="form-control"
            placeholder="% Tributação"
            v-model="icms"
            :disabled="isICMSDisabled"
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
import { maskAmount, maskMoneyToFloat } from "@/utils/masks";

export default {
  data() {
    return {
      isICMSDisabled: false,
      cstList: [
        { codigo: "060", nome: "060 - Fonte" },
        { codigo: "00", nome: "00 - Trb." },
        { codigo: "040", nome: "040 - Isento" },
      ],
      cfopList: [
        { codigo: "5405", nome: "5405" },
        { codigo: "5102", nome: "5102" },
      ],
      csosnList: [
        { codigo: "500", nome: "500" },
        { codigo: "102", nome: "102" },
        { codigo: "300", nome: "300" },
      ],
    };
  },
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    const tributacao = await this.$store
      .dispatch("getTributacao", this.$route.params.codigo)
      .finally(() => {
        this.$store.commit("setContainerLoading", false);
      });

    if (tributacao?.response?.status === 404) {
      this.$router.push("/fiscal/tributacao");
    }

    this.selectCST();

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }
  },
  methods: {
    selectCST() {
      if (this.cst === "060") {
        this.isICMSDisabled = true;
        this.icms = "0";
        this.cfopList = [{ codigo: "5405", nome: "5405" }];
        this.csosnList = [{ codigo: "500", nome: "500" }];
      }
      if (this.cst === "00") {
        this.isICMSDisabled = false;
        this.cfopList = [{ codigo: "5102", nome: "5102" }];
        this.csosnList = [{ codigo: "102", nome: "102" }];
      }
      if (this.cst === "040") {
        this.isICMSDisabled = true;
        this.icms = "0";
        this.cfopList = [{ codigo: "5102", nome: "5102" }];
        this.csosnList = [{ codigo: "300", nome: "300" }];
      }
    },
    cancelar() {
      this.$router.push("/fiscal/tributacao");
    },
    async gravar() {
      await this.$store
        .dispatch("gravarTributacao", this.$route.params.codigo)
        .then(() => {
          this.$router.push("/fiscal/tributacao");
        });
    },
  },

  computed: {
    codigo: {
      get() {
        return this.$store.state.tributacao.tributacao.codigo;
      },
      set(valor) {
        this.$store.commit("setTributacaoCodigo", valor);
      },
    },
    nome: {
      get() {
        return this.$store.state.tributacao.tributacao.nome;
      },
      set(valor) {
        this.$store.commit("setTributacaoNome", valor);
      },
    },
    cst: {
      get() {
        return this.$store.state.tributacao.tributacao.cst;
      },
      set(valor) {
        this.$store.commit("setTributacaoCST", valor);
      },
    },
    cfop: {
      get() {
        return this.$store.state.tributacao.tributacao.cfop;
      },
      set(valor) {
        this.$store.commit("setTributacaoCFOP", valor);
      },
    },
    csosn: {
      get() {
        return this.$store.state.tributacao.tributacao.csosn;
      },
      set(valor) {
        this.$store.commit("setTributacaoCSOSN", valor);
      },
    },
    icms: {
      get() {
        return maskAmount(this.$store.state.tributacao.tributacao.icms);
      },
      set(valor) {
        this.$store.commit("setTributacaoICMS", maskMoneyToFloat(valor));
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
