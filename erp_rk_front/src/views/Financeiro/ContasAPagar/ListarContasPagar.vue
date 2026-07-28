<template>
  <div>
    <!-- Título da página -->
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <div>
          <span>Contas A Pagar</span>
        </div>

        <div class="d-flex gap-2" style="margin-left: auto">
          <v-btn color="primary" @click="novo">
            <v-icon left>mdi-plus</v-icon>
            Incluir Nova Conta a Pagar
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

          <v-expand-transition>
            <div v-show="showFilters">
              <v-row dense>
                <!-- Status -->
                <v-col cols="12" sm="4">
                  <v-subheader>Status</v-subheader>
                  <v-radio-group v-model="filtro.selectedStatus" row color="primary">
                    <v-radio label="Aberto" value="ABERTO"></v-radio>
                    <v-radio label="Liquidado" value="LIQUIDADO"></v-radio>
                    <v-radio label="Cancelado" value="CANCELADO"></v-radio>
                    <v-radio label="Ambas" value="AMBAS"></v-radio>
                  </v-radio-group>
                </v-col>

                <!-- Data Vencimento De -->
                <v-col cols="12" sm="4">
                  <v-subheader>Data de Vencimento (De)</v-subheader>
                  <v-text-field v-model="filtro.dataVencimentoDe" type="date" outlined dense></v-text-field>
                </v-col>

                <!-- Data Vencimento Até -->
                <v-col cols="12" sm="4">
                  <v-subheader>Data de Vencimento (Até)</v-subheader>
                  <v-text-field v-model="filtro.dataVencimentoAte" type="date" outlined dense></v-text-field>
                </v-col>
              </v-row>
              <v-row justify="end" dense>
                <!-- Data Emissão De -->
                <v-col cols="12" sm="4">
                  <v-subheader>Data de Emissão (De)</v-subheader>
                  <v-text-field v-model="filtro.dataEmissaoDe" type="date" outlined dense></v-text-field>
                </v-col>
                <!-- Data Emissão Até -->
                <v-col cols="12" sm="4">
                  <v-subheader>Data de Emissão (Até)</v-subheader>
                  <v-text-field v-model="filtro.dataEmissaoAte" type="date" outlined dense></v-text-field>
                </v-col>
              </v-row>
              <v-row dense>
                <!-- Fornecedor -->
                <v-col cols="12" sm="6">
                  <v-subheader>Fornecedor</v-subheader>
                  <v-autocomplete v-model="filtro.selectedFornecedor" :items="fornecedores.fornecedores" item-text="nome" item-value="codigo" label="Selecione o Fornecedor" outlined dense clearable>
                    <template v-slot:append-outer>
                      <v-btn icon @click="abrirBuscaFornecedor">
                        <v-icon>mdi-magnify</v-icon>
                      </v-btn>
                    </template>
                  </v-autocomplete>
                </v-col>

                <!-- Categoria -->
                <v-col cols="12" sm="6">
                  <v-subheader>Categoria</v-subheader>
                  <v-autocomplete v-model="filtro.selectedCategoria" :items="categorias" item-text="nome" item-value="codigo" label="Selecione a Categoria" outlined dense clearable></v-autocomplete>
                </v-col>

                <!-- Descrição -->
                <v-col cols="12" sm="6">
                  <v-subheader>Descrição</v-subheader>
                  <v-text-field v-model="filtro.descricaoFiltro" label="Digite a descrição" outlined dense clearable></v-text-field>
                </v-col>

                <!-- Número do Documento -->
                <v-col cols="12" sm="6">
                  <v-subheader>Número do Documento</v-subheader>
                  <v-text-field v-model="filtro.numeroDocumentoFiltro" label="Digite o número do documento" outlined dense clearable></v-text-field>
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

      <v-card-title></v-card-title>

      <v-tabs v-model="tab" background-color="primary" dark>
        <v-tab>Lista Títulos</v-tab>
        <v-tab>Incluir Conta a Pagar</v-tab>
        <v-tab disabled>Editar/Visualizar Título</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-card-text>
            <v-row>
              <v-col cols="12" class="d-flex justify-end">
                <v-btn color="success" class="mr-2" :disabled="contasSelecionadas.items.length === 0" @click="liquidarSelecionadas">
                  <v-icon left>mdi-cash</v-icon>
                  Liquidar
                </v-btn>

                <v-btn color="warning" class="mr-2" :disabled="contasSelecionadas.items.length === 0" @click="estornarSelecionadas">
                  <v-icon left>mdi-cancel</v-icon>
                  Estornar
                </v-btn>

                <v-btn color="error" class="mr-2" :disabled="contasSelecionadas.items.length === 0" @click="cancelarSelecionadas">
                  <v-icon left>mdi-close-octagon</v-icon>
                  Cancelar
                </v-btn>

                <v-btn color="seccondary" :disabled="!(contasSelecionadas.items.length === 1)" @click="editarTituloSelecionado">
                  <v-icon left>mdi-pencil</v-icon>
                  Editar/Visualizar
                </v-btn>
              </v-col>
            </v-row>
            <!-- Listar -->
            <v-data-table v-model="contasSelecionadas.items" item-key="id" :headers="headers" :items="titulos.items" :items-per-page="20" show-select class="elevation-1">
              <template v-slot:item="{ item, isSelected, select }">
                <tr :class="isSelected ? 'v-data-table__selected' : ''" @click="select(!isSelected)">
                  <!-- Checkbox de seleção -->
                  <td>
                    <v-simple-checkbox :value="isSelected" @input="select($event)" @click.stop />
                  </td>

                  <!-- Conteúdo das colunas -->
                  <td v-for="header in headers.filter((h) => h.value !== 'data-table-select')" :key="header.value">
                    <!-- Campo status com chip colorido -->
                    <template v-if="header.value === 'status'">
                      <v-chip :color="item.status === 'LIQUIDADO' ? 'green' : item.status === 'CANCELADO' ? 'red' : 'orange'" dark>
                        {{ item.status }}
                      </v-chip>
                    </template>

                    <!-- Campo vencimento com formatação de data -->
                    <template v-else-if="header.value === 'vencimento'">
                      {{ new Date(item.vencimento).toLocaleDateString("pt-BR") }}
                    </template>

                    <template v-else-if="header.value === 'valor'"> <InputMoney disabled :value="item.valor"></InputMoney> </template>
                    <template v-else-if="header.value === 'valorPago'"> <InputMoney disabled :value="item.valorPago"></InputMoney> </template>
                    <template v-else-if="header.value === 'valorPagar'"> <InputMoney disabled :value="item.valorAPagar()"></InputMoney> </template>

                    <!-- Demais campos -->
                    <template v-else>
                      {{ item[header.value] }}
                    </template>
                  </td>
                </tr>
              </template>
            </v-data-table>
          </v-card-text>
        </v-tab-item>
        <v-tab-item eager>
          <!-- Editar -->
          <EditarContasAPagar @gravar="carregar" ref="editarContasPagar"></EditarContasAPagar>
        </v-tab-item>
        <v-tab-item eager>
          <!-- Editar -->
          <EditarTitulo @gravar="carregar" ref="frmEditarTituloPagar"></EditarTitulo>
        </v-tab-item>
      </v-tabs-items>
    </v-card>
    <v-dialog v-model="dialogLiquidar">
      <LiquidarContasAPagar @gravar="carregar" ref="frmLiquidar"></LiquidarContasAPagar>
    </v-dialog>
    <v-dialog v-model="dialogLocalizarFornecedor">
      <LocalizarFornecedor @selecionar="selecionarFornecedor"></LocalizarFornecedor>
    </v-dialog>
    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ContaPagarService from "@/infra/service/ContaPagarService";
