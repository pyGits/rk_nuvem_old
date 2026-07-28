<template>
  <div>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <span>Localizar Produto</span>
        <v-btn icon small @click="fechar">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="3">
            <span>Código Barras:</span>
            <InputNumber ref="inputCodigoBarras" v-model="filtro.codigo_barras" :limit="14" />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" sm="6">
            <span>Nome:</span>
            <InputText :upper-case="true" v-model="filtro.nome" />
          </v-col>
          <v-col cols="12" sm="4" class="mt-6">
            <v-btn color="primary" @click="localizarProduto">Pesquisar</v-btn>
            <v-btn class="ml-3" color="secondary" @click="limparFiltro">Limpar</v-btn>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12">
            <v-data-table :key="produtos.length" item-key="codigo" :items="produtos" :headers="headers" item-value="codigo" :item-class="highlightRow" class="elevation-1" dense>
              <template v-slot:item="{ item }">
                <tr :class="highlightRow(item)" @click="selecionarLinha(item)" @dblclick="selecionarPorDuploClique(item)" style="cursor: pointer">
                  <td>{{ item.codigo_barras }}</td>
                  <td>{{ item.descricao }}</td>
                </tr>
              </template>
            </v-data-table>
          </v-col>
        </v-row>

        <v-row justify="end" class="mt-4">
          <v-col cols="auto">
            <v-btn color="success" :disabled="!produtoSelecionado" @click="confirmarSelecao"> Selecionar </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import Produto from "@/infra/entity/Produto";

export default {
  inject: ["produtoController"],
  components: {
    InputNumber,
    InputText,
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo_barras" },
        { text: "Nome", value: "descricao" },
      ],
      produtos: [],
      filtro: {
        codigo_barras: "",
        nome: "",
      },
      produtoSelecionado: null,
    };
  },
  methods: {
    fechar() {
      this.$emit("selecionar", new Produto());
    },
    async localizarProduto() {
      const list = await this.produtoController.getAllByFilter(this.filtro);
      this.produtos = list;
    },
    async limparFiltro() {
      this.filtro = {
        codigo_barras: "",
        nome: "",
      };
      this.produtoSelecionado = null;
      await this.localizarProduto();
    },
    selecionarLinha(item) {
      this.produtoSelecionado = this.produtoSelecionado && this.produtoSelecionado.codigo === item.codigo ? null : item;
    },
    highlightRow(item) {
      return this.produtoSelecionado && this.produtoSelecionado.codigo === item.codigo ? "linha-selecionada" : "";
    },
    confirmarSelecao() {
      this.$emit("selecionar", this.produtoSelecionado);
    },
    selecionarPorDuploClique(item) {
      this.produtoSelecionado = item;
      this.confirmarSelecao();
    },
  },
};
</script>

<style scoped>
.linha-selecionada {
  background-color: #e3f2fd !important;
}
</style>
