<template>
  <v-card class="painel-vendas" flat>
    <!-- Cabeçalho -->
    <div class="painel-header px-6 py-4">
      <div class="d-flex align-center flex-wrap">
        <v-icon large color="primary" class="mr-3">mdi-chart-box-outline</v-icon>
        <div>
          <h2 class="text-h5 font-weight-medium mb-0">Painel de Vendas</h2>
          <span class="text-caption grey--text text--darken-1">{{ resumoFiltro }}</span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" depressed class="mr-2" :loading="carregando" @click="gerarRelatorio(false)">
          <v-icon left>mdi-refresh</v-icon>
          Atualizar
        </v-btn>
        <v-btn color="green darken-1" outlined :disabled="carregando || semDados" @click="gerarRelatorio(true)">
          <v-icon left>mdi-file-excel-outline</v-icon>
          Excel
        </v-btn>
      </div>
    </div>

    <!-- Filtros -->
    <v-card outlined class="mx-6 mb-4">
      <v-card-text class="pb-2">
        <v-row dense align="center">
          <v-col cols="12" sm="6" md="3">
            <v-menu
              v-model="menuInicio"
              :close-on-content-click="false"
              transition="scale-transition"
              offset-y
              min-width="auto"
            >
              <template v-slot:activator="{ on, attrs }">
                <v-text-field
                  :value="formatarData(dtInicio)"
                  label="Data início"
                  prepend-inner-icon="mdi-calendar-start"
                  readonly
                  dense
                  outlined
                  hide-details
                  v-bind="attrs"
                  v-on="on"
                ></v-text-field>
              </template>
              <v-date-picker v-model="dtInicio" locale="pt-BR" no-title @input="menuInicio = false"></v-date-picker>
            </v-menu>
          </v-col>

          <v-col cols="12" sm="6" md="3">
            <v-menu
              v-model="menuFim"
              :close-on-content-click="false"
              transition="scale-transition"
              offset-y
              min-width="auto"
            >
              <template v-slot:activator="{ on, attrs }">
                <v-text-field
                  :value="formatarData(dtFim)"
                  label="Data fim"
                  prepend-inner-icon="mdi-calendar-end"
                  readonly
                  dense
                  outlined
                  hide-details
                  :error="periodoInvalido"
                  v-bind="attrs"
                  v-on="on"
                ></v-text-field>
              </template>
              <v-date-picker v-model="dtFim" locale="pt-BR" no-title :min="dtInicio" @input="menuFim = false"></v-date-picker>
            </v-menu>
          </v-col>

          <v-col cols="12" md="4">
            <v-autocomplete
              v-model="loja"
              :items="opcoesLoja"
              item-text="descricao"
              item-value="codigo"
              label="Loja"
              prepend-inner-icon="mdi-store-outline"
              dense
              outlined
              hide-details
              :loading="carregandoLojas"
            ></v-autocomplete>
          </v-col>

          <v-col cols="12" md="2" class="text-md-right">
            <v-btn text small color="grey darken-1" @click="limparFiltros">
              <v-icon left small>mdi-filter-remove-outline</v-icon>
              Limpar
            </v-btn>
          </v-col>
        </v-row>

        <!-- Atalhos de período -->
        <v-row dense class="mt-1">
          <v-col cols="12">
            <v-chip
              v-for="atalho in atalhos"
              :key="atalho.label"
              small
              outlined
              class="mr-2 mb-1"
              :color="atalhoAtivo === atalho.label ? 'primary' : ''"
              @click="aplicarAtalho(atalho)"
            >
              {{ atalho.label }}
            </v-chip>
          </v-col>
        </v-row>

        <v-alert v-if="periodoInvalido" type="warning" dense text class="mt-3 mb-0">
          A data fim é anterior à data início.
        </v-alert>
      </v-card-text>
    </v-card>

    <!-- Abas -->
    <v-tabs v-model="activeTab" show-arrows class="px-4">
      <v-tab v-for="(tab, index) in tabs" :key="index">
        <v-icon small left>{{ tab.icon }}</v-icon>
        {{ tab.title }}
      </v-tab>
    </v-tabs>
    <v-divider></v-divider>

    <v-tabs-items v-model="activeTab" touchless>
      <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
        <div v-if="!carregando && semDados" class="text-center py-12 grey--text">
          <v-icon size="56" color="grey lighten-1">mdi-database-off-outline</v-icon>
          <p class="mt-3 mb-0">Nenhum resultado para o período e a loja selecionados.</p>
        </div>
        <component v-else :is="tab.content"></component>
      </v-tab-item>
    </v-tabs-items>
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
import { getCurrentDate } from "@/utils/date";

