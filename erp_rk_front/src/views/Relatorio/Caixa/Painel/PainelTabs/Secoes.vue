<template>
  <v-app>
    <v-container>
      <v-data-table :headers="headers" :items="precosMascarados" :items-per-page="10" item-key="codigo" class="elevation-1">
        <!-- Slots para exibir valores mascarados -->
        <template v-slot:item="{ item }">
          <tr>
            <td>{{ item.codigo }}</td>
            <td>{{ item.nome }}</td>
            <td>{{ item.qtde_format }}</td>
            <td>{{ item.venda_total_format }}</td>
            <td>{{ item.custo_total_format }}</td>
            <td>{{ item.venda_liquida_format }}</td>
          </tr>
        </template>

        <!-- Linha de totais -->
        <template v-slot:body.append>
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th class="title"></th>
            <th class="title">{{ maskQtd(sumField("qtde")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_total")) }}</th>
            <th class="title">{{ maskMoney(sumField("custo_total")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_liquida")) }}</th>
          </tr>
        </template>
      </v-data-table>
    </v-container>
  </v-app>
</template>

<script>
import { maskMoney, maskQtd } from "@/utils/masks";

export default {
  data() {
    return {
      headers: [
        { text: "Cód", value: "codigo" },
        { text: "Seção", value: "nome" },
        { text: "Qtde.", value: "qtde" },
        { text: "Venda Total", value: "venda_total" },
        { text: "Custo Total", value: "custo_total" },
        { text: "Venda Líquida", value: "venda_liquida" },
      ],
    };
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasSecoes;
    },
    precosMascarados() {
      if (!this.relatorio) return [];
      return this.relatorio.map((venda) => ({
        ...venda,
        qtde_format: maskQtd(venda.qtde),
        venda_total_format: maskMoney(venda.venda_total),
        custo_total_format: maskMoney(venda.custo_total),
        venda_liquida_format: maskMoney(venda.venda_liquida),
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
  },
};
</script>
