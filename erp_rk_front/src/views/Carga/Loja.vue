<template>
  <v-container>
    <v-card>
      <v-card-title>Carga - Loja</v-card-title>
      <v-data-table
        v-model="selected"
        id="tableCarga"
        :headers="headers"
        :items="lojas"
        item-key="codigo"
        show-select
        :footer-props="{
          'items-per-page-text': 'Lojas.',
        }"
        @click:row="selectRow"
      >
        <template slot="item.status" slot-scope="{ item }">
          {{ item.status }} %
          <v-progress-linear :value="item.status"></v-progress-linear>
        </template>
      </v-data-table>
      <div class="d-flex flex-row-reverse container">
        <v-btn color="primary" @click="enviaCargaAlterados" class="mr-2"
          >Enviar Carga Alterados</v-btn
        >
        <v-btn color="primary" @click="enviaCargaCompleta" class="mr-2"
          >Enviar Carga Completa</v-btn
        >
      </div>
    </v-card>
  </v-container>
</template>

<script>
export default {
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getLojas");
    this.$store.commit("setContainerLoading", false);
    this.verificaCargaStatus();
  },
  methods: {
    async verificaCargaStatus() {
      if (this.$route.path == "/carga/loja") {
        setTimeout(async () => {
          await this.$store.dispatch("verificaCargaStatus");
          await this.verificaCargaStatus();
        }, 2000);
      }
    },
    selectRow(item) {
      const index = this.selected.findIndex(
        (selectedItem) => selectedItem.codigo === item.codigo
      );
      if (index === -1) {
        // Item não encontrado na lista, pode adicioná-lo
        this.selected.push(item);
      } else {
        // Item já está na lista, não precisa adicionar novamente
        this.selected.splice(index, 1); // remove o item da lista
      }
    },

    enviaCargaCompleta() {
      this.$store.commit("setContainerLoading", true);
      this.$store.dispatch("enviaCargaCompleta", this.selected);
      this.$store.commit("setContainerLoading", false);
    },

    enviaCargaAlterados() {
      this.$store.commit("setContainerLoading", true);
      this.$store.dispatch("enviaCargaAlterados", this.selected);
      this.$store.commit("setContainerLoading", false);
    },
  },
  data() {
    return {
      selected: [],
      headers: [
        { text: "Cód.", value: "codigo" },
        { text: "Loja", value: "nome" },
        { text: "Status", value: "status" },
      ],
    };
  },
  computed: {
    lojas: {
      get() {
        return this.$store.state.loja.lojaList;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tableCarga {
  cursor: pointer;
}
</style>
