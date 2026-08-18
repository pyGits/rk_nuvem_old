<template>
  <v-card>
    <v-card-title>Cadastro de Produtos</v-card-title>

    <v-card-text class="pb-0">
      <v-row dense align="center">
        <v-col cols="12" sm="6" md="3">
          <v-autocomplete
            v-model="secao"
            :items="opcoesSecao"
            item-text="descricao"
            item-value="codigo"
            label="Seção"
            prepend-inner-icon="mdi-shape-outline"
            dense
            outlined
            hide-details
            clearable
          ></v-autocomplete>
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-autocomplete
            v-model="grupo"
            :items="opcoesGrupo"
            item-text="descricao"
            item-value="codigo"
            label="Grupo"
            prepend-inner-icon="mdi-file-tree-outline"
            dense
            outlined
            hide-details
            clearable
            :disabled="!secao"
            :loading="carregandoGrupos"
            :no-data-text="secao ? 'Nenhum grupo nesta seção' : 'Selecione uma seção'"
          ></v-autocomplete>
        </v-col>

        <v-col cols="12" md="4">
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Pesquisar"
            dense
            outlined
            hide-details
            single-line
            clearable
          ></v-text-field>
        </v-col>

        <v-col cols="12" md="2" class="text-md-right">
          <v-btn text small color="grey darken-1" :disabled="!filtroAtivo" @click="limparFiltros">
            <v-icon left small>mdi-filter-remove-outline</v-icon>
            Limpar
          </v-btn>
        </v-col>
      </v-row>

      <div v-if="filtroAtivo" class="text-caption grey--text text--darken-1 mt-2">
        {{ itens.length }} de {{ items.length }} produtos
      </div>
    </v-card-text>

    <v-data-table
      id="tableProduto"
      :headers="headers"
      :items="itens"
      :search="search"
      sort-by="codigo_barras"
      :footer-props="{
        'items-per-page-text': 'Produtos por pág.',
      }"
      @click:row="selecionarProduto"
    >
      <template v-slot:no-data>
        <div class="py-6 grey--text">Nenhum produto encontrado para os filtros selecionados.</div>
      </template>
    </v-data-table>

    <div class="d-flex flex-row-reverse container">
      <v-btn color="primary" @click="novoProduto" class="mr-2">Novo Produto</v-btn>
    </div>
  </v-card>
</template>

<script>
// Compara como número quando os dois lados são numéricos; o que não for número
// vai para o fim da lista em vez de bagunçar a ordem.
function ordenarNumerico(a, b) {
  const na = Number(a);
  const nb = Number(b);
  const aValido = a !== null && a !== "" && Number.isFinite(na);
  const bValido = b !== null && b !== "" && Number.isFinite(nb);

  if (aValido && bValido) return na - nb;
  if (aValido) return -1;
  if (bValido) return 1;
  return String(a || "").localeCompare(String(b || ""));
}

export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await Promise.all([this.$store.dispatch("getProdutos"), this.$store.dispatch("getSecoes")]);
    this.$store.commit("setContainerLoading", false);
  },
  data() {
    return {
      headers: [
        // codigo e codigo_barras são varchar no banco, então a ordenação padrão
        // seria alfabética (1, 10, 100, 2...). Ordenamos como número, jogando
        // eventuais códigos não numéricos para o fim.
        { text: "Código", value: "codigo", width: 120, sort: ordenarNumerico },
        { text: "Código Barras", value: "codigo_barras", sort: ordenarNumerico },
        { text: "Produto", value: "descricao" },
      ],
      search: "",
      secao: null,
      grupo: null,
      carregandoGrupos: false,
    };
  },
  watch: {
    // Grupos dependem da seção: ao trocar de seção, recarrega a lista e
    // descarta o grupo anterior, que não pertence mais a ela.
    async secao(novaSecao) {
      this.grupo = null;
      if (!novaSecao) return;

      this.carregandoGrupos = true;
      try {
        await this.$store.dispatch("getGrupos", novaSecao);
      } finally {
        this.carregandoGrupos = false;
      }
    },
  },
  computed: {
    items() {
      return this.$store.state.produto.produtoList;
    },
    opcoesSecao() {
      return (this.$store.state.secao.secaoList || []).map((s) => ({
        codigo: s.codigo,
        descricao: `${s.codigo} - ${s.nome}`,
      }));
    },
    opcoesGrupo() {
      return (this.$store.state.grupo.grupoList || []).map((g) => ({
        codigo: g.codigo,
        descricao: `${g.codigo} - ${g.nome}`,
      }));
    },
    filtroAtivo() {
      return !!this.secao || !!this.grupo || !!this.search;
    },
    itens() {
      // secao/grupo do produto podem vir como número ou string conforme a origem
      // do cadastro, então a comparação é feita sempre como texto.
      return this.items.filter((produto) => {
        if (this.secao && String(produto.secao) !== String(this.secao)) return false;
        if (this.grupo && String(produto.grupo) !== String(this.grupo)) return false;
        return true;
      });
    },
  },
  methods: {
    selecionarProduto(produto) {
      this.$router.push({ path: "/cadastro/produto/" + produto.codigo });
    },
    novoProduto() {
      this.$router.push({ path: "/cadastro/produto/novo" });
    },
    limparFiltros() {
      this.secao = null;
      this.grupo = null;
      this.search = "";
    },
  },
};
</script>

<style lang="scss" scoped>
#tableProduto {
  cursor: pointer;
}
</style>
