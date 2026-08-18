<template>
  <v-container fluid>
    <v-sheet class="pa-4 mb-4" elevation="1" rounded color="grey lighten-4">
      <v-row dense>
        <v-col cols="12" sm="6" md="3">
          <v-autocomplete
            :items="secaoList"
            v-model="secao"
            id="secao"
            item-text="nome"
            item-value="codigo"
            label="Seção"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <v-autocomplete
            id="grupo"
            item-text="nome"
            item-value="codigo"
            v-model="grupo"
            :items="grupoList"
            label="Grupo"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" sm="6" md="2">
          <v-autocomplete
            :items="unidades"
            item-text="nome"
            item-value="codigo"
            v-model="unidade"
            label="Unidade"
            clearable
            dense
            outlined
            hide-details
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" md="4" class="d-flex align-center flex-wrap">
          <v-checkbox v-model="positivo" label="Positivo" class="mt-0 mr-4" dense hide-details @change="handleCheckboxChange"></v-checkbox>
          <v-checkbox v-model="negativo" label="Negativo" class="mt-0 mr-4" dense hide-details @change="handleCheckboxChange"></v-checkbox>
          <v-checkbox v-model="zerado" label="Zerado" class="mt-0 mr-4" dense hide-details @change="handleCheckboxChange"></v-checkbox>
          <v-checkbox v-model="reposicao" label="Reposição" class="mt-0" dense hide-details @change="handleReposicaoCheckboxChange"></v-checkbox>
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
          <v-btn text small color="primary" @click="openFornecedorDialog">
            <v-icon left small>mdi-magnify</v-icon>
            Localizar fornecedor
          </v-btn>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" sm="4" md="3">
          <label class="form-label">Loja:</label>
          <input
            @focus="$event.target.select()"
            v-model="loja"
            type="text"
            class="form-control"
            placeholder="Código da Loja"
            @blur="handleLoadLoja"
          />
        </v-col>
        <v-col cols="12" sm="8" md="6">
          <label class="form-label">Descrição Loja:</label>
          <input type="text" class="form-control" placeholder="Descrição da Loja" v-model="lojaDescricao" readonly />
        </v-col>
        <v-col cols="12" md="3" class="d-flex align-end">
          <v-btn text small color="primary" @click="openLojaDialog">
            <v-icon left small>mdi-magnify</v-icon>
            Localizar loja
          </v-btn>
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
        <v-col cols="12" sm="6" md="8">
          <label class="form-label">Descrição do Produto:</label>
          <input
            @focus="$event.target.select()"
            type="text"
            class="form-control"
            placeholder="Descrição do Produto"
            v-model="descricaoProduto"
          />
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" class="d-flex justify-end">
          <v-btn color="primary" depressed class="mr-2" @click="handleGerarRelatorio(false)">
            <v-icon left>mdi-magnify</v-icon>
            Atualizar
          </v-btn>
          <v-btn color="success" outlined @click="handleGerarRelatorio(true)">
            <v-icon left>mdi-file-excel-outline</v-icon>
            Gerar Excel
          </v-btn>
        </v-col>
      </v-row>
    </v-sheet>

    <v-data-table
      :headers="headers"
      :items="filteredRelSaldoEstoque"
      :items-per-page="10"
      class="elevation-1"
    ></v-data-table>

    <ModalFornecedor />
    <ModalLoja />
  </v-container>
</template>

