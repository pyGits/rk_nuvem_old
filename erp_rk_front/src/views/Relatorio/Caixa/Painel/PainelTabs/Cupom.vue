<template>
  <v-app>
    <v-container>
      <!-- Botão para exibir/ocultar filtros -->
      <v-row>
        <v-col cols="12">
          <v-btn color="primary" @click="toggleFilters">
            <v-icon left>mdi-filter-variant</v-icon>
            {{ showFilters ? "Ocultar Filtros" : "Exibir Filtros" }}
          </v-btn>
        </v-col>
      </v-row>

      <!-- Campos de filtro -->
      <v-row v-if="showFilters">
        <v-col cols="12">
          <v-sheet class="pa-4" elevation="1" rounded color="grey lighten-4">
            <v-row dense align="center">
              <v-col cols="12" sm="6">
                <v-subheader class="pl-0">Tipo de Relatório</v-subheader>
                <v-radio-group v-model="tipoRelatorio" row dense hide-details>
                  <v-radio label="Sintético" value="sintetico"></v-radio>
                  <v-radio label="Analítico" value="analitico"></v-radio>
                </v-radio-group>
              </v-col>
            </v-row>
            <v-row dense>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.numero" label="Número" outlined dense clearable></v-text-field>
              </v-col>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.caixa" label="Caixa" outlined dense clearable></v-text-field>
              </v-col>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.cpf_consumidor" label="CPF Consumidor" outlined dense clearable></v-text-field>
              </v-col>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.vendedor" label="Vendedor" outlined dense clearable></v-text-field>
              </v-col>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.valor_total" label="Valor da Venda" outlined dense clearable></v-text-field>
              </v-col>
              <v-col cols="6" sm="2">
                <v-text-field v-model="filterValues.xml_venda" label="Chave XML" outlined dense clearable></v-text-field>
              </v-col>
            </v-row>
            <v-row dense align="center">
              <v-col cols="12" sm="6">
                <v-subheader class="pl-0">Situação</v-subheader>
                <v-radio-group v-model="filterValues.cancelado" row dense hide-details>
                  <v-radio label="Todos" value=""></v-radio>
                  <v-radio label="Cancelados" value="1"></v-radio>
                  <v-radio label="Normais" value="0"></v-radio>
                </v-radio-group>
              </v-col>
              <v-col cols="12" sm="6" class="d-flex justify-end align-center">
                <v-btn color="primary" @click="applyFilter">
                  <v-icon left>mdi-filter</v-icon>
                  Aplicar Filtro
                </v-btn>
                <v-btn class="ml-2" outlined @click="limparFiltro">
                  <v-icon left>mdi-filter-remove</v-icon>
                  Limpar Filtros
                </v-btn>
              </v-col>
            </v-row>
          </v-sheet>
        </v-col>
      </v-row>

      <!-- Tabela principal (sintético) -->
      <v-data-table
        v-if="tipoRelatorio === 'sintetico'"
        :headers="headers"
        :items="filteredPrecosMascarados"
        :items-per-page="10"
        class="elevation-1 linha-clicavel"
        style="margin-top: 20px"
        :sort-by.sync="sortBy"
        :sort-desc.sync="sortDesc"
        :item-class="rowClass"
        @click:row="carregarCupom"
      >
        <template v-slot:item.data="{ item }">
          {{ formatDateBR(item.data) }}
        </template>
        <template v-slot:item.xml_venda="{ item }">
          <span class="chave-xml-text">{{ item.xml_venda || "-" }}</span>
        </template>
        <template v-slot:item.cancelado="{ item }">
          <v-chip x-small :color="item.cancelado == 1 ? 'error' : 'success'" dark :title="item.cancelado == 1 ? item.xml_cancelamento : ''">
            {{ item.cancelado == 1 ? "CANCELADO" : "NORMAL" }}
          </v-chip>
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
            <th class="title"></th>
            <th class="title"></th>
          </tr>
        </template>
      </v-data-table>

      <!-- Cupom a cupom (analítico) -->
      <div v-else style="margin-top: 20px">
        <v-progress-linear v-if="carregandoAnalitico" indeterminate color="primary" class="mb-4"></v-progress-linear>

        <div v-if="!carregandoAnalitico && !filteredPrecosMascarados.length" class="grey--text text-center pa-6">Nenhum cupom encontrado</div>

        <v-card v-for="cupom in cuponsAnaliticoPaginados" :key="cupom.data + '_' + cupom.caixa + '_' + cupom.codigo" outlined class="mb-4" :class="{ 'cupom-cancelado-card': cupom.cancelado == 1 }">
          <v-card-title class="d-flex align-center flex-wrap">
            <v-icon left>mdi-receipt-text-outline</v-icon>
            Cupom {{ cupom.numero }}
            <v-chip x-small class="ml-3" :color="cupom.cancelado == 1 ? 'error' : 'success'" dark :title="cupom.cancelado == 1 ? cupom.xml_cancelamento : ''">
              {{ cupom.cancelado == 1 ? "CANCELADO" : "NORMAL" }}
            </v-chip>
            <v-chip v-if="cupom.cpf_consumidor" small outlined class="ml-2">
              <v-icon left x-small>mdi-account-outline</v-icon>
              {{ cupom.cpf_consumidor }}
            </v-chip>
            <v-spacer></v-spacer>
            <span class="chave-xml-text grey--text">{{ cupom.xml_venda || "-" }}</span>
          </v-card-title>

          <v-divider></v-divider>

          <v-card-text class="pt-4">
            <v-row dense>
              <v-col cols="6" sm="3">
                <div class="text-caption grey--text">Data / Hora</div>
                <div>{{ formatDateBR(cupom.data) }} {{ cupom.hora }}</div>
              </v-col>
              <v-col cols="6" sm="3">
                <div class="text-caption grey--text">Caixa</div>
                <div>{{ cupom.caixa }}</div>
              </v-col>
              <v-col cols="6" sm="3">
                <div class="text-caption grey--text">Qtd. Itens</div>
                <div>{{ cupom.qtde_item_format }}</div>
              </v-col>
              <v-col cols="6" sm="3">
                <div class="text-caption grey--text">Valor Total</div>
                <div class="font-weight-bold">{{ cupom.valor_total_format }}</div>
              </v-col>
            </v-row>

            <v-divider class="my-4"></v-divider>

            <div class="text-subtitle-2 mb-2">Itens</div>
            <v-data-table :headers="headersItens" :items="itensPorCupom(cupom)" :items-per-page="-1" hide-default-footer dense class="elevation-0 tabela-itens">
              <template v-slot:item.cancelado="{ item }">
                <v-chip v-if="item.cancelado" x-small color="error" dark>CANCELADO</v-chip>
              </template>
              <template v-slot:no-data>
                <span class="grey--text">Nenhum item encontrado</span>
              </template>
            </v-data-table>

            <v-divider class="my-4"></v-divider>

            <div class="text-subtitle-2 mb-2">Formas de Pagamento</div>
            <v-data-table :headers="headersFormas" :items="formasPorCupom(cupom)" :items-per-page="-1" hide-default-footer dense class="elevation-0 tabela-itens">
              <template v-slot:item.cancelado="{ item }">
                <v-chip v-if="item.cancelado" x-small color="error" dark>CANCELADO</v-chip>
              </template>
              <template v-slot:no-data>
                <span class="grey--text">Nenhuma forma de pagamento encontrada</span>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>

        <div class="d-flex justify-center" v-if="totalPaginasAnalitico > 1">
          <v-pagination v-model="paginaAnalitico" :length="totalPaginasAnalitico" total-visible="7"></v-pagination>
        </div>
      </div>
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
              <div>{{ formatDateBR(selectedCupom.data) }} {{ selectedCupom.hora }}</div>
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
import { maskMoney, maskQtd, maskDateBR } from "@/utils/masks";

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
        { text: "Chave XML", value: "xml_venda" },
        { text: "Situação", value: "cancelado" },
      ],
      filterValues: {
        numero: "",
        loja: "",
        hora: "",
        caixa: "",
        valor_total: "",
        codigo_cliente: "",
        cancelado: "",
        cpf_consumidor: "",
        vendedor: "",
        xml_venda: "",
        xml_cancelamento: "",
      },
      filteredPrecosMascarados: [],
      selectedCupom: {},
      showFilters: false,
      tipoRelatorio: "sintetico",
      carregandoAnalitico: false,
      paginaAnalitico: 1,
      itensPorPaginaAnalitico: 10,
    };
  },
  mounted() {
    this.$store.dispatch("getLojas");
    this.$store.dispatch("getClientes");
    this.$store.dispatch("getFuncionarios");
  },
  watch: {
    relatorio() {
      this.applyFilter();
      if (this.tipoRelatorio === "analitico") this.carregarAnalitico();
    },
    tipoRelatorio(valor) {
      this.paginaAnalitico = 1;
      if (valor === "analitico") this.carregarAnalitico();
    },
    filteredPrecosMascarados() {
      this.paginaAnalitico = 1;
    },
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
    relatorioAnalitico() {
      return this.$store.state.relatorio.relatorioPainelVendasCupomAnalitico || { itens: [], formasPagamento: [] };
    },
    itensPorCupomMap() {
      const map = {};
      (this.relatorioAnalitico.itens || []).forEach((item) => {
        const key = this.chaveCupom(item);
        if (!map[key]) map[key] = [];
        map[key].push({
          ...item,
          valor_total: maskMoney(item.valor_total),
          valor_acrescimo: maskMoney(item.valor_acrescimo),
          valor_desconto: maskMoney(item.valor_desconto),
          valor_unitario: maskMoney(item.valor_unitario),
          qtde: maskQtd(item.qtde),
          cancelado: item.cancelado === 1,
        });
      });
      return map;
    },
    formasPorCupomMap() {
      const map = {};
      (this.relatorioAnalitico.formasPagamento || []).forEach((item) => {
        const key = this.chaveCupom(item);
        if (!map[key]) map[key] = [];
        map[key].push({
          ...item,
          descricao: item.descricao || item.codigo_finalizadora,
          valor: maskMoney(item.valor),
          valor_troco: maskMoney(item.valor_troco || 0),
          cancelado: item.cancelado === 1,
        });
      });
      return map;
    },
    totalPaginasAnalitico() {
      return Math.ceil(this.filteredPrecosMascarados.length / this.itensPorPaginaAnalitico) || 1;
    },
    cuponsAnaliticoPaginados() {
      const inicio = (this.paginaAnalitico - 1) * this.itensPorPaginaAnalitico;
      return this.filteredPrecosMascarados.slice(inicio, inicio + this.itensPorPaginaAnalitico);
    },
  },
  methods: {
    maskMoney,
    formatDateBR(date) {
      if (!date) return "";
      try {
        return maskDateBR(date);
      } catch (e) {
        return date;
      }
    },
    rowClass(item) {
      return item.cancelado == 1 ? "cupom-cancelado-row" : "";
    },
    chaveCupom(item) {
      return `${item.data}_${item.caixa}_${item.codigo_cupom || item.codigo}_${item.loja}`;
    },
    itensPorCupom(cupom) {
      return this.itensPorCupomMap[this.chaveCupom(cupom)] || [];
    },
    formasPorCupom(cupom) {
      return this.formasPorCupomMap[this.chaveCupom(cupom)] || [];
    },
    carregarAnalitico() {
      this.carregandoAnalitico = true;
      this.$store.dispatch("getPainelVendasCupomAnalitico").finally(() => {
        this.carregandoAnalitico = false;
      });
    },
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
          const filtro = this.filterValues[key];
          if (filtro === "" || filtro === null || filtro === undefined) continue;
          const valor = item[key];
          if (valor === null || valor === undefined) return false;
          if (!valor.toString().toLowerCase().includes(filtro.toString().toLowerCase())) return false;
        }
        return true;
      });
    },
    toggleFilters() {
      this.showFilters = !this.showFilters;
    },
    limparFiltro() {
      for (let key in this.filterValues) {
        this.filterValues[key] = "";
      }
      this.applyFilter();
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
.linha-clicavel >>> .cupom-cancelado-row {
  background-color: #ffebee !important;
  color: #c62828 !important;
}
.linha-clicavel >>> .cupom-cancelado-row:hover {
  background-color: #ffcdd2 !important;
}
.chave-xml-text {
  font-family: monospace;
  font-size: 0.8rem;
}
.cupom-cancelado-card {
  border-color: #ef9a9a !important;
  background-color: #fff5f5;
}
</style>
