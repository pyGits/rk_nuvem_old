<template>
  <v-card flat>
    <CabecalhoRelatorio
      titulo="Controle de Caixa"
      :subtitulo="resumoFiltro"
      icone="mdi-cash-register"
      :carregando="carregando"
      :sem-dados="semDados"
      @atualizar="gerarRelatorio(false)"
      @exportar="gerarRelatorio(true)"
    />

    <div class="px-6">
      <FiltroPeriodo :dt-inicio.sync="dtInicio" :dt-fim.sync="dtFim" @alterado="gerarRelatorio(false)" />
    </div>

    <v-tabs v-model="activeTab" show-arrows class="px-4">
      <v-tab v-for="(tab, index) in tabs" :key="index">
        <v-icon small left>{{ tab.icon }}</v-icon>
        {{ tab.title }}
      </v-tab>
    </v-tabs>
    <v-divider></v-divider>

    <v-tabs-items v-model="activeTab">
      <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
        <EstadoVazio v-if="!carregando && semDados" />
        <component v-else :is="tab.content"></component>
      </v-tab-item>
    </v-tabs-items>
  </v-card>
</template>

<script>
import TabSangria from "./PainelTabs/Sangria.vue";
import TabReforco from "./PainelTabs/Reforco.vue";
import TabFechamento from "./PainelTabs/Fechamento.vue";
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import FiltroPeriodo from "@/components/Relatorio/FiltroPeriodo.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import { getCurrentDate } from "@/utils/date";
import { gerarExcel } from "@/utils/exports";

export default {
  components: { CabecalhoRelatorio, FiltroPeriodo, EstadoVazio },
  data() {
    return {
      dtInicio: getCurrentDate(),
      dtFim: getCurrentDate(),
      activeTab: 0,
      carregando: false,
      // Cada aba diz qual action busca os dados e onde eles ficam no store.
      tabs: [
        { title: "Fechamento", icon: "mdi-cash-check", content: TabFechamento, action: "getFechamentos", modulo: "fechamento", chave: "fechamentoList" },
        { title: "Reforço", icon: "mdi-cash-plus", content: TabReforco, action: "getReforcos", modulo: "naofiscal", chave: "reforcoList" },
        { title: "Sangria", icon: "mdi-cash-minus", content: TabSangria, action: "getSangrias", modulo: "naofiscal", chave: "sangriaList" },
      ],
    };
  },
  computed: {
    resumoFiltro() {
      return `${this.formatarData(this.dtInicio)} até ${this.formatarData(this.dtFim)}`;
    },
    periodoInvalido() {
      return !!this.dtInicio && !!this.dtFim && this.dtFim < this.dtInicio;
    },
    semDados() {
      const tab = this.tabs[this.activeTab];
      return (this.$store.state[tab.modulo][tab.chave] || []).length === 0;
    },
  },
  watch: {
    activeTab() {
      this.gerarRelatorio(false);
    },
  },
  mounted() {
    this.gerarRelatorio(false);
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      const [ano, mes, dia] = String(data).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    async gerarRelatorio(excel) {
      if (this.periodoInvalido) return;

      const tab = this.tabs[this.activeTab];
      this.carregando = true;
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("setFechamentoFormaList", []);
      try {
        await this.$store.dispatch(tab.action, {
          dtInicio: this.dtInicio,
          dtFim: this.dtFim,
        });
        if (excel) {
          gerarExcel(this.$store.state[tab.modulo][tab.chave]);
        }
      } finally {
        this.$store.commit("setContainerLoading", false);
        this.carregando = false;
      }
    },
  },
};
</script>
