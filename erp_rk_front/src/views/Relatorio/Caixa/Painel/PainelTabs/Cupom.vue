<template>
  <v-app>
    <v-container>
      <!-- Os filtros de venda ficam no topo do painel, valendo para todas as
           abas. Aqui sobra só a forma de apresentar o cupom. -->
      <v-row dense align="center">
        <v-col cols="12" sm="6">
          <v-subheader class="pl-0">Tipo de Relatório</v-subheader>
          <v-radio-group v-model="tipoRelatorio" row dense hide-details class="mt-0">
            <v-radio label="Sintético" value="sintetico"></v-radio>
            <v-radio label="Analítico" value="analitico"></v-radio>
          </v-radio-group>
        </v-col>
      </v-row>

      <!-- Tabela principal (sintético) -->
      <v-data-table
        v-if="tipoRelatorio === 'sintetico'"
        :headers="headers"
        :items="cupons"
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
        <template v-slot:item.cliente_nome="{ item }">
          <span v-if="item.cliente_nome">{{ descricaoCliente(item) }}</span>
          <span v-else class="grey--text">-</span>
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

        <div v-if="!carregandoAnalitico && !cupons.length" class="grey--text text-center pa-6">Nenhum cupom encontrado</div>

        <v-card v-for="cupom in cuponsAnaliticoPaginados" :key="cupom.data + '_' + cupom.caixa + '_' + cupom.codigo" outlined class="mb-4" :class="{ 'cupom-cancelado-card': cupom.cancelado == 1 }">
          <v-card-title class="d-flex align-center flex-wrap">
            <v-icon left>mdi-receipt-text-outline</v-icon>
            Cupom {{ cupom.numero }}
            <v-chip x-small class="ml-3" :color="cupom.cancelado == 1 ? 'error' : 'success'" dark :title="cupom.cancelado == 1 ? cupom.xml_cancelamento : ''">
              {{ cupom.cancelado == 1 ? "CANCELADO" : "NORMAL" }}
            </v-chip>
            <v-chip v-if="cupom.cpf_consumidor" small outlined class="ml-2">
              <v-icon left x-small>mdi-card-account-details-outline</v-icon>
              {{ cupom.cpf_consumidor }}
            </v-chip>
            <v-chip v-if="cupom.cliente_nome" small outlined color="primary" class="ml-2">
              <v-icon left x-small>mdi-account-outline</v-icon>
              {{ descricaoCliente(cupom) }}
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
              <v-col cols="12" sm="6">
                <div class="text-caption grey--text">Cliente</div>
                <div>{{ cupom.cliente_nome ? descricaoCliente(cupom) : "Não identificado" }}</div>
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
            <v-icon left x-small>mdi-card-account-details-outline</v-icon>
            {{ selectedCupom.cpf_consumidor }}
          </v-chip>
          <v-chip v-if="selectedCupom.cliente_nome" small outlined color="primary" class="ml-2">
            <v-icon left x-small>mdi-account-outline</v-icon>
            {{ descricaoCliente(selectedCupom) }}
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
            <v-col cols="12" sm="6">
              <div class="text-caption grey--text">Cliente</div>
              <div>{{ selectedCupom.cliente_nome ? descricaoCliente(selectedCupom) : "Não identificado" }}</div>
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
        { text: "Cliente", value: "cliente_nome" },
        { text: "Qtd. Item", value: "qtde_item_original" },
        { text: "Chave XML", value: "xml_venda" },
        { text: "Situação", value: "cancelado" },
      ],
      selectedCupom: {},
      tipoRelatorio: "sintetico",
      carregandoAnalitico: false,
      paginaAnalitico: 1,
      itensPorPaginaAnalitico: 10,
    };
  },
  watch: {
    relatorio() {
      this.paginaAnalitico = 1;
      if (this.tipoRelatorio === "analitico") this.carregarAnalitico();
    },
    tipoRelatorio(valor) {
      this.paginaAnalitico = 1;
      if (valor === "analitico") this.carregarAnalitico();
    },
  },
  computed: {
    relatorio() {
      return this.$store.state.relatorio.relatorioPainelVendasCupom;
    },
    // A consulta já vem filtrada do backend; aqui só entram os campos de tela.
    cupons() {
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
    relatorioAnalitico() {
      return this.$store.state.relatorio.relatorioPainelVendasCupomAnalitico || { itens: [], formasPagamento: [] };
    },
    itensPorCupomMap() {
      return this.mapearPorCupom(this.relatorioAnalitico.itens, (item) => ({
        ...item,
        valor_total: maskMoney(item.valor_total),
        valor_acrescimo: maskMoney(item.valor_acrescimo),
        valor_desconto: maskMoney(item.valor_desconto),
        valor_unitario: maskMoney(item.valor_unitario),
        qtde: maskQtd(item.qtde),
        cancelado: item.cancelado === 1,
      }));
    },
    formasPorCupomMap() {
      return this.mapearPorCupom(this.relatorioAnalitico.formasPagamento, (item) => ({
        ...item,
        descricao: item.descricao || item.codigo_finalizadora,
        valor: maskMoney(item.valor),
        valor_troco: maskMoney(item.valor_troco || 0),
        cancelado: item.cancelado === 1,
      }));
    },
    totalPaginasAnalitico() {
      return Math.ceil(this.cupons.length / this.itensPorPaginaAnalitico) || 1;
    },
    cuponsAnaliticoPaginados() {
      const inicio = (this.paginaAnalitico - 1) * this.itensPorPaginaAnalitico;
      return this.cupons.slice(inicio, inicio + this.itensPorPaginaAnalitico);
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
    // O backend resolve o cliente do cupom pelo código gravado na venda ou,
    // quando só veio o CPF do consumidor, pelo CNPJ/CPF do cadastro.
    descricaoCliente(cupom) {
      if (!cupom || !cupom.cliente_nome) return "";
      return `${cupom.cliente_codigo} - ${cupom.cliente_nome}`.trim();
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
      return this.$store.dispatch("getPainelVendasCupomAnalitico").finally(() => {
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
      const total = this.cupons.reduce((acc, item) => acc + Number(item[field] || 0), 0);
      return maskQtd(total);
    },
    // Chamado pelo Painel na exportação. Os campos *_original/*_format existem
    // só para a tela; no Excel o cupom vai como veio da consulta.
    //
    // No sintético sai a tabela de cupons de sempre. No analítico o Excel sai
    // na mesma ordem da tela: a linha do cupom, os itens dele logo abaixo e
    // depois as formas de pagamento, um bloco por cupom.
    async linhasParaExportar() {
      if (this.tipoRelatorio !== "analitico") {
        return this.cuponsParaExportar();
      }

      // O Painel reconsulta o sintético antes de exportar; o analítico é uma
      // segunda consulta, por isso é esperada aqui antes de montar a planilha.
      await this.carregarAnalitico();

      return {
        abas: [
          {
            nome: "Cupons",
            matriz: this.matrizAnalitica(),
            larguras: [13, 12, 11, 8, 8, 8, 16, 32, 12, 14, 12],
          },
        ],
      };
    },
    cuponsParaExportar() {
      const camposTela = ["valor_total_original", "qtde_item_original", "valor_total_format", "qtde_item_format"];
      return this.cupons.map((item) => {
        const cupom = { ...item };
        camposTela.forEach((campo) => delete cupom[campo]);
        return cupom;
      });
    },
    // Um bloco por cupom, cada trecho com o seu próprio cabeçalho. Os valores
    // vão como número para dar para somar/filtrar no Excel.
    matrizAnalitica() {
      const itensPorCupom = this.agruparPorCupom(this.relatorioAnalitico.itens);
      const formasPorCupom = this.agruparPorCupom(this.relatorioAnalitico.formasPagamento);
      const linhas = [];

      this.cupons.forEach((cupom) => {
        const chave = this.chaveCupom(cupom);
        const itens = itensPorCupom[chave] || [];
        const formas = formasPorCupom[chave] || [];

        linhas.push(["CUPOM", "Número", "Data", "Hora", "Caixa", "Loja", "CPF Consumidor", "Cliente", "Qtd. Itens", "Valor Total", "Situação"]);
        linhas.push([
          "",
          cupom.numero,
          this.formatDateBR(cupom.data),
          cupom.hora,
          cupom.caixa,
          cupom.loja,
          cupom.cpf_consumidor || "",
          cupom.cliente_nome ? this.descricaoCliente(cupom) : "",
          Number(cupom.qtde_item || 0),
          Number(cupom.valor_total || 0),
          cupom.cancelado == 1 ? "CANCELADO" : "NORMAL",
        ]);

        linhas.push(["ITENS", "Seq", "Cód. Prod.", "Nome Prod.", "UN", "Qtde.", "Vlr. Unitário", "Vlr. Desconto", "Vlr. Acréscimo", "Vlr. Total", "Situação"]);
        if (!itens.length) {
          linhas.push(["", "Nenhum item encontrado"]);
        }
        itens.forEach((item) => {
          linhas.push([
            "",
            item.item,
            item.codigo_barras,
            item.descricao,
            item.unidade,
            Number(item.qtde || 0),
            Number(item.valor_unitario || 0),
            Number(item.valor_desconto || 0),
            Number(item.valor_acrescimo || 0),
            Number(item.valor_total || 0),
            item.cancelado == 1 ? "CANCELADO" : "",
          ]);
        });

        linhas.push(["PAGAMENTOS", "Forma de Pagamento", "Parcela", "Vlr. Pago", "Troco", "Situação"]);
        if (!formas.length) {
          linhas.push(["", "Nenhuma forma de pagamento encontrada"]);
        }
        formas.forEach((forma) => {
          linhas.push([
            "",
            forma.descricao || forma.codigo_finalizadora,
            forma.prestacao,
            Number(forma.valor || 0),
            Number(forma.valor_troco || 0),
            forma.cancelado == 1 ? "CANCELADO" : "",
          ]);
        });

        // Linha em branco separando um cupom do próximo.
        linhas.push([]);
      });

      return linhas;
    },
    mapearPorCupom(lista, formatar) {
      const mapa = this.agruparPorCupom(lista);
      Object.keys(mapa).forEach((chave) => {
        mapa[chave] = mapa[chave].map(formatar);
      });
      return mapa;
    },
    agruparPorCupom(lista) {
      const mapa = {};
      (lista || []).forEach((registro) => {
        const chave = this.chaveCupom(registro);
        if (!mapa[chave]) mapa[chave] = [];
        mapa[chave].push(registro);
      });
      return mapa;
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
