<template>
  <v-card>
    <v-card-title>Cadastro Mercadológico</v-card-title>
    <v-row>
      <v-col cols="6">
        <v-card-title>Seção</v-card-title>
        <v-data-table
          id="tableSecao"
          :headers="secaoHeaders"
          :items="secoesList"
          :loading="isLoading"
          item-key="id"
          @click:row="selecionarSecao"
        >
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon @click.stop="editSecao(item)">mdi-pencil</v-icon>
            <v-icon @click.stop="deleteSecaoMessage(item)">mdi-delete</v-icon>
          </template>
        </v-data-table>
        <v-btn @click="addNovaSecao">Incluir Nova Seção</v-btn>
      </v-col>
      <v-col cols="6">
        <v-card-title
          >Grupo {{ this.$store.state.secao.secao.codigo }} -
          {{ this.$store.state.secao.secao.nome }}</v-card-title
        >
        <v-data-table
          :headers="grupoHeaders"
          :items="gruposListPaginated"
          :options="grupoPagination"
          :loading="isLoading"
          item-key="id"
        >
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon @click.stop="editGrupo(item)">mdi-pencil</v-icon>
            <v-icon @click.stop="deleteGrupoMessage(item)">mdi-delete</v-icon>
          </template>
        </v-data-table>
        <v-btn @click="addNovoGrupo">Incluir Novo Grupo</v-btn>
      </v-col>
    </v-row>
    <SecaoModal
      :dialog="dialogSecao"
      @updateDialog="updateDialogSecao"
    ></SecaoModal>
    <GrupoModal
      :dialog="dialogGrupo"
      @updateDialog="updateDialogGrupo"
    ></GrupoModal>
    <ModalYesNo></ModalYesNo>
  </v-card>
</template>

<script>
import SecaoModal from "./Modals/SecaoModal.vue";
import GrupoModal from "./Modals/GrupoModal.vue";
import ModalYesNo from "@/components/ModalYesOrNo/ModalYesNo.vue";
export default {
  data() {
    return {
      dialogSecao: false,
      dialogGrupo: false,
      grupoPagination: {
        sortBy: [],
        descending: false,
        page: 0,
        rowsPerPage: 10,
      },
      secaoHeaders: [
        { text: "Código", value: "codigo" },
        { text: "Nome", value: "nome" },
        { text: "Ações", value: "actions", sortable: false },
      ],
      grupoHeaders: [
        { text: "Código", value: "codigo" },
        { text: "Nome", value: "nome" },
        { text: "Ações", value: "actions", sortable: false },
      ],
    };
  },
  async mounted() {
    this.$store.dispatch("resetState");
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getSecoes");
    this.$store.commit("setContainerLoading", false);
  },
  computed: {
    secoesList: {
      get() {
        return this.$store.state.secao.secaoList;
      },
    },
    gruposList: {
      get() {
        return this.$store.state.grupo.grupoList;
      },
    },
    gruposListPaginated() {
      const { page, rowsPerPage } = this.grupoPagination;
      const startIndex = page * rowsPerPage;
      const endIndex = startIndex + rowsPerPage;
      return this.gruposList.slice(startIndex, endIndex);
    },
    isLoading() {
      return this.$store.state.containerLoading;
    },
  },
  components: {
    SecaoModal,
    GrupoModal,
    ModalYesNo,
  },
  methods: {
    updateDialogSecao(value) {
      this.dialogSecao = value;
    },
    updateDialogGrupo(value) {
      this.dialogGrupo = value;
    },

    deleteSecaoMessage(secao) {
      const message = {
        message:
          "Deseja deletar mesmo a seção ? -" +
          secao.codigo +
          " - " +
          secao.nome,
        title: "Deletar seção",
      };
      this.$store.commit("setDialogYesNoConfirmAction", () => {
        this.deleteSecao(secao);
      });
      this.$store.dispatch("showDialogYesOrNo", message);
    },
    deleteGrupoMessage(grupo) {
      const message = {
        message:
          "Deseja deletar mesmo o grupo ? -" +
          grupo.codigo +
          " - " +
          grupo.nome,
        title: "Deletar Grupo",
      };
      this.$store.commit("setDialogYesNoConfirmAction", () => {
        this.deleteGrupo(grupo);
      });
      this.$store.dispatch("showDialogYesOrNo", message);
    },
    async selecionarSecao(secao) {
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("setSecao", secao);
      this.$store.commit("setGrupoSecao", secao.codigo);
      await this.$store.dispatch("getGrupos", secao.codigo);
      this.$store.commit("setContainerLoading", false);
    },
    async editSecao(secao) {
      this.dialogSecao = true;
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("resetSecao");
      this.$store.commit("setSecaoCodigo", secao.codigo);
      this.$store.commit("setModeEdit");
      await this.$store.dispatch("getSecao", secao.codigo);
      this.$store.commit("setContainerLoading", false);
    },
    async deleteSecao(secao) {
      this.$store.commit("setContainerLoading", true);
      await this.$store.dispatch("deletarSecao", secao);
      await this.$store.dispatch("getSecoes");
      this.$store.commit("resetSecaoList");
      await this.$store.dispatch("getSecoes");
      this.$store.commit("setContainerLoading", false);
    },
    async addNovaSecao() {
      this.dialogSecao = true;
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("resetSecao");
      this.$store.commit("setSecaoCodigo", "novo");
      this.$store.commit("setModeInsert");
      await this.$store.dispatch("getSecao", "novo");
      this.$store.commit("setContainerLoading", false);
    },
    async addNovoGrupo() {
      this.dialogGrupo = true;
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("resetGrupo");
      this.$store.commit("setGrupoSecao", this.$store.state.secao.secao.codigo);
      this.$store.commit("setModeInsert");
      await this.$store.dispatch("getGrupo", "novo");
      this.$store.commit("setContainerLoading", false);
    },
    async editGrupo(grupo) {
      this.dialogGrupo = true;
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("resetGrupo");
      this.$store.commit("setGrupoSecao", this.$store.state.secao.secao.codigo);
      this.$store.commit("setModeEdit");
      await this.$store.dispatch("getGrupo", grupo.codigo);
      this.$store.commit("setContainerLoading", false);
    },
    async deleteGrupo(grupo) {
      this.$store.commit("setContainerLoading", true);
      await this.$store.dispatch("deletarGrupo", grupo);
      this.$store.commit("resetGrupoList");
      await this.$store.dispatch("getGrupos", grupo.secao);
      this.$store.commit("setContainerLoading", false);
    },
  },
};
</script>
<style scoped>
#tableSecao {
  cursor: pointer;
}
</style>
