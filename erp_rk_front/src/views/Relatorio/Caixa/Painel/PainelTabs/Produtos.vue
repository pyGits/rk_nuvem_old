<template>
  <v-app>
    <v-container>
      <v-data-table :headers="headers" :items="precosMascarados" :items-per-page="10" item-key="barras_produto" class="elevation-1">
        <!-- Slots para exibir os valores mascarados -->
        <template v-slot:item.qtde="{ item }">
          {{ item.qtde_format }}
        </template>
        <template v-slot:item.custo_total="{ item }">
          {{ item.custo_total_format }}
        </template>
        <template v-slot:item.venda_total="{ item }">
          {{ item.venda_total_format }}
        </template>
        <template v-slot:item.venda_liquida="{ item }">
          {{ item.venda_liquida_format }}
        </template>
        <template v-slot:item.markup="{ item }">
          {{ item.markup_format }}
        </template>

        <!-- Linha de totais -->
        <template v-slot:body.append>
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th></th>
            <th>{{ maskQtd(sumField("qtde")) }}</th>
            <th>{{ maskMoney(sumField("custo_total")) }}</th>
            <th>{{ maskMoney(sumField("venda_total")) }}</th>
            <th>{{ maskMoney(sumField("venda_liquida")) }}</th>
          </tr>
        </template>
      </v-data-table>
    </v-container>
  </v-app>
</template>

<script>
import { maskAmount, maskMoney, maskQtd } from "@/utils/masks";

export default {
  data() {
    return {
      headers: [
        { text: "Cód Produto", value: "barras_produto" },
        { text: "Produto", value: "nome_produto" },
        { text: "Qtde", value: "qtde" },
        { text: "Custo Total", value: "custo_total" },
        { text: "Venda Total", value: "venda_total" },
        { text: "Venda Líquida", value: "venda_liquida" },
      ],
    };
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasProdutos;
    },
    precosMascarados() {
      if (!this.relatorio) return [];
      return this.relatorio.map((venda) => ({
        ...venda,
        qtde_format: maskQtd(venda.qtde),
        custo_total_format: maskMoney(venda.custo_total),
        venda_total_format: maskMoney(venda.venda_total),
        venda_liquida_format: maskMoney(venda.venda_liquida),
        markup_format: maskAmount(venda.markup),
      }));
    },
  },
  methods: {
    sumField(field) {
      if (!this.relatorio) return 0;
      return this.relatorio.reduce((acc, item) => acc + Number(item[field] || 0), 0);
    },
    maskQtd,
    maskMoney,
    maskAmount,
  },
};
</script>