export default {
  name: "Dashboard",
  data() {
    return {
      activeTab: 0,
      menuInicio: false,
      menuFim: false,
      carregando: false,
      carregandoLojas: false,
      atalhoAtivo: "Hoje",
      // Cada aba declara a action que busca os dados e a chave do state onde
      // eles ficam, para o Atualizar/Excel funcionarem sem encadear ifs.
      tabs: [
        { title: "Lojas", icon: "mdi-store", content: TabLojas, action: "getPainelVendasLojas", chave: "relatorioPainelVendasLojas" },
        { title: "Caixas", icon: "mdi-cash-register", content: TabCaixas, action: "getPainelVendasCaixas", chave: "relatorioPainelVendasCaixas" },
        { title: "Produtos", icon: "mdi-package-variant-closed", content: TabProdutos, action: "getPainelVendasProdutos", chave: "relatorioPainelVendasProdutos" },
        { title: "Finalizadora", icon: "mdi-credit-card-outline", content: TabFinalizadoras, action: "getPainelVendasFinalizadoras", chave: "relatorioPainelVendasFinalizadoras" },
        { title: "Seção", icon: "mdi-shape-outline", content: TabSecoes, action: "getPainelVendasSecoes", chave: "relatorioPainelVendasSecoes" },
        { title: "Cupom", icon: "mdi-receipt-text-outline", content: TabCupom, action: "getPainelVendasCupom", chave: "relatorioPainelVendasCupom" },
      ],
      atalhos: [
        { label: "Hoje", dias: 0 },
        { label: "Ontem", dias: 1, apenasDia: true },
        { label: "Últimos 7 dias", dias: 6 },
        { label: "Últimos 30 dias", dias: 29 },
        { label: "Este mês", mesAtual: true },
      ],
    };
  },
  computed: {
    dtInicio: {
      get() {
        return this.$store.state.relatorio.filtro.dtInicio;
      },
      set(valor) {
        this.$store.commit("setRelatorioDtInicio", valor);
        this.atalhoAtivo = "";
      },
    },
    dtFim: {
      get() {
        return this.$store.state.relatorio.filtro.dtFim;
      },
      set(valor) {
        this.$store.commit("setRelatorioDtFim", valor);
        this.atalhoAtivo = "";
      },
    },
    loja: {
      get() {
        return this.$store.state.relatorio.filtro.loja;
      },
      set(valor) {
        this.$store.commit("setRelatorioLoja", valor || 0);
      },
    },
    lojaList() {
      return this.$store.state.loja.lojaList || [];
    },
    opcoesLoja() {
      return [
        { codigo: 0, descricao: "Todas as lojas" },
        ...this.lojaList.map((l) => ({
          codigo: Number(l.codigo),
          descricao: `${l.codigo} - ${l.nome || l.fantasia || ""}`.trim(),
        })),
      ];
    },
    lojaSelecionada() {
      const opcao = this.opcoesLoja.find((o) => o.codigo === Number(this.loja));
      return opcao ? opcao.descricao : "Todas as lojas";
    },
    resumoFiltro() {
      return `${this.formatarData(this.dtInicio)} até ${this.formatarData(this.dtFim)} · ${this.lojaSelecionada}`;
    },
    periodoInvalido() {
      return !!this.dtInicio && !!this.dtFim && this.dtFim < this.dtInicio;
    },
    dadosAbaAtual() {
      return this.$store.state.relatorio[this.tabs[this.activeTab].chave] || [];
    },
    semDados() {
      return this.dadosAbaAtual.length === 0;
    },
  },
  watch: {
    // Trocar de aba busca os dados daquela aba, sem precisar clicar em Atualizar.
    activeTab() {
      this.gerarRelatorio(false);
    },
  },
  async mounted() {
    this.carregandoLojas = true;
    try {
      await this.$store.dispatch("getLojas");
    } finally {
      this.carregandoLojas = false;
    }
    this.gerarRelatorio(false);
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      const [ano, mes, dia] = data.split("-");
      return `${dia}/${mes}/${ano}`;
    },
    async gerarRelatorio(excel) {
      if (this.periodoInvalido) return;

      const tab = this.tabs[this.activeTab];
      this.carregando = true;
      this.$store.commit("setContainerLoading", true);
      try {
        await this.$store.dispatch(tab.action);
        if (excel) {
          gerarExcel(this.$store.state.relatorio[tab.chave]);
        }
      } finally {
        this.$store.commit("setContainerLoading", false);
        this.carregando = false;
      }
    },
    aplicarAtalho(atalho) {
      const hoje = new Date();
      const iso = (d) => d.toISOString().slice(0, 10);

      if (atalho.mesAtual) {
        this.$store.commit("setRelatorioDtInicio", iso(new Date(hoje.getFullYear(), hoje.getMonth(), 1)));
        this.$store.commit("setRelatorioDtFim", getCurrentDate());
      } else if (atalho.apenasDia) {
        const dia = new Date(hoje);
        dia.setDate(dia.getDate() - atalho.dias);
        this.$store.commit("setRelatorioDtInicio", iso(dia));
        this.$store.commit("setRelatorioDtFim", iso(dia));
      } else {
        const inicio = new Date(hoje);
        inicio.setDate(inicio.getDate() - atalho.dias);
        this.$store.commit("setRelatorioDtInicio", iso(inicio));
        this.$store.commit("setRelatorioDtFim", getCurrentDate());
      }

      this.atalhoAtivo = atalho.label;
      this.gerarRelatorio(false);
    },
    limparFiltros() {
      this.$store.commit("setRelatorioDtInicio", getCurrentDate());
      this.$store.commit("setRelatorioDtFim", getCurrentDate());
      this.$store.commit("setRelatorioLoja", 0);
      this.atalhoAtivo = "Hoje";
      this.gerarRelatorio(false);
    },
  },
};
</script>

<style scoped>
.painel-header {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
.painel-vendas >>> .v-data-table th {
  white-space: nowrap;
}
</style>
