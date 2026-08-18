<template>
  <v-card flat>
    <CabecalhoRelatorio
      titulo="Listagem de Produtos"
      :subtitulo="resumoFiltro"
      icone="mdi-format-list-bulleted"
      :carregando="carregando"
      :sem-dados="semDados"
      texto-atualizar="Pesquisar"
      @atualizar="pesquisar()"
      @exportar="exportarExcel"
    >
      <template v-slot:acoes>
        <v-btn color="red darken-1" outlined class="mr-2" :disabled="carregando || semDados" @click="exportarPDF">
          <v-icon left>mdi-file-pdf-box</v-icon>
          PDF
        </v-btn>
      </template>
    </CabecalhoRelatorio>

    <v-container fluid>
      <v-row dense>
        <v-col cols="12" sm="6" md="2">
          <v-autocomplete
            v-model="secao"
            :items="secaoList"
            item-text="nome"
            item-value="codigo"
            label="Seção"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="2">
          <v-autocomplete
            v-model="grupo"
            :items="grupoList"
            item-text="nome"
            item-value="codigo"
            label="Grupo"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="2">
          <v-autocomplete
            v-model="unidade"
            :items="unidades"
            label="Unidade"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="2">
          <v-autocomplete
            v-model="ativo"
            :items="opcoesAtivo"
            item-text="descricao"
            item-value="valor"
            label="Ativo"
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="4">
          <v-autocomplete
            v-model="loja"
            :items="opcoesLoja"
            item-text="descricao"
            item-value="codigo"
            label="Loja"
            prepend-inner-icon="mdi-store-outline"
            dense
            outlined
            hide-details
            :loading="carregandoLojas"
          ></v-autocomplete>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" sm="4" md="3">
          <label class="form-label">Fornecedor:</label>
          <input
            @focus="$event.target.select()"
            type="text"
            class="form-control"
            placeholder="Cód. Fornecedor"
            v-model="fornecedor"
            @blur="handleLoadFornecedor"
          />
        </v-col>
        <v-col cols="12" sm="8" md="6">
          <label class="form-label">Descrição Fornecedor:</label>
          <input type="text" class="form-control" placeholder="Descrição do Fornecedor" v-model="fornecedorDescricao" readonly />
        </v-col>
        <v-col cols="12" md="3" class="d-flex align-end">
          <v-checkbox v-model="comOferta" label="Somente com oferta" class="mt-0" hide-details></v-checkbox>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" sm="6" md="4">
          <label class="form-label">Código de Barras:</label>
          <input
            @focus="$event.target.select()"
            type="text"
            class="form-control"
            placeholder="Código de Barras"
            v-model="codigoBarras"
          />
        </v-col>
        <v-col cols="12" sm="6" md="5">
          <label class="form-label">Descrição do Produto:</label>
          <input
            @focus="$event.target.select()"
            type="text"
            class="form-control"
            placeholder="Descrição do Produto"
            v-model="descricao"
          />
        </v-col>
        <v-col cols="12" md="3" class="d-flex align-end">
          <v-checkbox v-model="comPreco2" label="Somente com preço 2" class="mt-0" hide-details></v-checkbox>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" class="d-flex justify-end">
          <v-btn text small color="grey darken-1" class="mr-2" @click="limparFiltros">
            <v-icon left small>mdi-filter-remove-outline</v-icon>
            Limpar
          </v-btn>
          <v-btn color="primary" :loading="carregando" @click="pesquisar()">
            <v-icon left>mdi-magnify</v-icon>
            Pesquisar
          </v-btn>
        </v-col>
      </v-row>

      <v-alert v-if="Number(loja) === 0" type="info" dense text class="mt-3 mb-0">
        Selecione uma loja para exibir preço, oferta e preço 2 do produto (valores cadastrados por loja).
      </v-alert>

      <v-divider class="my-3"></v-divider>

      <EstadoVazio v-if="!carregando && semDados" />
      <v-data-table v-else :headers="headers" :items="produtos" :items-per-page="15" :loading="carregando" class="elevation-1"></v-data-table>
    </v-container>
  </v-card>
</template>

<script>
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import { gerarExcel, gerarPDF } from "@/utils/exports";

