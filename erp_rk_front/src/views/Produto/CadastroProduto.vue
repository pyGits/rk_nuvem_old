<template>
  <v-card>
    <v-card-title>{{ codigo }} - {{ descricao }} </v-card-title>
    <template>
      <v-tabs v-model="active_tab">
        <v-tab v-for="(tab, i) in tabs" :key="i">{{ tab.title }}</v-tab>
        <v-tab-item v-for="(tab, i) in tabs" :key="i">
          <component
            :is="components[tab.component]"
            v-if="tab.component"
          ></component>
          <div v-else>{{ tab.content }}</div>
        </v-tab-item>
      </v-tabs>
    </template>
    <div class="d-flex flex-row-reverse container">
      <v-btn color="seccondary" class="mr-2" @click="cancelar">Cancelar</v-btn>
      <v-btn color="primary" class="mr-2" @click="gravar">Gravar</v-btn>
    </div>
  </v-card>
</template>

<script>
import TabPrincipal from "./CadastroProdutoTabs/Principal.vue";
import TabCodigosBarras from "./CadastroProdutoTabs/CodigosBarras.vue";
import TabPrecos from "./CadastroProdutoTabs/Precos.vue";
import TabFiscal from "./CadastroProdutoTabs/Fiscal.vue";
import TabEstoque from "./CadastroProdutoTabs/Estoque.vue";
export default {
  methods: {
    cancelar() {
      this.$router.push("/cadastro/produto");
    },
    async gravar() {
      if (
        await this.$store.dispatch(
          "validateProduto",
          this.$store.state.produto.produto
        )
      ) {
        this.$store.commit(
          "setPrecoCodigoProduto",
          this.$store.state.produto.produto.codigo
        );
        this.$store.commit(
          "setEstoqueCodigoProduto",
          this.$store.state.produto.produto.codigo
        );
        await this.$store.dispatch("gravarProduto", this.$route.params.codigo);
        await this.$store.dispatch(
          "gravarPreco",
          this.$store.state.produto.produto.codigo
        );
        await this.$store.dispatch(
          "gravarEstoque",
          this.$store.state.produto.produto.codigo
        );
        this.$router.push("/cadastro/produto");
      }
    },
  },
  async mounted() {
    this.$store.dispatch("resetState");
    this.$store.commit("setContainerLoading", true);

    if (this.$route.params.codigo === "novo") {
      this.$store.commit("setModeInsert");
    } else {
      this.$store.commit("setModeEdit");
    }

    await this.$store.dispatch("getProduto", this.$route.params.codigo);
    await this.$store.dispatch("getNCM", this.$store.state.produto.produto.ncm);
    await this.$store.dispatch(
      "getCEST",
      this.$store.state.produto.produto.cest
    );
    await this.$store.dispatch(
      "getTributacao",
      this.$store.state.produto.produto.tributacao
    );
    await this.$store.dispatch("getSecoes");
    await this.$store.dispatch(
      "getGrupos",
      this.$store.state.produto.produto.secao
    );
    await this.$store.dispatch("getFornecedors");
    await this.$store.dispatch("getPreco", this.$route.params.codigo);
    await this.$store.dispatch("getEstoque", this.$route.params.codigo);
    await this.$store.dispatch(
      "getImpFederal",
      this.$store.state.produto.produto.impfederal
    );
    this.$store.commit("setContainerLoading", false);
  },
  watch: {
    errorNcm(newValue) {
      if (newValue) {
        this.active_tab = 3;
      }
    },
    errorTributacao(newValue) {
      if (newValue) {
        this.active_tab = 3;
      }
    },
    errorCodigo(newValue) {
      if (newValue) {
        this.active_tab = 0;
      }
    },
    errorDescricao(newValue) {
      if (newValue) {
        this.active_tab = 0;
      }
    },
  },
  computed: {
    errorCodigo: {
      get() {
        return this.$store.state.error.error.produto.codigo;
      },
    },
    errorDescricao: {
      get() {
        return this.$store.state.error.error.produto.descricao;
      },
    },

    errorNcm: {
      get() {
        return this.$store.state.error.error.produto.ncm;
      },
    },
    errorTributacao: {
      get() {
        return this.$store.state.error.error.produto.tributacao;
      },
    },
    codigo: {
      get() {
        return this.$store.state.produto.produto.codigo;
      },
    },
    descricao: {
      get() {
        return this.$store.state.produto.produto.descricao;
      },
    },
  },
  data() {
    return {
      active_tab: 0,
      components: { TabPrincipal, TabCodigosBarras, TabPrecos, TabFiscal, TabEstoque },
      tabs: [
        { title: "Principal", component: "TabPrincipal" },
        { title: "Cód. de Barras", component: "TabCodigosBarras" },
        { title: "Preços", component: "TabPrecos" },
        { title: "Impostos", component: "TabFiscal" },
        { title: "Estoque", component: "TabEstoque" },
      ],
    };
  },
};
</script>

<style lang="scss" scoped></style>
