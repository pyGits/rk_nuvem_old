<template>
  <div>
    <v-card flat>
      <CabecalhoRelatorio
        titulo="Balancete"
        :subtitulo="resumoFiltro"
        icone="mdi-scale-balance"
        :carregando="carregando"
        :sem-dados="!data.length"
        texto-atualizar="Gerar"
        :mostrar-exportar="false"
        @atualizar="gerarBalancete"
      />

      <div class="px-6">
        <FiltroPeriodo :dt-inicio.sync="filtro.dtInicio" :dt-fim.sync="filtro.dtFim" @alterado="gerarBalancete">
          <v-col cols="12" md="4">
            <v-autocomplete
              v-model="filtro.loja"
              :items="lojas"
              item-text="nome"
              item-value="codigo"
              label="Loja"
              prepend-inner-icon="mdi-store-outline"
              dense
              outlined
              hide-details
              clearable
              @change="gerarBalancete"
            >
              <template v-slot:append-outer>
                <v-btn icon small @click="abrirDialogLoja">
                  <v-icon>mdi-magnify</v-icon>
                </v-btn>
              </template>
            </v-autocomplete>
          </v-col>
        </FiltroPeriodo>
      </div>

      <v-card-text class="pt-0">
        <EstadoVazio v-if="!carregando && !data.length" mensagem="Nenhum lançamento no período selecionado." />

        <template v-else>
          <v-data-table :headers="headerCategoria" :items="data" item-key="nome" show-expand class="elevation-1">
            <!-- Coloração da célula de total da categoria -->
            <template v-slot:item.total="{ item }">
              <span :style="{ color: item.total < 0 ? 'red' : 'green' }">
                {{ item.total | money }}
              </span>
            </template>

            <!-- Subtabela de subcategorias -->
            <template v-slot:expanded-item="{ headers, item }">
              <td :colspan="headers.length" class="pa-0">
                <v-data-table :headers="subHeaders" :items="item.subcategoria" hide-default-footer class="ml-4 mr-4 mb-4" dense>
                  <template v-slot:item="{ item }">
                    <tr :class="getRowClass(item)">
                      <td>{{ item.nome }}</td>
                      <td>{{ item.total | money }}</td>
                    </tr>
                  </template>

                  <template v-slot:no-data> Sem subcategorias </template>
                </v-data-table>
              </td>
            </template>
          </v-data-table>

          <div class="d-flex justify-end align-center mt-4">
            <span class="text-subtitle-1 mr-2">Saldo total:</span>
            <span class="text-h6 font-weight-bold" :class="saldoTotalGeral < 0 ? 'red--text' : 'green--text'">
              {{ saldoTotalGeral | money }}
            </span>
          </div>
        </template>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialogLoja">
      <LocalizarLoja @selecionar="selecionarLoja"></LocalizarLoja>
    </v-dialog>
  </div>
</template>

<script>
import CategoriaFinanceiraService from "@/infra/service/CategoriaFinanceiraService";
import LojaService from "@/infra/service/LojaService";
import LocalizarLoja from "@/views/Loja/LocalizarLoja.vue";
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import FiltroPeriodo from "@/components/Relatorio/FiltroPeriodo.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import { getCurrentDate } from "@/utils/date";

export default {
  components: {
    LocalizarLoja,
    CabecalhoRelatorio,
    FiltroPeriodo,
    EstadoVazio,
  },
  async mounted() {
    await this.carregarLojas();
    await this.gerarBalancete();
  },
  data() {
    return {
      dialogLoja: false,
      carregando: false,
      // Strings YYYY-MM-DD: a coluna data do lançamento é date puro. Antes eram
      // objetos Date, que o axios serializava em UTC — depois das 21h no
      // horário de Brasília o filtro "hoje" já apontava para o dia seguinte.
      filtro: {
        dtInicio: getCurrentDate(),
        dtFim: getCurrentDate(),
        loja: null,
      },
      headerCategoria: [
        { text: "Categoria", value: "nome" },
        { text: "Total", value: "total" },
        { text: "", value: "data-table-expand" },
      ],
      subHeaders: [
        { text: "Subcategoria", value: "nome" },
        { text: "Total", value: "total" },
      ],
      lojas: [],
      data: [],
      saldoTotalGeral: 0,
    };
  },
  computed: {
    lojaSelecionada() {
      if (!this.filtro.loja) return "Todas as lojas";
      const loja = this.lojas.find((l) => l.codigo === this.filtro.loja);
      return loja ? loja.nome : `Loja ${this.filtro.loja}`;
    },
    resumoFiltro() {
      return `${this.formatarData(this.filtro.dtInicio)} até ${this.formatarData(this.filtro.dtFim)} · ${this.lojaSelecionada}`;
    },
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      const [ano, mes, dia] = String(data).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    async carregarLojas() {
      const data = await LojaService.getAll();
      this.lojas = data.lojas;
    },
    abrirDialogLoja() {
      this.dialogLoja = true;
    },
    selecionarLoja(loja) {
      this.filtro.loja = loja.codigo;
      this.dialogLoja = false;
      this.gerarBalancete();
    },
    async gerarBalancete() {
      if (this.filtro.dtFim < this.filtro.dtInicio) return;

      this.carregando = true;
      try {
        const list = await CategoriaFinanceiraService.getBalancete(this.filtro);
        this.data = list.categorias;
        this.saldoTotalGeral = list.saldo;
      } finally {
        this.carregando = false;
      }
    },
    getRowClass(item) {
      if (item.tipo === "RECEITA") {
        return "linha-receita";
      } else if (item.tipo === "DESPESA") {
        return "linha-despesa";
      }
      return "";
    },
  },
};
</script>

<style scoped>
.linha-receita {
  background-color: #e8f5e9 !important; /* verde claro */
  color: #2e7d32 !important;
  font-weight: bold;
}
.linha-despesa {
  background-color: #ffebee !important; /* vermelho claro */
  color: #c62828 !important;
  font-weight: bold;
}
</style>
