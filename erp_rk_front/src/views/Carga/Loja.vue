<template>
  <v-card flat>
    <CabecalhoRelatorio
      titulo="Carga para as Lojas"
      :subtitulo="subtitulo"
      icone="mdi-cloud-upload-outline"
      :mostrar-atualizar="false"
      :mostrar-exportar="false"
    >
      <template #acoes>
        <v-btn
          color="primary"
          depressed
          class="mr-2"
          :disabled="!selected.length"
          @click="enviaCargaAlterados"
        >
          <v-icon left>mdi-sync</v-icon>
          Enviar alterados
        </v-btn>
        <v-btn
          color="primary"
          outlined
          :disabled="!selected.length"
          @click="enviaCargaCompleta"
        >
          <v-icon left>mdi-database-arrow-up-outline</v-icon>
          Carga completa
        </v-btn>
      </template>
    </CabecalhoRelatorio>

    <!-- Com a carga automática ligada, a carga entra na fila sozinha depois de
         uma alteração. Sem este aviso, ver "Aguardando sync" sem ninguém ter
         clicado em nada parece defeito. -->
    <v-alert
      v-if="cargaAutomaticaLigada"
      type="info"
      text
      dense
      class="mx-4 mt-2 mb-0"
    >
      Carga automática ligada: alterações nos cadastros são enviadas sozinhas{{
        textoJanelaAutomatica
      }}. Os botões acima continuam valendo para enviar o que quiser, na hora.
    </v-alert>

    <EstadoVazio
      v-if="!lojas.length"
      icone="mdi-store-off-outline"
      mensagem="Nenhuma loja cadastrada para enviar carga."
    />

    <template v-else>
      <v-data-table
        v-model="selected"
        class="tabela-carga"
        :headers="headers"
        :items="lojas"
        item-key="codigo"
        show-select
        :item-class="classeLinha"
        :footer-props="{ 'items-per-page-text': 'Lojas por página' }"
        @click:row="selectRow"
      >
        <template #[`item.nome`]="{ item }">
          <div class="font-weight-medium">{{ item.nome }}</div>
          <div
            v-if="item.fantasia && item.fantasia !== item.nome"
            class="text-caption grey--text text--darken-1"
          >
            {{ item.fantasia }}
          </div>
        </template>

        <template #[`item.cargaStatus`]="{ item }">
          <div class="coluna-status py-2">
            <div class="d-flex align-center mb-1">
              <v-icon small :color="estado(item).cor" class="mr-1">
                {{ estado(item).icone }}
              </v-icon>
              <span
                class="text-caption font-weight-medium"
                :class="`${estado(item).cor}--text`"
              >
                {{ estado(item).texto }}
              </span>
              <v-spacer></v-spacer>
              <span
                v-if="estado(item).mostraPercentual"
                class="text-caption font-weight-bold"
                :class="`${estado(item).cor}--text`"
              >
                {{ estado(item).valor }}%
              </span>
            </div>
            <v-progress-linear
              rounded
              height="6"
              :value="estado(item).valor"
              :color="estado(item).cor"
              :indeterminate="estado(item).indeterminado"
              :stream="estado(item).aguardando"
              :buffer-value="0"
            ></v-progress-linear>
            <div v-if="estado(item).detalhe" class="text-caption grey--text mt-1">
              {{ estado(item).detalhe }}
            </div>
          </div>
        </template>
      </v-data-table>

      <v-divider></v-divider>
      <div class="d-flex align-center px-6 py-2 text-caption grey--text text--darken-1">
        <v-icon x-small class="mr-1">mdi-autorenew</v-icon>
        Status atualizado automaticamente a cada 2 segundos
        <v-spacer></v-spacer>
        <span v-if="selected.length">
          {{ selected.length }}
          {{ selected.length === 1 ? "loja selecionada" : "lojas selecionadas" }}
        </span>
      </div>
    </template>
  </v-card>
</template>

<script>
import CabecalhoRelatorio from "@/components/Relatorio/CabecalhoRelatorio.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
// Mesma leitura de estado usada pelo painel administrativo.
import { estadoDaCarga } from "@/utils/carga";

