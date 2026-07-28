<template>
  <div>
    <v-data-table
      id="tablePreco"
      :headers="headers"
      :items="precosMascarados"
      :footer-props="{
        'items-per-page-text': 'Preços por pág.',
      }"
      @click:row="selecionarPreco"
    >
    </v-data-table>
    <!-- MODAL -->
    <v-dialog v-model="dialog" width="auto">
      <v-card>
        <v-card-title>
          <span class="headline">Preços</span>
        </v-card-title>

        <v-card-text>
          <v-row>
            <v-col cols="12" sm="6">
              <label class="form-label" for="input-example">Loja:</label>
              <input disabled type="text" class="form-control" placeholder="Loja" v-model="nome_loja" />
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Custo:</label>
              <input v-model="custo" type="text" class="form-control" placeholder="Custo do Produto" />
            </v-col>

            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Markup:</label>
              <input v-model="markup" type="text" class="form-control" placeholder="Markup do Produto" />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Preço:</label>
              <input v-model="preco" type="text" class="form-control" placeholder="Preço do Produto" />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Preço Oferta:</label>
              <input v-model="oferta" type="text" class="form-control" placeholder="Preço do Produto" />
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Margem Praticada:</label>
              <input disabled v-model="margemPraticada" type="text" class="form-control" placeholder="Markup do Produto" />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Markdown:</label>
              <input disabled v-model="markDown" type="text" class="form-control" placeholder="Markup do Produto" />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Sugestão:</label>
              <input disabled v-model="sugestao" type="text" class="form-control" placeholder="Markup do Produto" />
            </v-col>
          </v-row>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="atualizarPrecoLista">Atualizar</v-btn>
          <v-btn color="primary" @click="aceitarSugestao">Aceitar Sugestão</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { maskMoney, maskMoneyToFloat, maskAmount } from "./../../../utils/masks";
export default {
  data() {
    return {
      dialog: false,
      headers: [
        { text: "Cód.", value: "codigo" },
        { text: "Loja", value: "loja" },
        { text: "Custo", value: "custo" },
        { text: "Markup", value: "markup" },
        { text: "Preço", value: "preco" },
        { text: "Oferta", value: "oferta" },
      ],
    };
  },
  methods: {
    atualizarPrecoLista() {
      this.dialog = false;
      this.$store.commit("updatePrecoList", this.$store.state.preco.preco);
    },
    aceitarSugestao() {
      this.dialog = false;
      this.$store.commit("updatePrecoListSugestao", this.$store.state.preco.preco);
    },
    selecionarPreco(preco) {
      this.dialog = true;
      this.$store.commit("resetPreco");
      preco.markupGrupoSubgrupo = this.getMarkupDefault(maskMoneyToFloat(preco.markup));
      this.$store.commit("setPreco", preco);
    },
    // obter margem no grupo ou na secao
    getMarkupDefault(markupAtual) {
      if (markupAtual === 0) {
        // pega markup do grupo
        const codigoSecao = this.$store.state.produto.produto.secao;
        const codigoGrupo = this.$store.state.produto.produto.grupo;
        const grupo = this.$store.state.grupo.grupoList.find((grupo) => grupo.codigo === codigoGrupo && grupo.codigo_secao === codigoSecao);
        if (grupo && grupo.margem > 0) {
          return grupo.margem;
        }

        const secao = this.$store.state.secao.secaoList.find((secao) => secao.codigo === codigoSecao);

        if (secao && secao.margem > 0) {
          return secao.margem;
        }
        return 0;
      } else {
        return markupAtual;
      }
    },
  },
  computed: {
    nome_loja: {
      get() {
        return this.$store.state.preco.preco.codigo_loja + " - " + this.$store.state.preco.preco.nome_loja;
      },
    },
    precosMascarados() {
      return this.items.map((preco) => {
        return {
          ...preco,
          preco: maskMoney(preco.preco),
          custo: maskMoney(preco.custo),
          markup: maskAmount(preco.markup),
          oferta: maskMoney(preco.oferta),
        };
      });
    },
    items: {
      get() {
        return this.$store.state.preco.precoList;
      },
    },
    preco: {
      get() {
        return maskMoney(this.$store.state.preco.preco.preco);
      },
      set(valor) {
        this.$store.commit("setPrecoPreco", maskMoneyToFloat(valor));
      },
    },
    custo: {
      get() {
        return maskMoney(this.$store.state.preco.preco.custo);
      },
      set(valor) {
        this.$store.commit("setPrecoCusto", maskMoneyToFloat(valor));
      },
    },
    sugestao: {
      get() {
        return maskMoney(this.$store.state.preco.preco.sugestao);
      },
      set(valor) {
        this.$store.commit("setPrecoSugestao", maskMoneyToFloat(valor));
      },
    },
    markup: {
      get() {
        return maskAmount(this.$store.state.preco.preco.markup);
      },
      set(valor) {
        this.$store.commit("setPrecoMarkup", maskMoneyToFloat(valor));
      },
    },
    margemPraticada: {
      get() {
        return maskAmount(this.$store.state.preco.preco.margemPraticada);
      },
      set(valor) {
        this.$store.commit("setPrecoMargemPraticada", maskMoneyToFloat(valor));
      },
    },
    markDown: {
      get() {
        return maskAmount(this.$store.state.preco.preco.markDown);
      },
      set(valor) {
        this.$store.commit("setPrecoMarkDown", maskMoneyToFloat(valor));
      },
    },
    oferta: {
      get() {
        return maskMoney(this.$store.state.preco.preco.oferta);
      },
      set(valor) {
        this.$store.commit("setPrecoOferta", maskMoneyToFloat(valor));
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tablePreco {
  cursor: pointer;
}
</style>
