<template>
  <v-app>
    <v-container>
      <v-data-table :headers="headers" :items="precosMascarados" :items-per-page="10" item-key="codigo_loja" class="elevation-1">
        <!-- Slots para exibir valores mascarados -->
        <template v-slot:item="{ item }">
          <tr>
            <td>{{ item.codigo_loja }}</td>
            <td>{{ item.nome_loja }}</td>
            <td>{{ item.codigo_finalizadora }}</td>
            <td>{{ item.nome_finalizadora }}</td>
            <td>{{ item.qtd_finalizacoes_format }}</td>
            <td>{{ item.venda_total_format }}</td>
            <td>{{ item.venda_troco_format }}</td>
            <td>{{ item.diferenca_venda_format }}</td>
          </tr>
        </template>

        <!-- Linha de totais -->
        <template v-slot:body.append>
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th class="title"></th>
            <th class="title"></th>
            <th class="title"></th>
            <th class="title">{{ maskQtd(sumField("qtd_finalizacoes")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_total")) }}</th>
            <th class="title">{{ maskMoney(sumField("venda_troco")) }}</th>
            <th class="title">{{ maskMoney(sumField("diferenca_venda")) }}</th>
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
        { text: "Cód", value: "codigo_loja" },
        { text: "Loja", value: "nome_loja" },
        { text: "Cod. Fin.", value: "codigo_finalizadora" },
        { text: "Finalizadora", value: "nome_finalizadora" },
        { text: "Qtd", value: "qtd_finalizacoes" },
        { text: "Entrada Total", value: "venda_total" },
        { text: "Troco Total", value: "venda_troco" },
        { text: "Total", value: "diferenca_venda" },
      ],
    };
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasFinalizadoras;
    },
    precosMascarados() {
      if (!this.relatorio) return [];
      return this.relatorio.map((venda) => ({
        ...venda,
        qtd_finalizacoes_format: maskQtd(venda.qtd_finalizacoes),
        venda_total_format: maskMoney(venda.venda_total),
        venda_troco_format: maskMoney(venda.venda_troco),
        diferenca_venda_format: maskMoney(venda.diferenca_venda),
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
