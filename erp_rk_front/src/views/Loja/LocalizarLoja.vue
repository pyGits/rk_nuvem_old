<template>
  <div>
    <v-card>
      <v-card-title>Localizar Loja</v-card-title>
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
            <v-btn color="primary" @click="localizarLoja">Pesquisar</v-btn>
            <v-btn class="ml-3" color="secondary" @click="limparFiltro">Limpar</v-btn>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12">
            <!-- <v-data-table :key="notas.length" :headers="headersNotas" :items="notas" item-key="nrNota" class="elevation-1" hide-default-footer></v-data-table> -->
            <v-data-table :items="lojas" :headers="headers" item-value="codigo" :item-class="highlightRow" :key="lojas.length" item-key="codigo" class="elevation-1" dense hide-default-footer>
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
            <v-btn color="success" :disabled="!lojaSelecionado" @click="confirmarSelecao"> Selecionar </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import LojaService from "@/infra/service/LojaService";

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
      lojas: [],
      filtro: {
        codigo: "",
        nome: "",
        cnpjcpf: "",
      },
      lojaSelecionado: null,
    };
  },
  methods: {
    async localizarLoja() {
      const list = await LojaService.getAllByFilter(this.filtro);
      this.lojas = list;
    },
    limparFiltro() {
      this.filtro = {
        codigo: "",
        nome: "",
        cnpjcpf: "",
      };
      this.lojaSelecionado = null;
    },
    selecionarLinha(item) {
      this.lojaSelecionado = this.lojaSelecionado && this.lojaSelecionado.codigo === item.codigo ? null : item;
    },
    highlightRow(item) {
      return this.lojaSelecionado && this.lojaSelecionado.codigo === item.codigo ? "linha-selecionada" : "";
    },
    confirmarSelecao() {
      this.$emit("selecionar", this.lojaSelecionado);
    },
    selecionarPorDuploClique(item) {
      this.lojaSelecionado = item;
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
