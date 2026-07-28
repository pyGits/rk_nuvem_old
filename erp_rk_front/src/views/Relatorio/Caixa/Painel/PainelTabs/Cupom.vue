<template>
  <v-app>
    <v-container>
      <!-- Botão para exibir/ocultar filtros -->
      <v-row>
        <v-col cols="12">
          <v-btn color="primary" @click="toggleFilters">
            {{ showFilters ? "Ocultar Filtros" : "Exibir Filtros" }}
          </v-btn>
        </v-col>
      </v-row>

      <!-- Campos de filtro -->
      <v-row v-if="showFilters">
        <!-- ... seus campos de filtro permanecem iguais ... -->
      </v-row>

      <!-- Tabela principal -->
      <v-data-table :headers="headers" :items="filteredPrecosMascarados" :items-per-page="10" class="elevation-1" style="margin-top: 20px" :sort-by.sync="sortBy" :sort-desc.sync="sortDesc">
        <template v-slot:item="{ item }">
          <tr @click="carregarCupom(item)">
            <td>{{ item.numero }}</td>
            <td>{{ item.data }}</td>
            <td>{{ item.hora }}</td>
            <td>{{ item.caixa }}</td>
            <td>{{ item.valor_total_format }}</td>
            <td>{{ item.cpf_consumidor }}</td>
            <td>{{ item.qtde_item_format }}</td>
            <td>{{ item.xml_venda }}</td>
            <td>{{ item.xml_cancelamento }}</td>
          </tr>
        </template>

        <template slot="body.append">
          <tr class="blue--text">
            <th class="title">Totais</th>
            <th class="title"></th>
            <th class="title"></th>
            <th class="title"></th>
            <th class="title">{{ sumField("valor_total_original") }}</th>
            <th class="title"></th>
            <th class="title">{{ sumField("qtde_item_original") }}</th>
          </tr>
        </template>
      </v-data-table>

      <v-divider></v-divider>
      <h5>Itens do Cupom: {{ selectedCupom.numero }}</h5>

      <v-data-table :headers="headersItens" :items="itensCuponsMask" :items-per-page="10" class="elevation-1" style="margin-top: 20px" />
    </v-container>
  </v-app>
</template>

<script>
import { maskMoney, maskMoneyToFloat, maskQtd } from "@/utils/masks";

export default {
  data() {
    return {
      sortBy: "",
      sortDesc: false,
      headersItens: [
        { text: "Seq", value: "item" },
        { text: "Cód. Prod.", value: "codigo_barras" },
        { text: "Nome Prod.", value: "descricao" },
        { text: "UN", value: "unidade" },
        { text: "Qtde.", value: "qtde" },
        { text: "Vlr. Unitário", value: "valor_unitario" },
        { text: "Vlr. Desconto", value: "valor_desconto" },
        { text: "Vlr. Acréscimo", value: "valor_acrescimo" },
        { text: "Vlr. Total", value: "valor_total" },
        { text: "Cancelado", value: "cancelado" },
      ],
      headers: [
        { text: "Número", value: "numero" },
        { text: "Data", value: "data" },
        { text: "Hora", value: "hora" },
        { text: "Caixa", value: "caixa" },
        { text: "Valor Total", value: "valor_total_original" },
        { text: "CPF Consumidor", value: "cpf_consumidor" },
        { text: "Qtd. Item", value: "qtde_item_original" },
        { text: "XML Venda", value: "xml_venda" },
        { text: "XML Cancelamento", value: "xml_cancelamento" },
      ],
      filterValues: {
        numero: "",
        loja: "",
        hora: "",
        caixa: "",
        valor_total: "",
        codigo_cliente: "",
        cancelado: "0",
        cpf_consumidor: "",
        vendedor: "",
        xml_venda: "",
        xml_cancelamento: "",
      },
      filteredPrecosMascarados: [],
      selectedCupom: {},
      showFilters: false,
    };
  },
  mounted() {
    this.$store.dispatch("getLojas");
    this.$store.dispatch("getClientes");
    this.$store.dispatch("getFuncionarios");
  },
  watch: {
    relatorio: "applyFilter",
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasCupom;
    },
    precosMascarados() {
      return this.relatorio.map((item) => ({
        ...item,
        valor_total_original: item.valor_total,
        qtde_item_original: item.qtde_item,
        valor_total_format: maskMoney(item.valor_total),
        qtde_item_format: maskQtd(item.qtde_item),
      }));
    },
    itensCupomList: {
      get() {
        return this.$store.state.relatorio.relatorioCupomUnico;
      },
      set(valor) {
        this.selectedCupom = {};
        this.$store.commit("setRelatorioCupomUnico", valor);
      },
    },
    itensCuponsMask() {
      return this.itensCupomList.map((item) => ({
        ...item,
        valor_total: maskMoney(item.valor_total),
        valor_acrescimo: maskMoney(item.valor_acrescimo),
        valor_desconto: maskMoney(item.valor_desconto),
        valor_unitario: maskMoney(item.valor_unitario),
        qtde: maskQtd(item.qtde),
        cancelado: item.cancelado === 1 ? "CANCELADO" : "",
      }));
    },
    lojaList() {
      return this.$store.state.loja.lojaList;
    },
    clienteList() {
      return this.$store.state.cliente.clienteList;
    },
    funcionarioList() {
      return this.$store.state.funcionario.funcionarioList;
    },
  },
  methods: {
    carregarCupom(cupom) {
      this.selectedCupom = cupom;
      this.$store.commit("setContainerLoading", true);
      this.$store.dispatch("getCupomUnico", cupom).finally(() => {
        this.$store.commit("setContainerLoading", false);
      });
    },
    sumField(field) {
      let total = 0;
      if (this.filteredPrecosMascarados) {
        total = this.filteredPrecosMascarados.reduce((acc, item) => acc + Number(item[field] || 0), 0);
      }
      return maskQtd(total);
    },
    applyFilter() {
      this.itensCupomList = [];
      this.filteredPrecosMascarados = this.precosMascarados.filter((item) => {
        for (let key in this.filterValues) {
          if (this.filterValues[key] !== "" && item[key] && !item[key].toString().toLowerCase().includes(this.filterValues[key].toString().toLowerCase())) return false;
        }
        return true;
      });
    },
    toggleFilters() {
      this.showFilters = !this.showFilters;
    },
  },
};
</script>

<style>
.v-data-table {
  cursor: pointer;
}
</style>
