<template>
  <v-app class="container">
    <v-card>
      <v-data-table :headers="headers" :items="precosMascarados" item-key="id">
        <template v-slot:item="{ item }">
          <tr>
            <td>{{ item.loja }}</td>
            <td>{{ item.qtd_clientes }}</td>
            <td>{{ item.venda }}</td>
            <td>{{ item.venda_custo }}</td>
            <td>{{ item.ticket_medio }}</td>
          </tr>
        </template>
        <template slot="body.append">
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th class="title">{{ sumField("qtd_clientes") }}</th>
            <th class="title">{{ sumField("venda") }}</th>
            <th class="title">{{ sumField("venda_custo") }}</th>
            <th class="title">{{ sumField("ticket_medio") }}</th>
          </tr>
        </template>
      </v-data-table>
    </v-card>
  </v-app>
</template>

<script>
import { maskAmount, maskMoney, maskQtd } from "@/utils/masks";

export default {
  data() {
    return {
      headers: [
        { text: "Nome", value: "nome" },
        { text: "N. de Clientes", value: "qtd_clientes" },
        { text: "Venda", value: "venda" },
        { text: "Custo", value: "venda_custo" },
        { text: "Ticket Médio", value: "ticket_medio" },
      ],
    };
  },
  computed: {
    precosMascarados() {
      return this.relatorio
        ? this.relatorio.map((venda) => {
            return {
              ...venda,
              venda: maskMoney(venda.venda),
              venda_custo: maskMoney(venda.venda_custo),
              ticket_medio: maskMoney(venda.ticket_medio),
            };
          })
        : [];
    },
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasLojas;
    },
  },
  methods: {
    sumField(field) {
      let total = 0;
      if (this.relatorio) {
        total = this.relatorio.reduce(
          (accumulator, item) => accumulator + Number(item[field]),
          0
        );
      }
      return maskQtd(total);
    },
  },
};
</script>
