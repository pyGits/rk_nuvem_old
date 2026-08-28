<template>
  <v-container>
    <v-row class="align-items-center">
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Tributação:</label>
        <input
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          @keyup.enter="focusNextInput($event, 'ncm')"
          placeholder="Nome da Tributação"
          v-model="tributacao"
          @blur="setTributacao"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example"
          >Descrição Tributação:</label
        >
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição da Tributação"
            v-model="tributacao_descricao"
            readonly
          />
          <v-btn icon color="primary" @click="showDialogTributacao">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
      <div v-if="errorTributacao" class="form-text text-danger">
        {{ errorTributacaoMessage }}
      </div>
    </v-row>
    <v-row class="align-items-center">
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">NCM:</label>
        <input
          ref="ncm"
          @keyup.enter="focusNextInput($event, 'cest')"
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          placeholder="Código do NCM"
          maxlength="8"
          inputmode="numeric"
          v-model="ncm"
          @blur="setNCM"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example">Descrição NCM:</label>
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição do NCM"
            v-model="ncm_descricao"
            readonly
          />
          <v-btn icon color="primary" @click="showDialogNCM">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
      <div v-if="errorNcm" class="form-text text-danger">
        {{ errorNcmMessage }}
      </div>
    </v-row>
    <v-row class="align-items-center">
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">CEST:</label>
        <input
          @focus="$event.target.select()"
          type="text"
          ref="cest"
          @keyup.enter="focusNextInput($event, 'piscofins')"
          class="form-control"
          placeholder="Código do CEST"
          v-model="cest"
          @blur="setCEST"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example">Descrição CEST:</label>
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição do CEST"
            v-model="cest_descricao"
            readonly
          />
          <v-btn icon color="primary" @click="showDialogCEST">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
    </v-row>
    <v-row class="align-items-center">
      <v-col cols="12" sm="2">
        <label class="form-label" for="input-example">Pis/Cofins:</label>
        <input
          ref="piscofins"
          @focus="$event.target.select()"
          type="text"
          class="form-control"
          placeholder="Código do Pis/Cofins"
          v-model="impfederal"
          @blur="setImpFederal"
        />
      </v-col>
      <v-col cols="12" sm="8">
        <label class="form-label" for="input-example"
          >Descrição Pis/Cofins:</label
        >
        <div class="input-group">
          <input
            type="text"
            class="form-control"
            placeholder="Descrição do pis/cofins"
            v-model="impfederal_descricao"
            readonly
          />
          <v-btn icon color="primary" @click="showDialogFederal">
            <v-icon>mdi-magnify</v-icon>
          </v-btn>
        </div>
      </v-col>
    </v-row>
    <ModalNCM></ModalNCM>
    <ModalCEST></ModalCEST>
    <ModalTributacao></ModalTributacao>
    <ModalFederal></ModalFederal>
  </v-container>
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
        // NCM tem 8 dígitos e nada além de número. Cortar aqui evita que um
        // colado de outro lugar (com ponto, ou o de 9 dígitos que é NBS)
        // chegue à gravação e volte como erro do banco.
        this.$store.commit("setProdutoNCM", String(valor || "").replace(/\D/g, "").substring(0, 8));
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