<script>
import { gerarExcel } from "@/utils/exports";
import ModalFornecedor from "@/views/Fornecedor/ModalFornecedor.vue";
import ModalLoja from "@/views/Loja/ModalLoja.vue";
export default {
  async mounted() {
    await this.$store.dispatch("getSecoes");
  },
  computed: {
    secao: {
      get() {
        return this.$store.state.secao.secao.codigo;
      },
      async set(valor) {
        this.$store.commit("setSecaoCodigo", valor);
        this.$store.commit("setGrupoSecao", valor);
        await this.$store.dispatch("getGrupos", valor);
      },
    },
    grupo: {
      get() {
        return this.$store.state.grupo.grupo.codigo;
      },
      set(valor) {
        this.$store.commit("setGrupoCodigo", valor);
      },
    },
    secaoList: {
      get() {
        return this.$store.state.secao.secaoList;
      },
    },
    grupoList: {
      get() {
        return this.$store.state.grupo.grupoList;
      },
    },
    lojaDescricao: {
      get() {
        return this.$store.state.loja.loja.pessoa.nome;
      },
    },
    loja: {
      get() {
        return this.$store.state.loja.loja.codigo;
      },
      set(valor) {
        this.$store.commit("setLojaCodigo", valor);
      },
    },
    fornecedor: {
      get() {
        return this.$store.state.fornecedor.fornecedor.codigo;
      },
      set(valor) {
        this.$store.commit("setFornecedorCodigo", valor);
      },
    },
    fornecedorDescricao: {
      get() {
        return this.$store.state.fornecedor.fornecedor.pessoa.nome;
      },
    },
    filteredRelSaldoEstoque() {
      if (!this.codigoBarras && !this.descricaoProduto) {
        return this.relSaldoEstoque;
      }

      const searchTermCodigoBarras = this.codigoBarras.toLowerCase();
      const searchTermDescricao = this.descricaoProduto.toLowerCase();

      return this.relSaldoEstoque.filter((produto) => {
        const codigoBarras = produto.codigo_barras.toLowerCase();
        const descricao = produto.descricao.toLowerCase();

        if (this.codigoBarras && this.descricaoProduto) {
          return (
            codigoBarras.includes(searchTermCodigoBarras) &&
            descricao.includes(searchTermDescricao)
          );
        } else if (this.codigoBarras) {
          return codigoBarras.includes(searchTermCodigoBarras);
        } else if (this.descricaoProduto) {
          return descricao.includes(searchTermDescricao);
        }

        return false;
      });
    },
  },
  data() {
    return {
      unidade: "",
      relSaldoEstoque: [],
      unidades: ["UN", "KG", "GR"],
      headers: [
        { text: "Cód.", value: "codigo" },
        { text: "Cód. Barras", value: "codigo_barras" },
        { text: "Nome", value: "descricao" },
        { text: "Saldo", value: "saldo_estoque" },
      ],
      positivo: true,
      negativo: true,
      zerado: true,
      reposicao: false,
      codigoBarras: "", // Campo de pesquisa por código de barras
      descricaoProduto: "", // Campo de pesquisa por descrição
    };
  },
  methods: {
    async handleLoadLoja() {
      await this.$store.dispatch("getLoja", this.loja);
    },
    async handleLoadFornecedor() {
      await this.$store.dispatch("getFornecedor", this.fornecedor);
    },
    handleCheckboxChange() {
      if (this.positivo || this.negativo || this.zerado) {
        this.reposicao = false;
      }
    },
    handleReposicaoCheckboxChange() {
      if (this.reposicao) {
        this.positivo = false;
        this.negativo = false;
        this.zerado = false;
      }
    },
    async handleGerarRelatorio(excel) {
      const parametros = {
        positivo: this.positivo,
        negativo: this.negativo,
        zerado: this.zerado,
        reposicao: this.reposicao,
        secao: this.secao,
        grupo: this.grupo,
        unidade: this.unidade,
        fornecedor: this.fornecedor,
        loja: this.loja,
      };
      this.$store.commit("setContainerLoading", true);
      await this.$store
        .dispatch("getPainelEstoqueSaldo", parametros)
        .then((res) => {
          this.relSaldoEstoque = res.data;
        });
      if (excel) {
        gerarExcel(this.relSaldoEstoque);
      }
      this.$store.commit("setContainerLoading", false);
    },
    openFornecedorDialog() {
      this.$store.commit("setDialogFornecedor", true);
    },
    openLojaDialog() {
      this.$store.commit("setDialogLoja", true);
    },
  },
  components: { ModalFornecedor, ModalLoja },
};
</script>
