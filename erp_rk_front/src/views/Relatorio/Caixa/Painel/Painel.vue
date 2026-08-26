<template>
  <v-card class="painel-vendas" flat>
    <CabecalhoRelatorio
      titulo="Painel de Vendas"
      :subtitulo="resumoFiltro"
      icone="mdi-chart-box-outline"
      :carregando="carregando"
      :sem-dados="semDados"
      @atualizar="gerarRelatorio()"
      @exportar="exportarExcel"
    />

    <div class="px-6">
      <FiltroPeriodo :dt-inicio.sync="dtInicio" :dt-fim.sync="dtFim" @alterado="gerarRelatorio()">
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
      </FiltroPeriodo>
    </div>

    <v-tabs v-model="activeTab" show-arrows class="px-4">
      <v-tab v-for="(tab, index) in tabs" :key="index">
        <v-icon small left>{{ tab.icon }}</v-icon>
        {{ tab.title }}
      </v-tab>
    </v-tabs>
    <v-divider></v-divider>

    <v-tabs-items v-model="activeTab" touchless>
      <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
        <EstadoVazio v-if="!carregando && semDados" />
        <component v-else :is="tab.content" :ref="'conteudoAba' + index"></component>
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
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import FiltroPeriodo from "@/components/Relatorio/FiltroPeriodo.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import { gerarExcel } from "@/utils/exports";
import { getCurrentDate } from "@/utils/date";

export default {
  name: "Dashboard",
  components: { CabecalhoRelatorio, FiltroPeriodo, EstadoVazio },
  data() {
    return {
      activeTab: 0,
      carregando: false,
      carregandoLojas: false,
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
    };
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
    loja: {
      get() {
        return this.$store.state.relatorio.filtro.loja;
      },
      set(valor) {
        this.$store.commit("setRelatorioLoja", valor || 0);
        this.gerarRelatorio();
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
    semDados() {
      return (this.$store.state.relatorio[this.tabs[this.activeTab].chave] || []).length === 0;
    },
  },
  watch: {
    // Trocar de aba busca os dados daquela aba, sem precisar clicar em Atualizar.
    activeTab() {
      this.gerarRelatorio();
    },
  },
  async mounted() {
    this.carregandoLojas = true;
    try {
      await this.$store.dispatch("getLojas");
    } finally {
      this.carregandoLojas = false;
    }
    this.gerarRelatorio();
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      const [ano, mes, dia] = String(data).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    async gerarRelatorio() {
      if (this.periodoInvalido) return;

      const tab = this.tabs[this.activeTab];
      this.carregando = true;
      this.$store.commit("setContainerLoading", true);
      try {
        await this.$store.dispatch(tab.action);
      } finally {
        this.$store.commit("setContainerLoading", false);
        this.carregando = false;
      }
    },
    // O Excel sai com os mesmos dados da tela: reconsulta com o período/loja
    // atuais e, se a aba tiver filtros próprios (Cupom), pede a ela a lista já
    // filtrada em vez de exportar o resultado bruto da consulta.
    async exportarExcel() {
      if (this.periodoInvalido) return;

      const tab = this.tabs[this.activeTab];
      await this.gerarRelatorio();

      const [aba] = this.$refs["conteudoAba" + this.activeTab] || [];
      const linhas = aba && aba.linhasParaExportar ? await aba.linhasParaExportar() : this.$store.state.relatorio[tab.chave] || [];
      gerarExcel(linhas);
    },
    limparFiltros() {
      this.$store.commit("setRelatorioDtInicio", getCurrentDate());
      this.$store.commit("setRelatorioDtFim", getCurrentDate());
      this.$store.commit("setRelatorioLoja", 0);
      this.gerarRelatorio();
    },
  },
};
</script>

<style scoped>
.painel-vendas >>> .v-data-table th {
  white-space: nowrap;
}
</style>
