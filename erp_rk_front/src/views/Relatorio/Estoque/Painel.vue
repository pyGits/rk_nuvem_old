<template>
  <v-card flat>
    <CabecalhoRelatorio
      titulo="Painel de Estoque"
      subtitulo="Saldo por produto, com filtros de seção, grupo, fornecedor e loja"
      icone="mdi-warehouse"
      :mostrar-atualizar="false"
      :mostrar-exportar="false"
    />

    <v-tabs v-model="activeTab" show-arrows class="px-4">
      <v-tab v-for="(tab, index) in tabs" :key="index">
        <v-icon small left>{{ tab.icon }}</v-icon>
        {{ tab.title }}
      </v-tab>
    </v-tabs>
    <v-divider></v-divider>

    <v-tabs-items v-model="activeTab">
      <v-tab-item v-for="(tab, index) in tabs" :key="index" :value="index">
        <component :is="tab.content"></component>
      </v-tab-item>
    </v-tabs-items>
  </v-card>
</template>

<script>
import TabSaldo from "./PainelTabs/Saldo.vue";
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";

export default {
  components: { CabecalhoRelatorio },
  data() {
    return {
      activeTab: 0,
      // A busca fica dentro da aba, que tem filtros próprios — por isso o
      // cabeçalho aqui não exibe Atualizar/Excel.
      tabs: [
        { title: "Saldo", icon: "mdi-package-variant", content: TabSaldo },
        // { title: "Extrato", content: TabExtrato },
      ],
    };
  },
};
</script>