export default {
  components: { CabecalhoRelatorio, EstadoVazio },
  async mounted() {
    this.$store.commit("setContainerLoading", true);
    await this.$store.dispatch("getLojas");
    this.$store.commit("setContainerLoading", false);
    // Falha aqui não pode impedir a tela de carga de abrir: o aviso some, o
    // resto continua.
    try {
      await this.$store.dispatch("getConfiguracao");
    } catch (err) {
      // Sem configuração, a tela se comporta como antes desta feature.
    }
    await this.atualizaCargaStatus();
    this.verificaCargaStatus();
  },
  beforeDestroy() {
    this.encerrado = true;
    clearTimeout(this.timerCarga);
  },
  methods: {
    async atualizaCargaStatus() {
      try {
        await this.$store.dispatch("verificaCargaStatus");
      } catch (err) {
        // Uma falha pontual na consulta nao pode derrubar o polling.
      }
    },
    verificaCargaStatus() {
      if (this.encerrado) return;

      this.timerCarga = setTimeout(async () => {
        await this.atualizaCargaStatus();
        this.verificaCargaStatus();
      }, 2000);
    },
    estado(item) {
      return estadoDaCarga(item);
    },
    classeLinha(item) {
      return this.selected.some((s) => s.codigo === item.codigo)
        ? "linha-selecionada"
        : "";
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

    async enviaCargaCompleta() {
      await this.enviaCarga("enviaCargaCompleta", "Carga completa solicitada!");
    },

    async enviaCargaAlterados() {
      await this.enviaCarga("enviaCargaAlterados", "Carga de alterados solicitada!");
    },

    async enviaCarga(acao, mensagem) {
      this.$store.commit("setContainerLoading", true);
      try {
        await this.$store.dispatch(acao, this.selected);
        this.$store.dispatch("showToastMessage", mensagem);
      } catch (err) {
        this.$store.dispatch("showToastMessage", "Não foi possível solicitar a carga.");
      } finally {
        this.$store.commit("setContainerLoading", false);
      }
      await this.atualizaCargaStatus();
    },
  },
  data() {
    return {
      selected: [],
      encerrado: false,
      timerCarga: null,
      headers: [
        { text: "Cód.", value: "codigo", width: 90 },
        { text: "Loja", value: "nome" },
        { text: "Status da carga", value: "cargaStatus", width: 240, sortable: false },
      ],
    };
  },
  computed: {
    lojas() {
      return this.$store.state.loja.lojaList;
    },
    cargaAutomaticaLigada() {
      return this.$store.state.configuracao.configuracao.carga_automatica;
    },
    // Completa a frase do aviso. No modo imediato não há espera para explicar,
    // e dizer "0 segundos depois da última gravação" seria pior que não dizer.
    textoJanelaAutomatica() {
      const segundos = this.$store.state.configuracao.configuracao
        .carga_automatica_segundos;

      if (!segundos) return " assim que o cadastro é gravado";

      const minutos = Math.round(segundos / 60);
      const espera =
        segundos < 60
          ? `${segundos} segundos`
          : minutos === 1
          ? "1 minuto"
          : `${minutos} minutos`;

      return `, ${espera} depois da última gravação`;
    },
    subtitulo() {
      const emAndamento = this.lojas.filter(
        (l) => l.cargaStatus === "EM_ANDAMENTO"
      ).length;
      const aguardando = this.lojas.filter((l) => l.cargaStatus === "PENDENTE").length;

      const partes = [`${this.lojas.length} loja(s)`];
      if (aguardando) partes.push(`${aguardando} aguardando o sync`);
      if (emAndamento) partes.push(`${emAndamento} recebendo carga`);
      if (!aguardando && !emAndamento) partes.push("nenhuma carga em andamento");

      return partes.join(" · ");
    },
  },
};
</script>

<style lang="scss" scoped>
.tabela-carga ::v-deep tbody tr {
  cursor: pointer;
}

.tabela-carga ::v-deep tr.linha-selecionada {
  background-color: rgba(25, 118, 210, 0.06);
}

.coluna-status {
  min-width: 170px;
}
</style>
