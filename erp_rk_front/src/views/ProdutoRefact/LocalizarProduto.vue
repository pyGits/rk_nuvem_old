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
            <div class="text-caption grey--text text--darken-1">Busca também nos códigos auxiliares</div>
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
                  <td>
                    <div>{{ item.codigo_barras }}</div>
                    <!-- Quando o produto foi achado por um código auxiliar, mostra qual foi
                         para o usuário entender o porquê de ele estar no resultado. -->
                    <div v-if="auxiliaresEncontrados(item).length" class="text-caption grey--text text--darken-1">aux: {{ auxiliaresEncontrados(item).join(", ") }}</div>
                  </td>
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

// Mesma normalização do backend: códigos de barras são gravados sem os zeros à
// esquerda, então "0789" casa com o código "789".
function normalizarTermoCodigo(termo) {
  const valor = String(termo || "").trim();
  if (!/^\d+$/.test(valor)) return valor;
  return valor.replace(/^0+/, "") || valor;
}

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
      // Termo de código usado na última pesquisa, só para destacar o auxiliar que casou.
      termoPesquisado: "",
    };
  },
  methods: {
    fechar() {
      this.$emit("selecionar", new Produto());
    },
    // Auxiliares do produto que casam com o código pesquisado.
    auxiliaresEncontrados(item) {
      if (!this.termoPesquisado) return [];
      const auxiliares = Array.isArray(item.codigos_barras_auxiliares) ? item.codigos_barras_auxiliares : [];
      return auxiliares.filter((codigo) => String(codigo).includes(this.termoPesquisado));
    },
    async localizarProduto() {
      this.termoPesquisado = normalizarTermoCodigo(this.filtro.codigo_barras);
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
