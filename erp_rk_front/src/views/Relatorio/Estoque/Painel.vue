<template>
  <v-card>
    <v-card-title>Painel de Estoque</v-card-title>
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
import TabSaldo from "./PainelTabs/Saldo.vue";
export default {
  data() {
    return {
      activeTab: 0,
      tabs: [
        { title: "Saldo", content: TabSaldo },
        // { title: "Extrato", content: TabCaixas },
      ],
    };
  },
};
</script>

<style lang="scss" scoped></style>