import EditarContasAPagar from "./EditarContasAPagar.vue";
import LiquidarContasAPagar from "./LiquidarContasAPagar.vue";
import ContaPagarTituloList from "@/infra/entity/ContaPagarTituloList";
import FornecedorService from "@/infra/service/FornecedorService";
import CategoriaFinanceiraService from "@/infra/service/CategoriaFinanceiraService";
import EditarTitulo from "./EditarTitulo.vue";
import LocalizarFornecedor from "@/views/Fornecedor/LocalizarFornecedor.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";

export default {
  components: {
    InputMoney,
    LocalizarFornecedor,
    EditarTitulo,
    EditarContasAPagar,
    LiquidarContasAPagar,
    ConfirmDialog,
  },
  async mounted() {
    await this.carregar();
  },
  data() {
    return {
      tab: 0,
      titulos: [],
      selecionados: [], // armazena os IDs dos itens selecionados

      headers: [
        { text: "Parcela", value: "seq" },
        { text: "Descrição", value: "descricao" },
        { text: "Vencimento", value: "vencimento" },
        { text: "Valor", value: "valor" },
        { text: "Valor Pago", value: "valorPago" },
        { text: "Restante", value: "valorPagar" },
        { text: "Status", value: "status" },
        { text: "Nº Doc", value: "numeroDocumento" },
      ],
      dialogLiquidar: false,
      dialogLocalizarFornecedor: false,
      contasSelecionadas: new ContaPagarTituloList(),
      showFilters: false,
      filtro: {
        selectedStatus: "AMBAS",
        dataVencimentoDe: "",
        dataVencimentoAte: "",
        dataEmissaoDe: "",
        dataEmissaoAte: "",
        selectedFornecedor: null,
        selectedCategoria: null,
        descricaoFiltro: "",
        numeroDocumentoFiltro: "",
      },

      fornecedores: [], // preencher via API ou static
      categorias: [], // preencher via API ou static
    };
  },
  methods: {
    async gravarContasPagar() {
      await this.$refs.editarContasPagar.gravar();
    },
    abrirBuscaFornecedor() {
      this.dialogLocalizarFornecedor = true;
    },
    editarTituloSelecionado() {
      this.tab = 2;
      this.$refs.frmEditarTituloPagar.abrir(this.contasSelecionadas.items[0]);
    },
    selecionarFornecedor(fornecedor) {
      this.dialogLocalizarFornecedor = false;
      this.filtro.selectedFornecedor = fornecedor.codigo;
    },
    async carregar() {
      this.contasSelecionadas = new ContaPagarTituloList();
      this.tab = 0;
      this.dialogLiquidar = false;
      this.titulos = await ContaPagarService.getAllTitulos();
      this.fornecedores = await FornecedorService.getAll();
      this.categorias = await CategoriaFinanceiraService.getAll();
    },
    novo() {
      this.tab = 1;
      this.$refs.editarContasPagar.novo();
    },
    async liquidarSelecionadas() {
      this.contasSelecionadas.validarLiquidar();
      this.dialogLiquidar = true;
      this.$nextTick(() => {
        this.$refs.frmLiquidar.abrir(this.contasSelecionadas);
      });
    },
    async cancelarSelecionadas() {
      const confirmar = await this.$refs.confirmDialog.abrir("Confirmar Cancelar Títulos Selecionados ?", "Operação não pode ser desfeita");
      if (confirmar) {
        await ContaPagarService.cancelarTitulos(this.contasSelecionadas);
        await this.carregar();
      }
    },
    async estornarSelecionadas() {
      const confirmar = await this.$refs.confirmDialog.abrir("Confirmar Estornar Títulos Selecionados ?", "Operação não pode ser desfeita");
      if (confirmar) {
        await ContaPagarService.estornarTitulos(this.contasSelecionadas);
        await this.carregar();
      }
    },
    limparFiltro() {
      this.filtro = {
        selectedStatus: "AMBAS",
        dataVencimentoDe: "",
        dataVencimentoAte: "",
        selectedFornecedor: null,
        selectedCategoria: null,
        descricaoFiltro: "",
        numeroDocumentoFiltro: "",
      };
    },
    async aplicarFiltro() {
      this.contasSelecionadas = new ContaPagarTituloList();
      this.tab = 0;
      this.dialogLiquidar = false;
      this.titulos = await ContaPagarService.getAllTitulos(this.filtro);
      this.showFilters = false;
    },
  },
};
</script>
