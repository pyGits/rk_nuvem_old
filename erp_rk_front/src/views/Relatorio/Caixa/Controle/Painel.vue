<template>
  <v-card>
    <v-card-title>Painel Controle Caixa</v-card-title>
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
          <v-btn color="primary" class="mr-2" @click="gerarRelatorio(false)"
            >Atualizar</v-btn
          >
        </v-col>
        <v-col cols="12" sm="2">
          <v-btn color="seccondary" class="mr-2" @click="gerarRelatorio(true)"
            >Gerar Excel</v-btn
          >
        </v-col>
      </v-row>
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
        <v-tabs-items v-model="activeTab">
          <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
            <component :is="tab.content"></component>
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-card>
</template>

<script>
import TabSangria from "./PainelTabs/Sangria.vue";
import TabReforco from "./PainelTabs/Reforco.vue";
import TabFechamento from "./PainelTabs/Fechamento.vue";
import { getCurrentDate } from "@/utils/date";
import { gerarExcel } from "@/utils/exports";
export default {
  data() {
    return {
      dtInicio: getCurrentDate(),
      dtFim: getCurrentDate(),
      activeTab: 0,
      tabs: [
        { title: "Fechamento", content: TabFechamento },
        { title: "Reforço", content: TabReforco },
        { title: "Sangria", content: TabSangria },
      ],
    };
  },

  methods: {
    async gerarRelatorio(excel) {
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("setFechamentoFormaList", []);
      if (this.activeTab === 0) {
        await this.$store.dispatch("getFechamentos", {
          dtInicio: this.dtInicio,
          dtFim: this.dtFim,
        });
        if (excel) {
          gerarExcel(this.$store.state.fechamento.fechamentoList);
        }
      } else if (this.activeTab === 1) {
        await this.$store.dispatch("getReforcos", {
          dtInicio: this.dtInicio,
          dtFim: this.dtFim,
        });
        if (excel) {
          gerarExcel(this.$store.state.naofiscal.reforcoList);
        }
      } else if (this.activeTab === 2) {
        await this.$store.dispatch("getSangrias", {
          dtInicio: this.dtInicio,
          dtFim: this.dtFim,
        });
        if (excel) {
          gerarExcel(this.$store.state.naofiscal.sangriaList);
        }
      }
      this.$store.commit("setContainerLoading", false);
    },
  },
};
</script>

<style lang="scss" scoped></style>
