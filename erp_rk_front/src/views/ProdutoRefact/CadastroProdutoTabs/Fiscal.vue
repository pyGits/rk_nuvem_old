<template>
  
</template>

<script>
import ModalNCM from "@/views/Fiscal/NCM/ModalNCM.vue";
import ModalCEST from "@/views/Fiscal/NCM/ModalCEST.vue";
import ModalTributacao from "@/views/Fiscal/Tributacao/ModalTributacao.vue";
import ModalFederal from "@/views/Fiscal/Federais/ModalFederal.vue";
import { maskCEST, zeroEsquerda } from "@/utils/masks";

export default {
  methods: {
    focusNextInput(event, nextInputRef) {
      this.$refs[nextInputRef].focus();
    },
    showDialogTributacao() {
      this.$store.commit("setDialogTributacao", true);
    },
    showDialogNCM() {
      this.$store.commit("setDialogNCM", true);
    },
    showDialogCEST() {
      this.$store.commit("setDialogCEST", true);
    },
    showDialogFederal() {
      this.$store.commit("setDialogFederal", true);
    },
    async setNCM() {
      await this.$store.dispatch(
        "getNCM",
        this.$store.state.produto.produto.ncm
      );
      this.$store.commit(
        "setProdutoNCM",
        zeroEsquerda(this.$store.state.tributacao.ncm.codigo)
      );

      this.setCEST();
    },
    async setCEST() {
      await this.$store.dispatch(
        "getCEST",
        this.$store.state.produto.produto.cest
      );
      this.$store.commit(
        "setProdutoCEST",
        maskCEST(this.$store.state.tributacao.cest.codigo)
      );
    },
    async setTributacao() {
      await this.$store.dispatch(
        "getTributacao",
        this.$store.state.produto.produto.tributacao
      );
      this.$store.commit(
        "setProdutoTributacao",
        this.$store.state.tributacao.tributacao.codigo
      );
    },
    async setImpFederal() {
      await this.$store.dispatch(
        "getImpFederal",
        this.$store.state.produto.produto.impfederal
      );
      this.$store.commit(
        "setProdutoImpFederal",
        this.$store.state.impfederal.impfederal.codigo
      );
    },
  },
  computed: {
    ncm: {
      get() {
        return this.$store.state.produto.produto.ncm;
      },
      set(valor) {
        this.$store.commit("setProdutoNCM", valor);
      },
    },
    ncm_descricao: {
      get() {
        return this.$store.state.tributacao.ncm.nome;
      },
    },
    cest: {
      get() {
        return this.$store.state.produto.produto.cest;
      },
      set(valor) {
        this.$store.commit("setProdutoCEST", valor);
      },
    },
    cest_descricao: {
      get() {
        return this.$store.state.tributacao.cest.nome;
      },
    },

    impfederal: {
      get() {
        return this.$store.state.produto.produto.impfederal;
      },
      set(valor) {
        this.$store.commit("setProdutoImpFederal", valor);
      },
    },
    impfederal_descricao: {
      get() {
        return this.$store.state.impfederal.impfederal.nome;
      },
    },

    tributacao: {
      get() {
        return this.$store.state.produto.produto.tributacao;
      },
      set(valor) {
        this.$store.commit("setProdutoTributacao", valor);
      },
    },
    tributacao_descricao: {
      get() {
        return this.$store.state.tributacao.tributacao.nome;
      },
    },

    dialogNCM: {
      get() {
        return this.$store.state.Application.dialogNCM;
      },
    },
    dialogCEST: {
      get() {
        return this.$store.state.Application.dialogCEST;
      },
    },
    dialogTributacao: {
      get() {
        return this.$store.state.Application.dialogTributacao;
      },
    },

    errorTributacao: {
      get() {
        return this.$store.state.error.error.produto.tributacao;
      },
    },
    errorTributacaoMessage: {
      get() {
        return this.$store.state.error.error.produto.tributacao_message;
      },
    },
    errorNcm: {
      get() {
        return this.$store.state.error.error.produto.ncm;
      },
    },
    errorNcmMessage: {
      get() {
        return this.$store.state.error.error.produto.ncm_message;
      },
    },
  },

  watch: {
    dialogTributacao(newValue) {
      if (!newValue) {
        this.$store.commit(
          "setProdutoTributacao",
          this.$store.state.tributacao.tributacao.codigo
        );
      }
    },
    dialogCEST(newValue) {
      if (!newValue) {
        this.$store.commit(
          "setProdutoCEST",
          this.$store.state.tributacao.cest.codigo
        );
      }
    },
    dialogNCM(newValue) {
      this.$store.commit(
        "setProdutoNCM",
        this.$store.state.tributacao.ncm.codigo
      );
      this.setCEST();
    },
  },
  components: {
    ModalNCM,
    ModalCEST,
    ModalTributacao,
    ModalFederal,
  },
};
</script>

<style lang="scss" scoped></style>