export default {
  name: "RelatorioProdutoListagem",
  components: { CabecalhoRelatorio, EstadoVazio },
  data() {
    return {
      carregando: false,
      carregandoLojas: false,
      produtos: [],
      unidades: ["UN", "KG", "GR", "CX", "FD", "PCT", "PC", "DZ", "LT", "ML", "MT", "M2", "M3", "SC", "ROL", "PAR", "TON"],
      opcoesAtivo: [
        { valor: "", descricao: "Todos" },
        { valor: "S", descricao: "Somente ativos" },
        { valor: "N", descricao: "Somente inativos" },
      ],
      ativo: "",
      unidade: "",
      codigoBarras: "",
      descricao: "",
      comOferta: false,
      comPreco2: false,
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Cód. Barras", value: "codigo_barras" },
        { text: "Descrição", value: "descricao" },
        { text: "Unidade", value: "unidade" },
        { text: "Seção", value: "secao_nome" },
        { text: "Grupo", value: "grupo_nome" },
        { text: "Fornecedor", value: "fornecedor_nome" },
        { text: "Ativo", value: "ativo" },
        { text: "Preço", value: "preco" },
        { text: "Oferta", value: "oferta" },
        { text: "Preço 2", value: "preco2" },
        { text: "Qtd. Preço 2", value: "preco2_qtd" },
      ],
    };
  },
  computed: {
    secao: {
      get() {
        return this.$store.state.secao.secao.codigo;
      },
      async set(valor) {
        this.$store.commit("setSecaoCodigo", valor || "0");
        this.$store.commit("setGrupoSecao", valor || "0");
        await this.$store.dispatch("getGrupos", valor || "0");
      },
    },
    grupo: {
      get() {
        return this.$store.state.grupo.grupo.codigo;
      },
      set(valor) {
        this.$store.commit("setGrupoCodigo", valor || "0");
      },
    },
    secaoList() {
      return this.$store.state.secao.secaoList;
    },
    grupoList() {
      return this.$store.state.grupo.grupoList;
    },
    fornecedor: {
      get() {
        return this.$store.state.fornecedor.fornecedor.codigo;
      },
      set(valor) {
        this.$store.commit("setFornecedorCodigo", valor);
      },
    },
    fornecedorDescricao() {
      return this.$store.state.fornecedor.fornecedor.pessoa.nome;
    },
    loja: {
      get() {
        return this.$store.state.relatorio.filtro.loja;
      },
      set(valor) {
        this.$store.commit("setRelatorioLoja", valor || 0);
      },
    },
    lojaList() {
      return this.$store.state.loja.lojaList || [];
    },
    opcoesLoja() {
      return [
        { codigo: 0, descricao: "Todas as lojas" },
        ...this.lojaList.map((l) => ({
          codigo: Number(l.codigo),
          descricao: `${l.codigo} - ${l.nome || l.fantasia || ""}`.trim(),
        })),
      ];
    },
    lojaSelecionada() {
      const opcao = this.opcoesLoja.find((o) => o.codigo === Number(this.loja));
      return opcao ? opcao.descricao : "Todas as lojas";
    },
    resumoFiltro() {
      return `${this.produtos.length} produto(s) · ${this.lojaSelecionada}`;
    },
    semDados() {
      return this.produtos.length === 0;
    },
  },
  async mounted() {
    await this.$store.dispatch("getSecoes");
    this.carregandoLojas = true;
    try {
      await this.$store.dispatch("getLojas");
    } finally {
      this.carregandoLojas = false;
    }
    await this.pesquisar();
  },
  methods: {
    async handleLoadFornecedor() {
      if (!this.fornecedor) return;
      await this.$store.dispatch("getFornecedor", this.fornecedor);
    },
    async pesquisar() {
      const parametros = {
        secao: this.secao && this.secao !== "0" ? this.secao : "",
        grupo: this.grupo && this.grupo !== "0" ? this.grupo : "",
        fornecedor: this.fornecedor && String(this.fornecedor) !== "0" ? this.fornecedor : "",
        unidade: this.unidade || "",
        ativo: this.ativo || "",
        descricao: this.descricao || "",
        codigoBarras: this.codigoBarras || "",
        loja: this.loja || 0,
        comOferta: this.comOferta,
        comPreco2: this.comPreco2,
      };

      this.carregando = true;
      this.$store.commit("setContainerLoading", true);
      try {
        const res = await this.$store.dispatch("getRelatorioProdutoListagem", parametros);
        this.produtos = res.data;
      } finally {
        this.$store.commit("setContainerLoading", false);
        this.carregando = false;
      }
    },
    limparFiltros() {
      this.secao = "";
      this.grupo = "";
      this.$store.commit("setFornecedorCodigo", "0");
      this.$store.commit("resetFornecedor");
      this.unidade = "";
      this.ativo = "";
      this.codigoBarras = "";
      this.descricao = "";
      this.comOferta = false;
      this.comPreco2 = false;
      this.$store.commit("setRelatorioLoja", 0);
      this.pesquisar();
    },
    exportarExcel() {
      gerarExcel(this.produtos, "listagem_produtos.xlsx");
    },
    exportarPDF() {
      gerarPDF(
        "Listagem de Produtos",
        [
          { header: "Código", key: "codigo" },
          { header: "Cód. Barras", key: "codigo_barras" },
          { header: "Descrição", key: "descricao" },
          { header: "Unidade", key: "unidade" },
          { header: "Seção", key: "secao_nome" },
          { header: "Grupo", key: "grupo_nome" },
          { header: "Fornecedor", key: "fornecedor_nome" },
          { header: "Ativo", key: "ativo" },
          { header: "Preço", key: "preco" },
          { header: "Oferta", key: "oferta" },
          { header: "Preço 2", key: "preco2" },
          { header: "Qtd. Preço 2", key: "preco2_qtd" },
        ],
        this.produtos,
        "listagem_produtos.pdf"
      );
    },
  },
};
</script>
