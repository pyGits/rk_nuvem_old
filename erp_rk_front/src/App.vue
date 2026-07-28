<template><Home></Home></template>

<script lang="ts">
import "bootstrap/dist/css/bootstrap.min.css";
import Vue, { inject, provide } from "vue";
import Home from "./views/Home/Home.vue";
import NotaFiscalEntradaController from "./infra/controller/NotaFiscalEntradaController";
import { NotaFiscalEntradaRepositoryApi } from "./infra/repository/NotaFiscalEntradaRepository";
import FornecedorController from "./infra/controller/FornecedorController";

import { FornecedorRepositoryApi } from "./infra/repository/FornecedorRepository";
import ProdutoController from "./infra/controller/ProdutoController";
import SecaoController from "./infra/controller/SecaoController";
import GrupoController from "./infra/controller/GrupoController";
import ImpostosFederaisController from "./infra/controller/ImpostosFederaisController";
import { ProdutoRepositoryAPI } from "./infra/repository/ProdutoRepository";
import { SecaoRepositoryAPI } from "./infra/repository/SecaoRepository";
import { GrupoRepositoryAPI } from "./infra/repository/GrupoRepository";
import TributacaoController from "./infra/controller/TributacaoController";
import { TributacaoRepositoryAPI } from "./infra/repository/TributacaoRepository";
import { ImpostosFederaisRepositoryAPI } from "./infra/repository/ImpostosFederaisRepository";
import AssociacaoController from "./infra/controller/AssociacaoController";
import { AssociacaoRepositoryAPI } from "./infra/repository/AssociacaoRepository";

export default Vue.extend({
  name: "App",
  components: {
    Home,
  },
  provide() {
    return {
      notaFiscalEntradaController: new NotaFiscalEntradaController(new NotaFiscalEntradaRepositoryApi()),
      fornecedorController: new FornecedorController(new FornecedorRepositoryApi()),
      produtoController: new ProdutoController(new ProdutoRepositoryAPI()),
      secaoController: new SecaoController(new SecaoRepositoryAPI()),
      grupoController: new GrupoController(new GrupoRepositoryAPI()),
      tributacaoController: new TributacaoController(new TributacaoRepositoryAPI()),
      impostosFederaisController: new ImpostosFederaisController(new ImpostosFederaisRepositoryAPI()),
      associacaoController: new AssociacaoController(new AssociacaoRepositoryAPI()),
    };
  },

  data: () => ({
    //
  }),
});
</script>

<style>
.v-input__slot .v-label {
  color: black !important;
}
</style>
