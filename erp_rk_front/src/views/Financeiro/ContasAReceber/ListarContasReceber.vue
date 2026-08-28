<template>
  <div>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <span>Contas a Receber</span>
        <div class="d-flex" style="margin-left: auto">
          <v-btn color="green darken-1" outlined class="mr-2" :disabled="!titulos.items.length" @click="exportarExcel">
            <v-icon left>mdi-file-excel-outline</v-icon>
            Excel
          </v-btn>
          <v-btn color="primary" @click="tab = 2">
            <v-icon left>mdi-plus</v-icon>
            Lançar título
          </v-btn>
        </div>
      </v-card-title>

      <v-card-text>
        <v-sheet class="pa-4" elevation="1" rounded color="grey lighten-4">
          <div class="d-flex align-center justify-space-between" style="cursor: pointer" @click="showFilters = !showFilters">
            <div class="d-flex align-center">
              <v-icon class="mr-2" color="primary">mdi-filter-variant</v-icon>
              <span class="font-weight-medium">Filtros de Pesquisa</span>
            </div>
            <v-icon color="primary">{{ showFilters ? "mdi-chevron-up" : "mdi-chevron-down" }}</v-icon>
          </div>

          <!-- Com o painel fechado o usuario nao ve o que esta filtrando, e o
               padrao e "Em aberto": era por isso que o titulo sumia da grade
               assim que era liquidado, sem explicacao nenhuma. -->
          <div v-if="!showFilters" class="mt-2">
            <v-chip v-for="filtroAtivo in filtrosAtivos" :key="filtroAtivo" x-small class="mr-1 mb-1" color="primary" outlined>{{ filtroAtivo }}</v-chip>
          </div>

          <v-expand-transition>
            <div v-show="showFilters">
              <v-row dense>
                <v-col cols="12" sm="5">
                  <v-subheader class="pl-0">Situação</v-subheader>
                  <v-radio-group v-model="filtro.selectedStatus" row dense hide-details color="primary">
                    <v-radio label="Em aberto" value="ABERTO"></v-radio>
                    <v-radio label="Liquidado" value="LIQUIDADO"></v-radio>
                    <v-radio label="Cancelado" value="CANCELADO"></v-radio>
                    <v-radio label="Todas" value="AMBAS"></v-radio>
                  </v-radio-group>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Vencimento (De)</v-subheader>
                  <v-text-field v-model="filtro.dataVencimentoDe" type="date" outlined dense hide-details></v-text-field>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Vencimento (Até)</v-subheader>
                  <v-text-field v-model="filtro.dataVencimentoAte" type="date" outlined dense hide-details></v-text-field>
                </v-col>
              </v-row>

              <v-row dense class="mt-2">
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Emissão (De)</v-subheader>
                  <v-text-field v-model="filtro.dataEmissaoDe" type="date" outlined dense hide-details></v-text-field>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Emissão (Até)</v-subheader>
                  <v-text-field v-model="filtro.dataEmissaoAte" type="date" outlined dense hide-details></v-text-field>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Loja</v-subheader>
                  <v-autocomplete v-model="filtro.selectedLoja" :items="lojas" item-text="descricao" item-value="codigo" outlined dense hide-details clearable></v-autocomplete>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Origem</v-subheader>
                  <v-select v-model="filtro.selectedOrigem" :items="origens" item-text="texto" item-value="valor" outlined dense hide-details clearable></v-select>
                </v-col>
              </v-row>

              <v-row dense class="mt-2">
                <v-col cols="12" sm="5">
                  <v-subheader class="pl-0">Cliente</v-subheader>
                  <v-text-field :value="clienteFiltroDescricao" readonly outlined dense hide-details placeholder="Todos os clientes">
                    <template v-slot:append-outer>
                      <v-btn icon small @click="dialogCliente = true">
                        <v-icon>mdi-magnify</v-icon>
                      </v-btn>
                      <v-btn v-if="filtro.selectedCliente" icon small @click="limparCliente">
                        <v-icon>mdi-close</v-icon>
                      </v-btn>
                    </template>
                  </v-text-field>
                </v-col>
                <v-col cols="12" sm="4">
                  <v-subheader class="pl-0">Cupom / Nº da venda</v-subheader>
                  <v-text-field v-model="filtro.cupomFiltro" outlined dense hide-details clearable></v-text-field>
                </v-col>
                <v-col cols="12" sm="3">
                  <v-subheader class="pl-0">Descrição</v-subheader>
                  <v-text-field v-model="filtro.descricaoFiltro" outlined dense hide-details clearable></v-text-field>
                </v-col>
              </v-row>

              <div class="d-flex justify-end mt-4">
                <v-btn color="primary" @click="aplicarFiltro">
                  <v-icon left>mdi-filter</v-icon>
                  Aplicar Filtro
                </v-btn>
                <v-btn class="ml-2" outlined @click="limparFiltro">
                  <v-icon left>mdi-filter-remove</v-icon>
                  Limpar Filtros
                </v-btn>
              </div>
            </div>
          </v-expand-transition>
        </v-sheet>
      </v-card-text>

      <v-tabs v-model="tab" background-color="primary" dark>
        <v-tab>Títulos</v-tab>
        <v-tab>Recebimentos</v-tab>
        <v-tab>Lançar título</v-tab>
        <v-tab>Extrato do cliente</v-tab>
      </v-tabs>

      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-card-text>
            <div class="d-flex flex-wrap mb-4">
              <v-btn color="success" class="mr-2 mb-2" :disabled="!selecionados.length" @click="receberSelecionados">
                <v-icon left>mdi-cash-check</v-icon>
                Receber
              </v-btn>
              <v-btn color="warning" class="mr-2 mb-2" :disabled="!selecionados.length" @click="estornarSelecionados">
                <v-icon left>mdi-undo-variant</v-icon>
                Estornar
              </v-btn>
              <v-btn color="error" class="mr-2 mb-2" :disabled="!selecionados.length" @click="cancelarSelecionados">
                <v-icon left>mdi-close-circle-outline</v-icon>
                Cancelar
              </v-btn>
              <v-btn color="secondary" class="mb-2" :disabled="selecionados.length !== 1" @click="editarSelecionado">
                <v-icon left>mdi-pencil</v-icon>
                Editar
              </v-btn>
            </div>

            <v-data-table v-model="selecionados" :headers="headers" :items="titulos.items" item-key="id" :items-per-page="20" show-select class="elevation-1" :item-class="rowClass">
              <template v-slot:item.dataEmissao="{ item }">
                {{ formatarData(item.dataEmissao) }}
              </template>
              <template v-slot:item.dataVencimento="{ item }">
                {{ formatarData(item.dataVencimento) }}
                <v-chip v-if="item.diasAtraso() > 0" x-small color="error" dark class="ml-1">{{ item.diasAtraso() }}d</v-chip>
              </template>
              <template v-slot:item.cliente="{ item }">
                {{ nomeCliente(item.clienteCodigo, item.clienteNome) }}
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
              <template v-slot:item.origem="{ item }">
                <v-chip x-small outlined>{{ item.origem }}</v-chip>
              </template>

              <template slot="body.append">
                <!-- uma celula por coluna, na ordem de headers, com a da selecao na frente -->
                <tr class="blue--text">
                  <th class="title"></th>
                  <th class="title">Totais</th>
                  <th class="title"></th>
                  <th class="title"></th>
                  <th class="title"></th>
                  <th class="title"></th>
                  <th class="title"></th>
                  <th class="title">{{ maskMoney(titulos.valorTotal()) }}</th>
                  <th class="title">{{ maskMoney(titulos.valorRecebido()) }}</th>
                  <th class="title">{{ maskMoney(titulos.valorReceber()) }}</th>
                  <th class="title"></th>
                  <th class="title"></th>
                </tr>
              </template>
            </v-data-table>
          </v-card-text>
        </v-tab-item>

        <v-tab-item>
          <RecibosRecebimento ref="recibos" @estornado="carregar" />
        </v-tab-item>

        <v-tab-item>
          <EditarContasAReceber @gravar="aoLancar" />
        </v-tab-item>

        <v-tab-item>
          <ExtratoCliente />
        </v-tab-item>
      </v-tabs-items>
    </v-card>

    <v-dialog v-model="dialogReceber" max-width="1100">
      <ReceberTitulos ref="frmReceber" @gravar="aoReceber" @fechar="dialogReceber = false" />
    </v-dialog>

    <v-dialog v-model="dialogEditar" max-width="800">
      <EditarTitulo ref="frmEditarTitulo" @gravar="aoEditar" @fechar="dialogEditar = false" />
    </v-dialog>

    <v-dialog v-model="dialogCliente" max-width="900">
      <LocalizarCliente @selecionar="selecionarCliente" @fechar="dialogCliente = false" />
    </v-dialog>

    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import LocalizarCliente from "@/views/Cliente/LocalizarCliente.vue";
