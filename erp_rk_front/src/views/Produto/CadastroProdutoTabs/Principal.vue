<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="1">
        <label class="form-label" for="input-example">Código:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Código do Produto"
          id="codigo"
          v-model="codigo"
          :disabled="true"
        />
        <div v-if="errorCodigo" class="form-text text-danger">
          {{ errorCodigoMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="3">
        <label class="form-label" for="input-example">Código Barras:</label>
        <input
          type="text"
          class="form-control"
          placeholder="Código do Produto"
          id="codigo_barras"
          @keyup.enter="focusNextInput($event, 'descricao')"
          v-model="codigo_barras"
          :disabled="mode === 'UPDATE'"
        />
        <div v-if="errorCodigo" class="form-text text-danger">
          {{ errorCodigoMessage }}
        </div>
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example">Descrição:</label>
        <input
          @keyup.enter="focusNextInput($event, 'secao')"
          type="text"
          id="descricao"
          ref="descricao"
          class="form-control"
          placeholder="Descrição do Produto"
          v-model="descricao"
        />
        <div v-if="errorDescricao" class="form-text text-danger">
          {{ errorDescricaoMessage }}
        </div>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" sm="3">
        Seção:
        <v-autocomplete
          id="secao"
          ref="secao"
          v-model="secao"
          @keyup.enter="focusNextInput($event, 'grupo')"
          item-text="nome"
          item-value="codigo"
          :items="secaoList"
        ></v-autocomplete>
      </v-col>
      <v-col cols="12" sm="3">
        Grupo:
        <v-autocomplete
          ref="grupo"
          @keyup.enter="focusNextInput($event, 'fornecedor')"
          v-model="grupo"
          :items="grupoList"
          item-text="nome"
          item-value="codigo"
        ></v-autocomplete>
      </v-col>
      <v-col cols="12" sm="4">
        Fornecedor:
        <v-autocomplete
          ref="fornecedor"
          v-model="fornecedor"
          :items="fornecedorList"
          item-text="nome"
          item-value="codigo"
        ></v-autocomplete>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" sm="2">
        Forma de Venda:
        <v-radio-group v-model="formaVenda">
          <v-radio label="Unitario" value="N"></v-radio>
          <v-radio label="Fracionado" value="S"></v-radio>
        </v-radio-group>
      </v-col>
      <v-col cols="12" sm="2">
        Informações
        <v-checkbox
          v-model="balanca"
          true-value="S"
          false-value="N"
          label="Envia Balança"
          class="mt-0"
        ></v-checkbox>
        <v-checkbox
          v-model="ativo"
          true-value="N"
          false-value="S"
          label="Inativo"
          class="mt-0"
        ></v-checkbox>
        <v-checkbox
          v-model="diversos"
          true-value="S"
          false-value="N"
          label="Preço Variável"
          class="mt-0"
        ></v-checkbox>
      </v-col>
      <v-col cols="12" sm="2">
        Unidade:
        <v-select
          v-model="unidade"
          :items="unidades"
          item-text="descricao"
          item-value="codigo"
        ></v-select>
      </v-col>
      <v-col cols="12" sm="3">
        Validade Balança
        <input
          type="number"
          class="form-control"
          placeholder="Validade"
          v-model.number="balanca_validade"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import secao from "@/store/modules/secao";

export default {
  data() {
    return {
      unidades: [
        { codigo: "UN", descricao: "UN - Unidade" },
        { codigo: "MT", descricao: "MT - Metro" },
        { codigo: "ML", descricao: "ML - Mililitro" },
        { codigo: "KG", descricao: "KG - Quilograma" },
        { codigo: "LT", descricao: "LT - Litro" },
        { codigo: "CX", descricao: "CX - Caixa" },
        { codigo: "GR", descricao: "GR - Grama" },
      ],
      balancas_list: [
        { codigo: "S", descricao: "Sim" },
        { codigo: "N", descricao: "Não" },
      ],
      diversos_list: [
        { codigo: "S", descricao: "Sim" },
        { codigo: "N", descricao: "Não" },
      ],
      ativo_list: [
        { codigo: "S", descricao: "Sim" },
        { codigo: "N", descricao: "Não" },
      ],
      formaVendas: [
        { codigo: "N", descricao: "Unitário" },
        { codigo: "S", descricao: "Fracionado" },
      ],
    };
  },
  methods: {
    focusNextInput(event, nextInputRef) {
      this.$refs[nextInputRef].focus();
    },
  },
  computed: {
    fornecedorList: {
      get() {
        return this.$store.state.fornecedor.fornecedorList;
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
    codigo: {
      get() {
        return this.$store.state.produto.produto.codigo;
      },
      set(valor) {
        this.$store.commit("setProdutoCodigo", valor);
      },
    },
    codigo_barras: {
      get() {
        return this.$store.state.produto.produto.codigo_barras;
      },
      set(valor) {
        this.$store.commit("setProdutoCodigoBarras", valor);
      },
    },
    descricao: {
      get() {
        return this.$store.state.produto.produto.descricao;
      },
      set(valor) {
        this.$store.commit("setProdutoDescricao", valor);
      },
    },
    secao: {
      get() {
        return this.$store.state.produto.produto.secao;
      },
      async set(valor) {
        this.$store.commit("setProdutoGrupo", "0");
        this.$store.commit("setProdutoSecao", valor);
        await this.$store.dispatch(
          "getGrupos",
          this.$store.state.produto.produto.secao
        );
      },
    },
    fornecedor: {
      get() {
        return this.$store.state.produto.produto.fornecedor;
      },
      set(valor) {
        this.$store.commit("setProdutoFornecedor", valor);
      },
    },
    grupo: {
      get() {
        return this.$store.state.produto.produto.grupo;
      },
      set(valor) {
        this.$store.commit("setProdutoGrupo", valor);
      },
    },
    unidade: {
      get() {
        return this.$store.state.produto.produto.unidade;
      },
      set(valor) {
        this.$store.commit("setProdutoUnidade", valor);
      },
    },
    formaVenda: {
      get() {
        return this.$store.state.produto.produto.formaVenda;
      },
      set(valor) {
        this.$store.commit("setProdutoFormaVenda", valor);
      },
    },
    balanca: {
      get() {
        return this.$store.state.produto.produto.balanca;
      },
      set(valor) {
        this.$store.commit("setProdutoBalanca", valor);
      },
    },
    balanca_validade: {
      get() {
        return this.$store.state.produto.produto.balanca_validade;
      },
      set(valor) {
        this.$store.commit("setProdutoBalancaValidade", valor);
      },
    },
    ativo: {
      get() {
        return this.$store.state.produto.produto.ativo;
      },
      set(valor) {
        this.$store.commit("setProdutoAtivo", valor);
      },
    },
    diversos: {
      get() {
        return this.$store.state.produto.produto.diversos;
      },
      set(valor) {
        this.$store.commit("setProdutoDiversos", valor);
      },
    },

    errorCodigo: {
      get() {
        return this.$store.state.error.error.produto.codigo;
      },
    },
    errorCodigoMessage: {
      get() {
        return this.$store.state.error.error.produto.codigo_message;
      },
    },
    errorDescricao: {
      get() {
        return this.$store.state.error.error.produto.descricao;
      },
    },
    errorDescricaoMessage: {
      get() {
        return this.$store.state.error.error.produto.descricao_message;
      },
    },
    mode: {
      get() {
        return this.$store.state.Application.mode;
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
