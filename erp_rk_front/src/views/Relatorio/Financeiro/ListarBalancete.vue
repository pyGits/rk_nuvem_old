<template>
  <div>
    <v-card>
      <v-card-title>Balancete</v-card-title>
      <v-card-text>
        <v-row dense>
          <v-col cols="12" sm="3">
            <span>Data Início:</span>
            <InputDate v-model="filtro.dtInicio" />
          </v-col>
          <v-col cols="12" sm="3">
            <span>Data Fim:</span>
            <InputDate v-model="filtro.dtFim" />
          </v-col>
          <v-col cols="12" sm="3" class="mt-6">
            <v-btn color="primary" @click="gerarBalancete">Gerar</v-btn>
          </v-col>
        </v-row>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-subheader>Loja</v-subheader>
            <v-autocomplete v-model="filtro.loja" :items="lojas" item-text="nome" item-value="codigo" label="Selecione a Loja" outlined dense clearable>
              <template v-slot:append-outer>
                <v-btn icon @click="abrirDialogLoja">
                  <v-icon>mdi-magnify</v-icon>
                </v-btn>
              </template>
            </v-autocomplete>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12">
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
          </v-col>
        </v-row>

        <!-- ✅ Linha fixa com saldo total geral -->
        <v-row class="mt-4">
          <v-col cols="12" class="text-right">
            <span style="font-weight: bold; font-size: 18px">
              Saldo Total:
              <span :style="{ color: saldoTotalGeral < 0 ? 'red' : 'green' }">
                {{ saldoTotalGeral | money }}
              </span>
            </span>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
    <v-dialog v-model="dialogLoja">
      <LocalizarLoja @selecionar="selecionarLoja"></LocalizarLoja>
    </v-dialog>
  </div>
</template>

<script>
import InputDate from "@/components/Input/InputDate.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import CategoriaFinanceiraService from "@/infra/service/CategoriaFinanceiraService";
import LojaService from "@/infra/service/LojaService";
import LocalizarLoja from "@/views/Loja/LocalizarLoja.vue";

export default {
  components: {
    InputDate,
    InputMoney,
    LocalizarLoja,
  },
  async mounted() {
    await this.carregarLojas();
  },
  data() {
    return {
      dialogLoja: false,
      filtro: {
        dtInicio: new Date(),
        dtFim: new Date(),
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
  methods: {
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
    },

    async gerarBalancete() {
      const list = await CategoriaFinanceiraService.getBalancete(this.filtro);
      this.data = list.categorias;
      this.saldoTotalGeral = list.saldo;
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
