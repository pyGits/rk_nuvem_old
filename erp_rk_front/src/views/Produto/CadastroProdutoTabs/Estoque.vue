<template>
  <div>
    <v-data-table
      id="tableEstoque"
      :headers="headers"
      :items="estoquesMascarados"
      :footer-props="{
        'items-per-page-text': 'Preços por pág.',
      }"
      @click:row="selecionarEstoque"
    >
    </v-data-table>
    <!-- MODAL -->
    <v-dialog v-model="dialog" content-class="my-dialog">
      <v-card>
        <v-card-title>
          <span class="headline">Saldo Estoque:</span>
        </v-card-title>

        <v-card-text>
          <v-row>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Loja:</label>
              <input disabled type="text" class="form-control" placeholder="Loja" v-model="nome_loja" />
            </v-col>

            <v-col cols="12" sm="2">
              <label class="form-label" for="input-example">Estoque Mínimo:</label>
              <!-- <input v-model="estoque_minimo" type="text" class="form-control" placeholder="Estoque Mínimo" /> -->
              <InputQuantity v-model="estoque_minimo"></InputQuantity>
            </v-col>
            <v-col cols="12" sm="2">
              <label class="form-label" for="input-example">Estoque Máximo:</label>
              <!-- <input v-model="estoque_maximo" type="text" class="form-control" placeholder="Estoque Máximo" /> -->
              <InputQuantity v-model="estoque_maximo"></InputQuantity>
            </v-col>
            <v-col cols="12" sm="2">
              <label class="form-label" for="input-example">Saldo Estoque:</label>
              <!-- <input v-model="estoque" type="text" class="form-control" placeholder="Saldo Estoque" /> -->
              <InputQuantity v-model="estoque"></InputQuantity>
            </v-col> </v-row
        ></v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="atualizarEstoqueLista">Gravar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import InputQuantity from "@/components/Input/InputQuantity.vue";
import { maskAmount, maskMoneyToFloat, maskQtd } from "./../../../utils/masks";
export default {
  components: {
    InputQuantity,
  },
  data() {
    return {
      dialog: false,
      headers: [
        { text: "Cód.", value: "codigo" },
        { text: "Loja", value: "loja" },
        { text: "Estoque Mínimo", value: "estoque_minimo" },
        { text: "Estoque Máximo", value: "estoque_maximo" },
        { text: "Saldo Estoque", value: "estoque" },
        { text: "Última Saída", value: "ultima_saida" },
      ],
    };
  },
  methods: {
    atualizarEstoqueLista() {
      if (maskMoneyToFloat(this.estoque_minimo) > maskMoneyToFloat(this.estoque_maximo)) {
        this.$store.dispatch("showToastMessage", "Estoque Mínimo não pode ser maior que máximo !");
      } else {
        this.dialog = false;
        this.$store.commit("updateEstoqueList", this.$store.state.estoque.estoque);
      }
    },
    selecionarEstoque(estoque) {
      this.dialog = true;
      this.$store.commit("resetEstoque");
      this.$store.commit("setEstoque", estoque);
    },
  },
  computed: {
    nome_loja: {
      get() {
        return this.$store.state.estoque.estoque.codigo_loja + " - " + this.$store.state.estoque.estoque.nome_loja;
      },
    },
    estoquesMascarados() {
      return this.items.map((estoque) => {
        return {
          ...estoque,
          estoque: maskQtd(estoque.estoque),
          estoque_minimo: maskQtd(estoque.estoque_minimo),
          estoque_maximo: maskQtd(estoque.estoque_maximo),
          ultima_saida: new Date(estoque.ultima_saida).toLocaleString(),
        };
      });
    },
    items: {
      get() {
        return this.$store.state.estoque.estoqueList;
      },
    },
    estoque: {
      get() {
        console.log(this.$store.state.estoque.estoque.estoque, "get");
        return this.$store.state.estoque.estoque.estoque;
      },
      set(valor) {
        this.$store.commit("setEstoqueEstoque", valor);
      },
    },
    estoque_minimo: {
      get() {
        return this.$store.state.estoque.estoque.estoque_minimo;
      },
      set(valor) {
        this.$store.commit("setEstoqueMinimo", valor);
      },
    },
    estoque_maximo: {
      get() {
        return this.$store.state.estoque.estoque.estoque_maximo;
      },
      set(valor) {
        this.$store.commit("setEstoqueMaximo", valor);
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tableEstoque {
  cursor: pointer;
}
.my-dialog {
  margin-bottom: 150px; /* ajuste a altura vertical do modal aqui */
}
</style>
