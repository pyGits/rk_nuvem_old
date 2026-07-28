<template>
  <div>
    <v-card>
      <v-card-title>Localizar Tributação</v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12">
            <v-data-table :items="tributacoes" :headers="headers" item-value="codigo" :item-class="highlightRow" :key="tributacoes.length" item-key="codigo" class="elevation-1" dense hide-default-footer>
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
            <v-btn color="success" :disabled="!tributacaoSelecionada" @click="confirmarSelecao"> Selecionar </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";

export default {
  inject: ["tributacaoController"],
  components: {
    InputNumber,
    InputText,
  },
  data() {
    return {
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Nome", value: "nome" },
      ],
      tributacoes: [],
      tributacaoSelecionada: null,
    };
  },
  async mounted() {
    await this.localizarTributacao();
  },
  methods: {
    async localizarTributacao() {
      const res = await this.tributacaoController.getAll();
      this.tributacoes = res.data;
    },

    selecionarLinha(item) {
      this.tributacaoSelecionada = this.tributacaoSelecionada && this.tributacaoSelecionada.codigo === item.codigo ? null : item;
    },
    highlightRow(item) {
      return this.tributacaoSelecionada && this.tributacaoSelecionada.codigo === item.codigo ? "linha-selecionada" : "";
    },
    confirmarSelecao() {
      this.$emit("selecionar", this.tributacaoSelecionada);
    },
    selecionarPorDuploClique(item) {
      this.tributacaoSelecionada = item;
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
