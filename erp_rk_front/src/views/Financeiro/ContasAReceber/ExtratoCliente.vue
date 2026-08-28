<template>
  <div>
    <CabecalhoRelatorio
      titulo="Extrato do Cliente"
      :subtitulo="resumoFiltro"
      icone="mdi-account-cash-outline"
      :carregando="carregando"
      :sem-dados="filtro.selectedCliente ? !titulos.items.length : !clientes.length"
      texto-atualizar="Gerar"
      @atualizar="gerar"
      @exportar="exportarExcel"
    />

    <div class="px-6">
      <FiltroPeriodo :dt-inicio.sync="filtro.dataVencimentoDe" :dt-fim.sync="filtro.dataVencimentoAte" :atalhos="atalhosVencimento" atalho-inicial="" @alterado="gerar">
        <template v-slot:acoes-filtro>
          <v-chip small outlined class="mr-2 mb-1" :color="semPeriodo ? 'primary' : ''" @click="limparPeriodo">Tudo (sem período)</v-chip>
        </template>
        <v-col cols="12" md="5">
          <v-text-field :value="clienteDescricao" label="Cliente" readonly outlined dense hide-details prepend-inner-icon="mdi-account-outline" placeholder="Selecione o cliente">
            <template v-slot:append-outer>
              <v-btn icon small @click="dialogCliente = true">
                <v-icon>mdi-magnify</v-icon>
              </v-btn>
              <v-btn v-if="filtro.selectedCliente" icon small title="Ver todos os clientes" @click="voltarParaTodos">
                <v-icon>mdi-close</v-icon>
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
      <!-- Sem cliente escolhido a tela mostra a posição de todos, e clicar numa
           linha abre o extrato daquele cliente. Antes era só um aviso pedindo
           para escolher alguém. -->
      <template v-if="!filtro.selectedCliente">
        <v-row dense class="mb-2">
          <v-col cols="12" sm="4">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Clientes com saldo</div>
              <div class="text-h6">{{ totaisClientes.clientes }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="4">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Saldo devedor total</div>
              <div class="text-h6">{{ maskMoney(totaisClientes.saldo) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="4">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Saldo vencido</div>
              <div class="text-h6 error--text">{{ maskMoney(totaisClientes.saldoVencido) }}</div>
            </v-sheet>
          </v-col>
        </v-row>

        <EstadoVazio v-if="!carregando && !clientes.length" mensagem="Nenhum cliente com saldo em aberto." icone="mdi-account-cash-outline" />

        <v-data-table v-else :headers="headersClientes" :items="clientes" :loading="carregando" :items-per-page="20" class="elevation-1" @click:row="abrirCliente">
          <template v-slot:item.cliente="{ item }">
            {{ item.clienteCodigo }}{{ item.clienteNome ? ` - ${item.clienteNome}` : "" }}
          </template>
          <template v-slot:item.saldo="{ item }">
            {{ maskMoney(item.saldo) }}
          </template>
          <template v-slot:item.saldoVencido="{ item }">
            <span :class="item.saldoVencido > 0 ? 'error--text' : ''">{{ maskMoney(item.saldoVencido) }}</span>
          </template>
          <template v-slot:item.vencimentoMaisAntigo="{ item }">
            {{ formatarData(item.vencimentoMaisAntigo) }}
          </template>
          <template v-slot:item.ultimoRecebimento="{ item }">
            {{ formatarData(item.ultimoRecebimento) }}
          </template>
        </v-data-table>
      </template>

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
              <div class="text-caption grey--text">{{ semPeriodo ? "A receber" : "A receber (período)" }}</div>
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

        <v-data-table v-else :headers="headers" :items="titulos.items" :items-per-page="20" show-expand item-key="id" class="elevation-1" @click:row="verCupom">
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
          <template v-slot:item.numero="{ item }">
            <a v-if="temCupom(item)" href="#" @click.stop.prevent="verCupom(item)">{{ item.numero }}</a>
            <span v-else>{{ item.numero }}</span>
          </template>

          <template v-slot:expanded-item="{ headers: colunas, item }">
            <td :colspan="colunas.length" class="pa-4 grey lighten-5">
              <div class="text-subtitle-2 mb-2">Recebimentos</div>
              <v-data-table :headers="headersRecebimento" :items="item.recebimentosValidos()" :items-per-page="-1" hide-default-footer dense class="elevation-0">
                <template v-slot:item.dataPagamento="{ item: recebimento }">
                  {{ formatarData(recebimento.dataPagamento) }}
                </template>
                <template v-slot:item.formaPagamentoNome="{ item: recebimento }">
                  {{ recebimento.formaPagamentoNome || recebimento.formaPagamento }}
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

    <!-- Detalhe da venda que originou o título. Reaproveita /relatorios/cupom,
         que já existe para o painel de caixa e recebe exatamente os quatro
         campos que o título de crediário carrega. -->
    <v-dialog v-model="dialogCupom" max-width="900">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span>Cupom {{ cupomSelecionado.numero }} · caixa {{ cupomSelecionado.caixa }} · {{ formatarData(cupomSelecionado.dataEmissao) }}</span>
          <v-btn icon small @click="dialogCupom = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>

        <v-card-text>
          <div v-if="carregandoCupom" class="text-center py-6">
            <v-progress-circular indeterminate color="primary"></v-progress-circular>
          </div>

          <template v-else>
            <EstadoVazio v-if="!cupom.itens.length" mensagem="Os itens desta venda não estão na nuvem." icone="mdi-receipt-text-outline" />

            <template v-else>
              <div class="text-subtitle-2 mb-2">Itens</div>
              <v-data-table :headers="headersItensCupom" :items="cupom.itens" :items-per-page="-1" hide-default-footer dense class="elevation-0">
                <template v-slot:item.valor_unitario="{ item }">{{ maskMoney(item.valor_unitario) }}</template>
                <template v-slot:item.valor_desconto="{ item }">{{ maskMoney(item.valor_desconto) }}</template>
                <template v-slot:item.valor_total="{ item }">{{ maskMoney(item.valor_total) }}</template>
              </v-data-table>

              <div class="text-subtitle-2 mt-4 mb-2">Formas de pagamento</div>
              <v-data-table :headers="headersFormasCupom" :items="cupom.formasPagamento" :items-per-page="-1" hide-default-footer dense class="elevation-0">
                <template v-slot:item.valor="{ item }">{{ maskMoney(item.valor) }}</template>
                <template v-slot:item.valor_troco="{ item }">{{ maskMoney(item.valor_troco) }}</template>
              </v-data-table>
            </template>
          </template>
        </v-card-text>
      </v-card>
    </v-dialog>

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

// Extrato por cliente: os títulos do período, os recebimentos de cada um e o
// saldo devedor total (que considera também títulos fora do período filtrado).
export default {
  name: "ExtratoCliente",
  components: { CabecalhoRelatorio, EstadoVazio, FiltroPeriodo, LocalizarCliente },
  data() {
    return {
      carregando: false,
      dialogCliente: false,
      dialogCupom: false,
      carregandoCupom: false,
      cupomSelecionado: {},
      cupom: { itens: [], formasPagamento: [] },
      clienteNome: "",
      clientes: [],
      // O extrato filtra por VENCIMENTO, e crediário vence no futuro: os
      // atalhos padrão (todos para trás, terminando em hoje) escondiam
      // justamente as parcelas a vencer.
      atalhosVencimento: [
        { label: "Vencidos", deDias: null, ateDias: -1 },
        { label: "Este mês", mesAtual: true, ateFimDoMes: true },
        { label: "Próximos 30 dias", deDias: 0, ateDias: 30 },
        { label: "Próximos 90 dias", deDias: 0, ateDias: 90 },
        { label: "Últimos 30 dias", deDias: -29, ateDias: 0 },
      ],
      totaisClientes: { clientes: 0, saldo: 0, saldoVencido: 0 },
      titulos: new ContaReceberTituloList(),
      totais: { valor: 0, recebido: 0, aReceber: 0, saldoDevedorCliente: 0 },
      filtro: {
        selectedCliente: "",
        selectedStatus: "AMBAS",
        // Vazio de proposito: o backend ignora data em branco, entao o extrato
        // abre com o historico inteiro do cliente. Comecar em hoje->hoje fazia
        // o extrato aparecer vazio, que era o "nao mostra tudo".
        dataVencimentoDe: "",
        dataVencimentoAte: "",
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
      headersClientes: [
        { text: "Cliente", value: "cliente", sortable: false },
        { text: "Títulos", value: "qtdTitulos" },
        { text: "Vencidos", value: "qtdTitulosVencidos" },
        { text: "Saldo devedor", value: "saldo" },
        { text: "Saldo vencido", value: "saldoVencido" },
        { text: "Vencimento mais antigo", value: "vencimentoMaisAntigo" },
        { text: "Último recebimento", value: "ultimoRecebimento" },
      ],
      headersItensCupom: [
        { text: "Item", value: "item" },
        { text: "Cód. barras", value: "codigo_barras" },
        { text: "Descrição", value: "descricao" },
        { text: "Un.", value: "unidade" },
        { text: "Qtde", value: "qtde" },
        { text: "Unitário", value: "valor_unitario" },
        { text: "Desconto", value: "valor_desconto" },
        { text: "Total", value: "valor_total" },
      ],
      headersFormasCupom: [
        { text: "Forma", value: "descricao" },
        { text: "Parc.", value: "prestacao" },
        { text: "Valor", value: "valor" },
        { text: "Troco", value: "valor_troco" },
      ],
      headersRecebimento: [
        { text: "Data", value: "dataPagamento" },
        { text: "Forma", value: "formaPagamentoNome" },
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
    semPeriodo() {
      return !this.filtro.dataVencimentoDe && !this.filtro.dataVencimentoAte;
    },
    resumoFiltro() {
      if (!this.filtro.selectedCliente) return "Todos os clientes com saldo em aberto";
      if (this.semPeriodo) return `${this.clienteDescricao} · todo o período`;
      return `${this.clienteDescricao} · vencimento de ${this.formatarData(this.filtro.dataVencimentoDe)} até ${this.formatarData(this.filtro.dataVencimentoAte)}`;
    },
  },
  mounted() {
    this.gerar();
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
    limparPeriodo() {
      this.filtro.dataVencimentoDe = "";
      this.filtro.dataVencimentoAte = "";
      this.gerar();
    },
    selecionarCliente(cliente) {
      this.filtro.selectedCliente = cliente.codigo;
      this.clienteNome = cliente.nome;
      this.dialogCliente = false;
      this.gerar();
    },
    async gerar() {
      this.carregando = true;
      try {
        if (!this.filtro.selectedCliente) {
          const posicao = await ContaReceberService.getSaldoClientes({ dataVencimentoAte: this.filtro.dataVencimentoAte });
          this.clientes = posicao.clientes;
          this.totaisClientes = posicao.totais;
          return;
        }

        const extrato = await ContaReceberService.getExtrato(this.filtro);
        this.titulos = extrato.titulos;
        this.totais = extrato.totais;
      } finally {
        this.carregando = false;
      }
    },
    // Só título vindo do PDV tem venda por trás; lançamento manual não tem.
    temCupom(titulo) {
      return !!titulo.codigoCupom && !!titulo.caixa;
    },
    async verCupom(titulo) {
      if (!this.temCupom(titulo)) return;

      this.cupomSelecionado = titulo;
      this.cupom = { itens: [], formasPagamento: [] };
      this.dialogCupom = true;
      this.carregandoCupom = true;
      try {
        await this.$store.dispatch("getCupomUnico", {
          data: String(titulo.dataEmissao || "").substring(0, 10),
          codigo: titulo.codigoCupom,
          caixa: titulo.caixa,
          loja: titulo.lojaId,
        });
        this.cupom = this.$store.state.relatorio.relatorioCupomUnico || { itens: [], formasPagamento: [] };
      } finally {
        this.carregandoCupom = false;
      }
    },
    // Do consolidado para o extrato individual, sem passar pela busca.
    abrirCliente(cliente) {
      this.filtro.selectedCliente = cliente.clienteCodigo;
      this.clienteNome = cliente.clienteNome;
      this.gerar();
    },
    voltarParaTodos() {
      this.filtro.selectedCliente = "";
      this.clienteNome = "";
      this.gerar();
    },
    exportarExcel() {
      // Exporta o que está na tela: no modo consolidado são os clientes, não
      // os títulos (que nesse modo nem foram carregados).
      if (!this.filtro.selectedCliente) {
        const posicao = this.clientes.map((cliente) => ({
          codigo: cliente.clienteCodigo,
          cliente: cliente.clienteNome,
          titulos: cliente.qtdTitulos,
          titulos_vencidos: cliente.qtdTitulosVencidos,
          valor: cliente.valor,
          recebido: cliente.recebido,
          saldo: cliente.saldo,
          saldo_vencido: cliente.saldoVencido,
          vencimento_mais_antigo: this.formatarData(cliente.vencimentoMaisAntigo),
          ultimo_recebimento: this.formatarData(cliente.ultimoRecebimento),
        }));
        gerarExcel(posicao, "posicao_clientes.xlsx");
        return;
      }

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
