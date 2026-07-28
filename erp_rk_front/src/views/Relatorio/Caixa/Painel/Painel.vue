<template>
  <v-card>
    <v-card-title>Painel de Vendas</v-card-title>

    <v-container>
      <v-row>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example">Data Início:</label>
          <input type="date" class="form-control" v-model="dtInicio" />
        </v-col>
        <v-col cols="12" sm="3">
          <label class="form-label" for="input-example">Data Fim:</label>
          <input type="date" class="form-control" v-model="dtFim" />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" sm="2">
          <v-btn color="primary" class="mr-2" @click="gerarRelatorio(false)">Atualizar</v-btn>
        </v-col>
        <v-col cols="12" sm="2">
          <v-btn color="seccondary" class="mr-2" @click="gerarRelatorio(true)">Gerar Excel</v-btn>
        </v-col>
      </v-row>
      <!-- <bar-chart :data="chartData" :labels="chartLabels"></bar-chart> -->
    </v-container>
    <v-row>
      <v-col cols="12">
        <v-tabs v-model="activeTab">
          <v-tab v-for="(tab, index) in tabs" :key="index">
            {{ tab.title }}
          </v-tab>
        </v-tabs>
      </v-col>
      <v-col cols="12">
        <v-tabs-items v-model="activeTab" touchless>
          <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
            <component :is="tab.content"></component>
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import TabLojas from "./PainelTabs/Lojas.vue";
import TabProdutos from "./PainelTabs/Produtos.vue";
import TabCaixas from "./PainelTabs/Caixas.vue";
import TabFinalizadoras from "./PainelTabs/Finalizadoras.vue";
import TabSecoes from "./PainelTabs/Secoes.vue";
import TabCupom from "./PainelTabs/Cupom.vue";
import { gerarExcel } from "@/utils/exports";
export default {
  name: "Dashboard",
  components: {
    TabLojas,
  },
  methods: {
    async gerarRelatorio(excel) {
      this.$store.commit("setContainerLoading", true);
      if (this.activeTab === 0) {
        // lojas
        await this.$store.dispatch("getPainelVendasLojas");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasLojas);
        }
      }
      if (this.activeTab === 1) {
        await this.$store.dispatch("getPainelVendasCaixas");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasCaixas);
        }
      }
      if (this.activeTab === 2) {
        await this.$store.dispatch("getPainelVendasProdutos");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasProdutos);
        }
      }
      if (this.activeTab === 3) {
        await this.$store.dispatch("getPainelVendasFinalizadoras");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasFinalizadoras);
        }
      }
      if (this.activeTab === 4) {
        await this.$store.dispatch("getPainelVendasSecoes");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasSecoes);
        }
      }
      if (this.activeTab === 5) {
        await this.$store.dispatch("getPainelVendasCupom");
        if (excel) {
          gerarExcel(this.$store.state.relatorio.relatorioPainelVendasCupom);
        }
      }
      this.$store.commit("setContainerLoading", false);
    },
  },
  computed: {
    dtInicio: {
      get() {
        return this.$store.state.relatorio.filtro.dtInicio;
      },
      set(valor) {
        this.$store.commit("setRelatorioDtInicio", valor);
      },
    },
    dtFim: {
      get() {
        return this.$store.state.relatorio.filtro.dtFim;
      },
      set(valor) {
        this.$store.commit("setRelatorioDtFim", valor);
      },
    },
  },
  data() {
    return {
      activeTab: 0,
      tabs: [
        { title: "Lojas", content: TabLojas },
        { title: "Caixas", content: TabCaixas },
        { title: "Produtos", content: TabProdutos },
        { title: "Finalizadora", content: TabFinalizadoras },
        { title: "Seção", content: TabSecoes },
        { title: "Cupom", content: TabCupom },
      ],
    };
  },
};
</script>
