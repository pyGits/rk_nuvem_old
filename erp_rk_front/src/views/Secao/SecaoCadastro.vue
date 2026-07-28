<template>
  <v-card>
    <v-card-title>Mercadológico</v-card-title>
    <v-container>
      <v-row>
        <!-- SEÇÃO -->
        <v-col cols="12" sm="4">
          <v-card class="my-3">
            <v-card-title
              >Seção
              <v-btn class="d-flex flex-row-reverse container" @click="newSecao" icon>
                <v-icon>mdi-plus</v-icon>
              </v-btn>
            </v-card-title>

            <v-card-text>
              <v-card class="sub-card my-3" v-for="(secao, index) in secoes" :key="index" @click="selecionarSecao(secao)">
                <v-card-title>{{ secao.codigo }} - {{ secao.nome }}</v-card-title>
                <div class="card-actions">
                  <v-btn color="primary" icon @click="editSecao(secao)">
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                  <v-btn color="error" icon @click="deleteSecaoMessage(secao)">
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </div>
              </v-card>
            </v-card-text>
          </v-card>
        </v-col>
        <!-- GRUPO -->
        <v-col cols="12" sm="4">
          <v-card class="my-4">
            <v-card-title
              >Grupo
              <v-btn v-if="this.$store.state.secao.secao.codigo != 0" class="d-flex flex-row-reverse container" @click="newGrupo" icon>
                <v-icon>mdi-plus</v-icon>
              </v-btn>
            </v-card-title>

            <v-card-text>
              <v-card class="sub-card my-3" v-for="(grupo, index) in grupos" :key="index">
                <v-card-title>{{ grupo.codigo }} - {{ grupo.nome }}</v-card-title>
                <div class="card-actions">
                  <v-btn color="primary" icon @click="editGrupo(grupo)">
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                  <v-btn color="error" icon>
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </div>
              </v-card>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>

      <SecaoModal :dialog="dialogSecao" @updateDialog="updateDialogSecao"></SecaoModal>

      <GrupoModal :dialog="dialogGrupo" @updateDialog="updateDialogGrupo"></GrupoModal>
      <ModalYesNo></ModalYesNo>
    </v-container>
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
    };
  },
  components: {
    SecaoModal,
    GrupoModal,
    ModalYesNo,
  },
  computed: {
    secoes: {
      get() {
        return this.$store.state.secao.secaoList;
      },
    },
    grupos: {
      get() {
        return this.$store.state.grupo.grupoList;
      },
    },
  },
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    this.$store.dispatch("resetState");
    await this.$store.dispatch("getSecoes");
    this.$store.commit("setContainerLoading", false);
  },
  methods: {
    updateDialogSecao(value) {
      this.dialogSecao = value;
    },
    updateDialogGrupo(value) {
      this.dialogGrupo = value;
    },
    async selecionarSecao(secao) {
      this.$store.commit("setContainerLoading", true);
      this.$store.commit("setHeaderText", "Seção: " + secao.codigo + " - " + secao.nome);
      this.$store.commit("setSecao", secao);
      this.$store.commit("setGrupoSecao", secao.codigo);
      await this.$store.dispatch("getGrupos", secao.codigo);
      this.$store.commit("setContainerLoading", false);
    },

    async editSecao(secao) {
      this.dialogSecao = true;
      this.$store.commit("resetSecao");
      this.$store.commit("setSecaoCodigo", secao.codigo);
      this.$store.commit("setModeEdit");
      await this.$store.dispatch("getSecao", secao.codigo);
    },
    async newSecao() {
      this.dialogSecao = true;
      this.$store.commit("resetSecao");
      this.$store.commit("setSecaoCodigo", "novo");
      this.$store.commit("setModeInsert");
      await this.$store.dispatch("getSecao", "novo");
    },
    async deleteSecao() {
      this.$store.commit("setContainerLoading", true);
      await this.$store.dispatch("deletarSecao");
      await this.$store.dispatch("getSecoes");
      this.$store.commit("resetSecaoList");
      await this.$store.dispatch("getSecoes");
      this.$store.commit("setContainerLoading", false);
    },
    deleteSecaoMessage(secao) {
      const message = {
        message: "Deseja deletar mesmo a seção ? -" + secao.codigo + " - " + secao.nome,
        title: "Deletar seção",
      };
      this.$store.commit("setDialogYesNoConfirmAction", () => {
        this.deleteSecao();
      });
      this.$store.dispatch("showDialogYesOrNo", message);
    },
    async newGrupo() {
      this.dialogGrupo = true;
      this.$store.commit("resetGrupo");
      this.$store.commit("setGrupoSecao", this.$store.state.secao.secao.codigo);
      this.$store.commit("setModeInsert");
      await this.$store.dispatch("getGrupo", "novo");
    },

    async editGrupo(grupo) {
      this.dialogGrupo = true;
      this.$store.commit("resetGrupo");
      this.$store.commit("setGrupoSecao", this.$store.state.secao.secao.codigo);
      this.$store.commit("setModeEdit");
      await this.$store.dispatch("getGrupo", grupo.codigo);
    },
  },
};
</script>

<style scoped>
.my-3 {
  cursor: pointer;
}
.sub-card {
  padding: 16px;
}
.card-content {
  display: flex;
  justify-content: space-between;
}
.card-actions {
  display: flex;
  gap: 8px;
}
</style>
