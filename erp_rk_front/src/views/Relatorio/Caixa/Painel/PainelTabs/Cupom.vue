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
      <v-data-table
        :headers="headers"
        :items="filteredPrecosMascarados"
        :items-per-page="10"
        class="elevation-1 linha-clicavel"
        style="margin-top: 20px"
        :sort-by.sync="sortBy"
        :sort-desc.sync="sortDesc"
        @click:row="carregarCupom"
      >
        <template v-slot:item.xml_venda="{ item }">
          <v-icon small :color="item.xml_venda ? 'success' : 'grey lighten-1'">mdi-file-document-outline</v-icon>
        </template>
        <template v-slot:item.xml_cancelamento="{ item }">
          <v-icon small v-if="item.xml_cancelamento" color="error">mdi-file-cancel-outline</v-icon>
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
    </v-container>

    <!-- Modal com o detalhamento completo do cupom -->
    <v-dialog v-model="dialogCupom" max-width="900" scrollable>
      <v-card>
        <v-card-title class="d-flex align-center">
          <v-icon left>mdi-receipt-text-outline</v-icon>
          Cupom {{ selectedCupom.numero }}
          <v-chip v-if="selectedCupom.cpf_consumidor" small outlined class="ml-3">
            <v-icon left x-small>mdi-account-outline</v-icon>
            {{ selectedCupom.cpf_consumidor }}
          </v-chip>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialogCupom = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <v-divider></v-divider>

        <v-progress-linear v-if="carregandoCupom" indeterminate color="primary"></v-progress-linear>

        <v-card-text class="pt-4">
          <v-row dense>
            <v-col cols="6" sm="3">
              <div class="text-caption grey--text">Data / Hora</div>
              <div>{{ selectedCupom.data }} {{ selectedCupom.hora }}</div>
            </v-col>
            <v-col cols="6" sm="3">
              <div class="text-caption grey--text">Caixa</div>
              <div>{{ selectedCupom.caixa }}</div>
            </v-col>
            <v-col cols="6" sm="3">
              <div class="text-caption grey--text">Qtd. Itens</div>
              <div>{{ selectedCupom.qtde_item_format }}</div>
            </v-col>
            <v-col cols="6" sm="3">
              <div class="text-caption grey--text">Valor Total</div>
              <div class="font-weight-bold">{{ selectedCupom.valor_total_format }}</div>
            </v-col>
          </v-row>

          <v-divider class="my-4"></v-divider>

          <div class="text-subtitle-2 mb-2">Itens</div>
          <v-data-table
            :headers="headersItens"
            :items="itensCuponsMask"
            :items-per-page="-1"
            hide-default-footer
            dense
            class="elevation-0 tabela-itens"
          >
            <template v-slot:item.cancelado="{ item }">
              <v-chip v-if="item.cancelado" x-small color="error" dark>CANCELADO</v-chip>
            </template>
            <template v-slot:no-data>
              <span class="grey--text">Nenhum item encontrado</span>
            </template>
          </v-data-table>

          <v-divider class="my-4"></v-divider>

          <v-row>
            <v-col cols="12" sm="7">
              <div class="text-subtitle-2 mb-2">Formas de Pagamento</div>
              <v-data-table
                :headers="headersFormas"
                :items="formasPagamentoMask"
                :items-per-page="-1"
                hide-default-footer
                dense
                class="elevation-0 tabela-itens"
              >
                <template v-slot:item.cancelado="{ item }">
                  <v-chip v-if="item.cancelado" x-small color="error" dark>CANCELADO</v-chip>
                </template>
                <template v-slot:no-data>
                  <span class="grey--text">Nenhuma forma de pagamento encontrada</span>
                </template>
              </v-data-table>
            </v-col>

            <v-col cols="12" sm="5">
              <v-sheet outlined rounded class="pa-4">
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Total do Cupom</span>
                  <span class="font-weight-medium">{{ selectedCupom.valor_total_format }}</span>
                </div>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Total Pago</span>
                  <span class="font-weight-medium">{{ maskMoney(totalPago) }}</span>
                </div>
                <v-divider class="my-2"></v-divider>
                <div class="d-flex justify-space-between">
                  <span class="grey--text">Troco</span>
                  <span class="font-weight-bold">{{ maskMoney(totalTroco) }}</span>
                </div>
              </v-sheet>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-app>
</template>

<script>
import { maskMoney, maskQtd } from "@/utils/masks";

export default {
  data() {
    return {
      sortBy: "",
      sortDesc: false,
      dialogCupom: false,
      carregandoCupom: false,
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
        { text: "", value: "cancelado" },
      ],
      headersFormas: [
        { text: "Forma de Pagamento", value: "descricao" },
        { text: "Parcela", value: "prestacao" },
        { text: "Vlr. Pago", value: "valor" },
        { text: "Troco", value: "valor_troco" },
        { text: "", value: "cancelado" },
      ],
      headers: [
        { text: "Número", value: "numero" },
        { text: "Data", value: "data" },
        { text: "Hora", value: "hora" },
        { text: "Caixa", value: "caixa" },
        { text: "Valor Total", value: "valor_total_original" },
        { text: "CPF Consumidor", value: "cpf_consumidor" },
        { text: "Qtd. Item", value: "qtde_item_original" },
        { text: "Venda", value: "xml_venda" },
        { text: "Cancel.", value: "xml_cancelamento" },
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
    cupomUnico() {
      return this.$store.state.relatorio.relatorioCupomUnico || { itens: [], formasPagamento: [] };
    },
    itensCupomList() {
      return this.cupomUnico.itens || [];
    },
    formasPagamentoList() {
      return this.cupomUnico.formasPagamento || [];
    },
    itensCuponsMask() {
      return this.itensCupomList.map((item) => ({
        ...item,
        valor_total: maskMoney(item.valor_total),
        valor_acrescimo: maskMoney(item.valor_acrescimo),
        valor_desconto: maskMoney(item.valor_desconto),
        valor_unitario: maskMoney(item.valor_unitario),
        qtde: maskQtd(item.qtde),
        cancelado: item.cancelado === 1,
      }));
    },
    formasPagamentoMask() {
      return this.formasPagamentoList.map((item) => ({
        ...item,
        descricao: item.descricao || item.codigo_finalizadora,
        valor: maskMoney(item.valor),
        valor_troco: maskMoney(item.valor_troco || 0),
        cancelado: item.cancelado === 1,
      }));
    },
    totalPago() {
      return this.formasPagamentoList.filter((item) => item.cancelado !== 1).reduce((acc, item) => acc + Number(item.valor || 0), 0);
    },
    totalTroco() {
      return this.formasPagamentoList.filter((item) => item.cancelado !== 1).reduce((acc, item) => acc + Number(item.valor_troco || 0), 0);
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
    maskMoney,
    carregarCupom(cupom) {
      this.selectedCupom = cupom;
      this.dialogCupom = true;
      this.carregandoCupom = true;
      this.$store.commit("setRelatorioCupomUnico", { itens: [], formasPagamento: [] });
      this.$store.dispatch("getCupomUnico", cupom).finally(() => {
        this.carregandoCupom = false;
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
      this.$store.commit("setRelatorioCupomUnico", { itens: [], formasPagamento: [] });
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
.linha-clicavel tbody tr {
  cursor: pointer;
}
.tabela-itens >>> table {
  background: transparent;
}
</style>