import EditarContasAReceber from "./EditarContasAReceber.vue";
import EditarTitulo from "./EditarTitulo.vue";
import ExtratoCliente from "./ExtratoCliente.vue";
import ReceberTitulos from "./ReceberTitulos.vue";
import RecibosRecebimento from "./RecibosRecebimento.vue";
import PDFService from "@/infra/service/PDFService";
import ContaReceberTituloList from "@/infra/entity/ContaReceberTituloList";
import ContaReceberService from "@/infra/service/ContaReceberService";
import { gerarExcel } from "@/utils/exports";
import { maskMoney, maskDateBR } from "@/utils/masks";

export default {
  name: "ListarContasReceber",
  components: { ConfirmDialog, LocalizarCliente, EditarContasAReceber, EditarTitulo, ExtratoCliente, ReceberTitulos, RecibosRecebimento },
  data() {
    return {
      tab: 0,
      showFilters: false,
      dialogReceber: false,
      dialogEditar: false,
      dialogCliente: false,
      titulos: new ContaReceberTituloList(),
      selecionados: [],
      clienteFiltroNome: "",
      filtro: this.filtroInicial(),
      origens: [
        { texto: "PDV (convênio)", valor: "PDV" },
        { texto: "Lançamento manual", valor: "MANUAL" },
      ],
      headers: [
        { text: "Título", value: "codigo" },
        { text: "Cliente", value: "cliente", sortable: false },
        { text: "Cupom", value: "numero" },
        { text: "Parc.", value: "prestacao" },
        { text: "Emissão", value: "dataEmissao" },
        { text: "Vencimento", value: "dataVencimento" },
        { text: "Valor", value: "valor" },
        { text: "Recebido", value: "valorRecebido" },
        { text: "A receber", value: "valorAReceber" },
        { text: "Situação", value: "status" },
        { text: "Origem", value: "origem" },
      ],
    };
  },
  computed: {
    lojaList() {
      return this.$store.state.loja.lojaList || [];
    },
    lojas() {
      return this.lojaList.map((loja) => ({
        codigo: Number(loja.codigo),
        descricao: `${loja.codigo} - ${loja.nome || loja.fantasia || ""}`.trim(),
      }));
    },
    clienteList() {
      return this.$store.state.cliente.clienteList || [];
    },
    // Só o que está de fato restringindo a consulta.
    filtrosAtivos() {
      const situacao = { ABERTO: "Em aberto", LIQUIDADO: "Liquidado", CANCELADO: "Cancelado", AMBAS: "Todas as situações" };
      const chips = [`Situação: ${situacao[this.filtro.selectedStatus] || this.filtro.selectedStatus}`];

      if (this.filtro.dataVencimentoDe || this.filtro.dataVencimentoAte) {
        chips.push(`Vencimento: ${this.formatarData(this.filtro.dataVencimentoDe) || "..."} a ${this.formatarData(this.filtro.dataVencimentoAte) || "..."}`);
      }
      if (this.filtro.dataEmissaoDe || this.filtro.dataEmissaoAte) {
        chips.push(`Emissão: ${this.formatarData(this.filtro.dataEmissaoDe) || "..."} a ${this.formatarData(this.filtro.dataEmissaoAte) || "..."}`);
      }
      if (this.filtro.selectedCliente) chips.push(`Cliente: ${this.clienteFiltroDescricao}`);
      if (this.filtro.selectedLoja) chips.push(`Loja: ${this.filtro.selectedLoja}`);
      if (this.filtro.selectedOrigem) chips.push(`Origem: ${this.filtro.selectedOrigem}`);
      if (this.filtro.cupomFiltro) chips.push(`Cupom: ${this.filtro.cupomFiltro}`);
      if (this.filtro.descricaoFiltro) chips.push(`Descrição: ${this.filtro.descricaoFiltro}`);

      return chips;
    },
    clienteFiltroDescricao() {
      if (!this.filtro.selectedCliente) return "";
      return `${this.filtro.selectedCliente} - ${this.clienteFiltroNome}`.trim();
    },
  },
  async mounted() {
    await Promise.all([this.$store.dispatch("getLojas"), this.$store.dispatch("getClientes")]);
    await this.carregar();
  },
  methods: {
    maskMoney,
    filtroInicial() {
      return {
        selectedStatus: "ABERTO",
        dataVencimentoDe: "",
        dataVencimentoAte: "",
        dataEmissaoDe: "",
        dataEmissaoAte: "",
        selectedCliente: "",
        selectedLoja: "",
        selectedOrigem: "",
        cupomFiltro: "",
        descricaoFiltro: "",
      };
    },
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    // O nome vem resolvido do backend. O store continua como reserva para o
    // título antigo, gravado antes dessa mudança.
    nomeCliente(codigo, nome) {
      if (!codigo) return "";
      if (nome) return `${codigo} - ${nome}`;
      const cliente = this.clienteList.find((item) => String(item.codigo) === String(codigo));
      return cliente ? `${codigo} - ${cliente.nome}` : codigo;
    },
    corStatus(titulo) {
      if (titulo.status === "CANCELADO") return "grey";
      if (titulo.status === "LIQUIDADO") return "success";
      return titulo.vencido() ? "error" : "primary";
    },
    rowClass(titulo) {
      return titulo.status === "CANCELADO" ? "titulo-cancelado" : "";
    },
    async carregar() {
      this.$store.commit("setContainerLoading", true);
      try {
        this.selecionados = [];
        this.titulos = await ContaReceberService.getAllTitulos(this.filtro);
      } finally {
        this.$store.commit("setContainerLoading", false);
      }
    },
    aplicarFiltro() {
      this.showFilters = false;
      this.carregar();
    },
    limparFiltro() {
      this.filtro = this.filtroInicial();
      this.clienteFiltroNome = "";
      this.showFilters = false;
      this.carregar();
    },
    selecionarCliente(cliente) {
      this.filtro.selectedCliente = cliente.codigo;
      this.clienteFiltroNome = cliente.nome;
      this.dialogCliente = false;
      this.carregar();
    },
    limparCliente() {
      this.filtro.selectedCliente = "";
      this.clienteFiltroNome = "";
      this.carregar();
    },
    // As ações trabalham sobre a seleção da grid, no mesmo padrão do Contas a
    // Pagar: a lista selecionada vira uma entidade e o serviço valida antes de
    // chamar a API.
    selecaoComoLista() {
      const lista = new ContaReceberTituloList();
      this.selecionados.forEach((titulo) => lista.adicionarTitulo(titulo));
      return lista;
    },
    receberSelecionados() {
      const lista = this.selecaoComoLista();
      lista.validarReceber();
      this.dialogReceber = true;
      this.$nextTick(() => this.$refs.frmReceber.abrir(lista));
    },
    async estornarSelecionados() {
      const confirmar = await this.$refs.confirmDialog.abrir("Estornar os recebimentos ?", "Os títulos voltam para em aberto");
      if (!confirmar) return;
      await ContaReceberService.estornar(this.selecaoComoLista());
      await this.carregar();
    },
    async cancelarSelecionados() {
      const confirmar = await this.$refs.confirmDialog.abrir("Cancelar os títulos ?", "O título cancelado deixa de compor o saldo do cliente");
      if (!confirmar) return;
      await ContaReceberService.cancelar(this.selecaoComoLista());
      await this.carregar();
    },
    editarSelecionado() {
      this.dialogEditar = true;
      this.$nextTick(() => this.$refs.frmEditarTitulo.abrir(this.selecionados[0]));
    },
    // O título liquidado sai da grade na hora (o filtro padrão é "em aberto").
    // Abrir o comprovante logo após a baixa é o que fecha o ciclo para o
    // operador: ele vê o que acabou de receber, com número de recibo.
    async aoReceber(recibo) {
      this.dialogReceber = false;
      await this.carregar();

      if (!recibo?.reciboId) return;
      const gerado = await ContaReceberService.gerarRecibo(recibo.reciboId);
      PDFService.exibirPDF(gerado.arquivo);
    },
    async aoEditar() {
      this.dialogEditar = false;
      await this.carregar();
    },
    async aoLancar() {
      this.tab = 0;
      await this.carregar();
    },
    // Exporta o que está na tela, com os totais calculados, e não o retorno cru
    // da API.
    exportarExcel() {
      const linhas = this.titulos.items.map((titulo) => ({
        titulo: titulo.codigo,
        cliente: this.nomeCliente(titulo.clienteCodigo, titulo.clienteNome),
        cpf: titulo.clienteCpf,
        loja: titulo.lojaId,
        cupom: titulo.numero,
        parcela: titulo.prestacao,
        emissao: this.formatarData(titulo.dataEmissao),
        vencimento: this.formatarData(titulo.dataVencimento),
        valor: titulo.valor,
        recebido: titulo.valorRecebido(),
        desconto: titulo.valorDesconto(),
        acrescimo: titulo.valorAcrescimo(),
        a_receber: titulo.valorAReceber(),
        dias_atraso: titulo.diasAtraso(),
        situacao: titulo.status,
        origem: titulo.origem,
        descricao: titulo.descricao,
      }));
      gerarExcel(linhas, "contas_a_receber.xlsx");
    },
  },
};
</script>

<style scoped>
.titulo-cancelado {
  background-color: #f5f5f5;
  color: #9e9e9e;
}
</style>
