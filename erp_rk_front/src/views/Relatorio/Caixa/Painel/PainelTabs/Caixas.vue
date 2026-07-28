<template>
  <v-app>
    <v-container>
      <v-data-table :headers="headers" :items="precosMascarados" :items-per-page="10" item-key="codigo" class="elevation-1" :custom-sort="customSort" :sort-by.sync="sortBy" :sort-desc.sync="sortDesc">
        <!-- Slots para exibir os valores mascarados -->
        <template v-slot:item="{ item }">
          <tr>
            <td>{{ item.codigo }}</td>
            <td>{{ item.nome_loja }}</td>
            <td>{{ item.caixa }}</td>
            <td>{{ item.qtd_clientes_format }}</td>
            <td>{{ item.venda_format }}</td>
            <td>{{ item.venda_custo_format }}</td>
            <td>{{ item.venda_liquida_format }}</td>
          </tr>
        </template>

        <!-- Linha de totais -->
        <template v-slot:body.append>
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th class="title"></th>
            <th class="title"></th>
            <th class="title">{{ maskQtd(sumField("qtd_clientes")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_custo")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_liquida")) }}</th>
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
        { text: "Cód", value: "codigo" },
        { text: "Loja", value: "nome_loja" },
        { text: "Caixa", value: "caixa" },
        { text: "Qtd Clientes", value: "qtd_clientes" },
        { text: "Venda Total", value: "venda" },
        { text: "Custo Total", value: "venda_custo" },
        { text: "Venda Líquida", value: "venda_liquida" },
      ],
      sortBy: ["venda"], // coluna de ordenação inicial (vazia = nenhuma)
      sortDesc: [true], // direção da ordenação inicial
    };
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasCaixas;
    },
    precosMascarados() {
      if (!this.relatorio) return [];
      return this.relatorio.map((venda) => ({
        ...venda,
        qtd_clientes_format: maskQtd(venda.qtd_clientes),
        venda_format: maskMoney(venda.venda),
        venda_custo_format: maskMoney(venda.venda_custo),
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
    maskAmount,

    // Custom sort para garantir ordenação numérica
    customSort(items, sortBy, sortDesc) {
      if (!sortBy.length) return items;
      const field = sortBy[0];
      const desc = sortDesc[0];
      return items.slice().sort((a, b) => {
        let valA = Number(a[field]) || 0;
        let valB = Number(b[field]) || 0;
        return (valA - valB) * (desc ? -1 : 1);
      });
    },
  },
};
</script>
