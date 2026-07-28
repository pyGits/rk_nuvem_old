<template>
  <div>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <span>Localizar Fornecedor</span>
        <v-btn icon small @click="fechar">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="2">
            <span>Código:</span>
            <InputNumber v-model="filtro.codigo" :limit="10" />
          </v-col>
          <v-col cols="12" sm="3">
            <span>CNPJ/CPF:</span>
            <InputNumber ref="inputCnpjCpf" v-model="filtro.cnpjcpf" :limit="14" />
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" sm="6">
            <span>Nome:</span>
            <InputText :upper-case="true" v-model="filtro.nome" />
          </v-col>
          <v-col cols="12" sm="4" class="mt-6">
            <v-btn color="primary" @click="localizarFornecedor">Pesquisar</v-btn>
            <v-btn class="ml-3" color="secondary" @click="limparFiltro">Limpar</v-btn>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12">
            <v-data-table :key="fornecedores.length" item-key="codigo" :items="fornecedores" :headers="headers" item-value="codigo" :item-class="highlightRow" class="elevation-1" dense>
              <template v-slot:item="{ item }">
                <tr :class="highlightRow(item)" @click="selecionarLinha(item)" @dblclick="selecionarPorDuploClique(item)" style="cursor: pointer">
                  <td>{{ item.codigo }}</td>
                  <td>{{ item.nome }}</td>
                  <td>{{ item.cnpjcpf }}</td>
                </tr>
              </template>
            </v-data-table>
          </v-col>
        </v-row>

        <v-row justify="end" class="mt-4">
          <v-col cols="auto">
            <v-btn color="success" :disabled="!fornecedorSelecionado" @click="confirmarSelecao"> Selecionar </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import Fornecedor from "@/infra/entity/Fornecedor";
import FornecedorService from "@/infra/service/FornecedorService";

export default {
  components: {
    InputNumber,
    InputText,
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Nome", value: "nome" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
      ],
      fornecedores: [],
      filtro: {
        codigo: "",
        nome: "",
        cnpjcpf: "",
      },
      fornecedorSelecionado: null,
    };
  },
  methods: {
    fechar() {
      this.$emit("selecionar", Fornecedor.create({}));
    },
    async localizarFornecedor() {
      const list = await FornecedorService.getAllByFilter(this.filtro);
      this.fornecedores = list;
    },
    async limparFiltro() {
      this.filtro = {
        codigo: "",
        nome: "",
        cnpjcpf: "",
      };
      this.fornecedorSelecionado = null;
      await this.localizarFornecedor();
    },
    selecionarLinha(item) {
      this.fornecedorSelecionado = this.fornecedorSelecionado && this.fornecedorSelecionado.codigo === item.codigo ? null : item;
    },
    highlightRow(item) {
      return this.fornecedorSelecionado && this.fornecedorSelecionado.codigo === item.codigo ? "linha-selecionada" : "";
    },
    confirmarSelecao() {
      this.$emit("selecionar", Fornecedor.create(this.fornecedorSelecionado));
    },
    selecionarPorDuploClique(item) {
      this.fornecedorSelecionado = item;
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
