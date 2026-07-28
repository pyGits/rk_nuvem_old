<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="3">
        Seção:
        <v-autocomplete
          :items="secaoList"
          v-model="secao"
          id="secao"
          item-text="nome"
          item-value="codigo"
        ></v-autocomplete>
      </v-col>
      <v-col cols="12" sm="3">
        Grupo:
        <v-autocomplete
          id="grupo"
          item-text="nome"
          item-value="codigo"
          v-model="grupo"
          :items="grupoList"
        ></v-autocomplete>
      </v-col>
      <v-col cols="12" sm="2">
        Unidade:
        <v-autocomplete
          :items="unidades"
          item-text="nome"
          item-value="codigo"
          v-model="unidade"
        ></v-autocomplete>
      </v-col>
      <v-col cols="12" sm="2">
        Tipo:
        <v-checkbox
          v-model="positivo"
          label="Positivo"
          class="mt-0"
          @change="handleCheckboxChange"
        ></v-checkbox>
        <v-checkbox
          v-model="negativo"
          label="Negativo"
          class="mt-0"
          @change="handleCheckboxChange"
        ></v-checkbox>
      </v-col>
      <v-col cols="12" sm="2">
        ---
        <v-checkbox
          v-model="zerado"
          label="Zerado"
          class="mt-0"
          @change="handleCheckboxChange"
        ></v-checkbox>
        <v-checkbox
          v-model="reposicao"
          label="Reposição"
          class="mt-0"
          @change="handleReposicaoCheckboxChange"
        ></v-checkbox>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Fornecedor:</label>
        <input
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          placeholder="Cód Fornecedor"
          v-model="fornecedor"
          @blur="handleLoadFornecedor"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example"
          >Descrição Fornecedor:</label
        >
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição do Fornecedor"
            v-model="fornecedorDescricao"
            readonly
          />
          <v-btn icon color="primary" @click="openFornecedorDialog">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Loja:</label>
        <input
          @focus="$event.target.select()"
          v-model="loja"
          type="text"
          class="form-control"
          placeholder="Nome da Tributação"
          @blur="handleLoadLoja"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example">Descrição Loja:</label>
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição da Loja"
            v-model="lojaDescricao"
            readonly
          />
          <v-btn icon color="primary" @click="openLojaDialog">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Gerar:</label>
        <v-btn color="primary" class="mr-2" @click="handleGerarRelatorio(false)"
          >Atualizar</v-btn
        >
        <v-btn
          color="seccondary"
          style="margin-top: 10px"
          class="mr-2"
          @click="handleGerarRelatorio(true)"
          >Gerar Excel</v-btn
        >
      </v-col>
    </v-row>
    <v-divider></v-divider>
    <v-row>
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Código de Barras:</label>
        <input
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          placeholder="Código de Barras"
          v-model="codigoBarras"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example"
          >Descrição do Produto:</label
        >
        <input
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          placeholder="Descrição do Produto"
          v-model="descricaoProduto"
        />
      </v-col>
    </v-row>
    <v-row>
      <v-data-table
        :headers="headers"
        :items="filteredRelSaldoEstoque"
        :items-per-page="10"
        class="elevation-1"
      ></v-data-table>
    </v-row>
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
