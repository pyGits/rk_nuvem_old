<template>
  <div>
    <CabecalhoRelatorio
      titulo="Extrato do Cliente"
      :subtitulo="resumoFiltro"
      icone="mdi-account-cash-outline"
      :carregando="carregando"
      :sem-dados="!titulos.items.length"
      texto-atualizar="Gerar"
      @atualizar="gerar"
      @exportar="exportarExcel"
    />

    <div class="px-6">
      <FiltroPeriodo :dt-inicio.sync="filtro.dataVencimentoDe" :dt-fim.sync="filtro.dataVencimentoAte" @alterado="gerar">
        <v-col cols="12" md="5">
          <v-text-field :value="clienteDescricao" label="Cliente" readonly outlined dense hide-details prepend-inner-icon="mdi-account-outline" placeholder="Selecione o cliente">
            <template v-slot:append-outer>
              <v-btn icon small @click="dialogCliente = true">
                <v-icon>mdi-magnify</v-icon>
              </v-btn>
            </template>
          </v-text-field>
        </v-col>
        <v-col cols="12" md="3">
          <v-select v-model="filtro.selectedStatus" :items="situacoes" item-text="texto" item-value="valor" label="Situação" outlined dense hide-details @change="gerar"></v-select>
        </v-col>
      </FiltroPeriodo>
    </div>

    <v-card-text>
      <v-alert v-if="!filtro.selectedCliente" type="info" dense text class="mb-0"> Selecione um cliente para gerar o extrato. </v-alert>

      <template v-else>
        <v-row dense class="mb-2">
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Total dos títulos</div>
              <div class="text-h6">{{ maskMoney(totais.valor) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Recebido</div>
              <div class="text-h6 success--text">{{ maskMoney(totais.recebido) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">A receber (período)</div>
              <div class="text-h6">{{ maskMoney(totais.aReceber) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Saldo devedor do cliente</div>
              <div class="text-h6 error--text">{{ maskMoney(totais.saldoDevedorCliente) }}</div>
            </v-sheet>
          </v-col>
        </v-row>

        <EstadoVazio v-if="!carregando && !titulos.items.length" mensagem="Nenhum título no período selecionado." />

        <v-data-table v-else :headers="headers" :items="titulos.items" :items-per-page="20" show-expand item-key="id" class="elevation-1">
          <template v-slot:item.dataEmissao="{ item }">
            {{ formatarData(item.dataEmissao) }}
          </template>
          <template v-slot:item.dataVencimento="{ item }">
            {{ formatarData(item.dataVencimento) }}
          </template>
          <template v-slot:item.valor="{ item }">
            {{ maskMoney(item.valor) }}
          </template>
          <template v-slot:item.valorRecebido="{ item }">
            {{ maskMoney(item.valorRecebido()) }}
          </template>
          <template v-slot:item.valorAReceber="{ item }">
            {{ maskMoney(item.valorAReceber()) }}
          </template>
          <template v-slot:item.status="{ item }">
            <v-chip x-small :color="corStatus(item)" dark>{{ item.status }}</v-chip>
          </template>

          <template v-slot:expanded-item="{ headers: colunas, item }">
            <td :colspan="colunas.length" class="pa-4 grey lighten-5">
              <div class="text-subtitle-2 mb-2">Recebimentos</div>
              <v-data-table :headers="headersRecebimento" :items="item.recebimentosValidos()" :items-per-page="-1" hide-default-footer dense class="elevation-0">
                <template v-slot:item.dataPagamento="{ item: recebimento }">
                  {{ formatarData(recebimento.dataPagamento) }}
                </template>
                <template v-slot:item.valor="{ item: recebimento }">
                  {{ maskMoney(recebimento.valor) }}
                </template>
                <template v-slot:item.juros="{ item: recebimento }">
                  {{ maskMoney(recebimento.juros) }}
                </template>
                <template v-slot:item.multa="{ item: recebimento }">
                  {{ maskMoney(recebimento.multa) }}
                </template>
                <template v-slot:item.desconto="{ item: recebimento }">
                  {{ maskMoney(recebimento.desconto) }}
                </template>
                <template v-slot:no-data>
                  <span class="grey--text">Nenhum recebimento lançado</span>
                </template>
              </v-data-table>
            </td>
          </template>
        </v-data-table>
      </template>
    </v-card-text>

    <v-dialog v-model="dialogCliente" max-width="900">
      <LocalizarCliente @selecionar="selecionarCliente" @fechar="dialogCliente = false" />
    </v-dialog>
  </div>
</template>

<script>
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import FiltroPeriodo from "@/components/Relatorio/FiltroPeriodo.vue";
import LocalizarCliente from "@/views/Cliente/LocalizarCliente.vue";
import ContaReceberTituloList from "@/infra/entity/ContaReceberTituloList";
import ContaReceberService from "@/infra/service/ContaReceberService";
import { gerarExcel } from "@/utils/exports";
import { maskMoney, maskDateBR } from "@/utils/masks";
import { getCurrentDate } from "@/utils/date";

// Extrato por cliente: os títulos do período, os recebimentos de cada um e o
// saldo devedor total (que considera também títulos fora do período filtrado).
export default {
  name: "ExtratoCliente",
  components: { CabecalhoRelatorio, EstadoVazio, FiltroPeriodo, LocalizarCliente },
  data() {
    return {
      carregando: false,
      dialogCliente: false,
      clienteNome: "",
      titulos: new ContaReceberTituloList(),
      totais: { valor: 0, recebido: 0, aReceber: 0, saldoDevedorCliente: 0 },
      filtro: {
        selectedCliente: "",
        selectedStatus: "AMBAS",
        dataVencimentoDe: getCurrentDate(),
        dataVencimentoAte: getCurrentDate(),
      },
      situacoes: [
        { texto: "Todas", valor: "AMBAS" },
        { texto: "Em aberto", valor: "ABERTO" },
        { texto: "Liquidados", valor: "LIQUIDADO" },
        { texto: "Cancelados", valor: "CANCELADO" },
      ],
      headers: [
        { text: "Título", value: "codigo" },
        { text: "Cupom", value: "numero" },
        { text: "Parc.", value: "prestacao" },
        { text: "Emissão", value: "dataEmissao" },
        { text: "Vencimento", value: "dataVencimento" },
        { text: "Valor", value: "valor" },
        { text: "Recebido", value: "valorRecebido" },
        { text: "A receber", value: "valorAReceber" },
        { text: "Situação", value: "status" },
        { text: "", value: "data-table-expand" },
      ],
      headersRecebimento: [
        { text: "Data", value: "dataPagamento" },
        { text: "Forma", value: "formaPagamento" },
        { text: "Valor", value: "valor" },
        { text: "Juros", value: "juros" },
        { text: "Multa", value: "multa" },
        { text: "Desconto", value: "desconto" },
      ],
    };
  },
  computed: {
    clienteDescricao() {
      if (!this.filtro.selectedCliente) return "";
      return `${this.filtro.selectedCliente} - ${this.clienteNome}`.trim();
    },
    resumoFiltro() {
      if (!this.filtro.selectedCliente) return "Nenhum cliente selecionado";
      return `${this.clienteDescricao} · vencimento de ${this.formatarData(this.filtro.dataVencimentoDe)} até ${this.formatarData(this.filtro.dataVencimentoAte)}`;
    },
  },
  methods: {
    maskMoney,
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    corStatus(titulo) {
      if (titulo.status === "CANCELADO") return "grey";
      if (titulo.status === "LIQUIDADO") return "success";
      return titulo.vencido() ? "error" : "primary";
    },
    selecionarCliente(cliente) {
      this.filtro.selectedCliente = cliente.codigo;
      this.clienteNome = cliente.nome;
      this.dialogCliente = false;
      this.gerar();
    },
    async gerar() {
      if (!this.filtro.selectedCliente) return;

      this.carregando = true;
      try {
        const extrato = await ContaReceberService.getExtrato(this.filtro);
        this.titulos = extrato.titulos;
        this.totais = extrato.totais;
      } finally {
        this.carregando = false;
      }
    },
    exportarExcel() {
      const linhas = this.titulos.items.map((titulo) => ({
        titulo: titulo.codigo,
        cliente: this.clienteDescricao,
        cupom: titulo.numero,
        parcela: titulo.prestacao,
        emissao: this.formatarData(titulo.dataEmissao),
        vencimento: this.formatarData(titulo.dataVencimento),
        valor: titulo.valor,
        recebido: titulo.valorRecebido(),
        desconto: titulo.valorDesconto(),
        acrescimo: titulo.valorAcrescimo(),
        a_receber: titulo.valorAReceber(),
        situacao: titulo.status,
      }));
      gerarExcel(linhas, "extrato_cliente.xlsx");
    },
  },
};
</script>
