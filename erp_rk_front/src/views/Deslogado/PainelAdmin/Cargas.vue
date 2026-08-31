<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="primary" class="mr-3">mdi-cloud-upload-outline</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Carga para as Lojas</h2>
          <span class="text-caption grey--text text--darken-1">{{ subtitulo }}</span>
        </div>
        <v-spacer></v-spacer>

        <v-btn class="mr-2" text :loading="carregando" @click="carregar">
          <v-icon left>mdi-refresh</v-icon>
          Atualizar
        </v-btn>
        <v-btn color="primary" depressed class="mr-2" :disabled="!selecionadas.length" @click="enviarSelecionadas('ALTERADOS')">
          <v-icon left>mdi-sync</v-icon>
          Enviar alterados
        </v-btn>
        <v-btn color="primary" outlined class="mr-2" :disabled="!selecionadas.length" @click="enviarSelecionadas('COMPLETA')">
          <v-icon left>mdi-database-arrow-up-outline</v-icon>
          Carga completa
        </v-btn>
        <v-btn color="error" depressed @click="abrirDialogTodas">
          <v-icon left>mdi-earth-arrow-right</v-icon>
          Todas as lojas
        </v-btn>
      </div>

      <v-card-text>
        <v-sheet class="pa-4 mb-4" elevation="1" rounded color="grey lighten-4">
          <v-row dense align="center">
            <v-col cols="12" sm="4">
              <v-subheader class="pl-0">Cliente</v-subheader>
              <v-select v-model="filtro.tenantId" :items="clientes" item-text="nome" item-value="id" outlined dense hide-details clearable></v-select>
            </v-col>
            <v-col cols="12" sm="5">
              <v-subheader class="pl-0">Buscar</v-subheader>
              <v-text-field v-model="filtro.busca" outlined dense hide-details clearable placeholder="cliente, loja ou código"></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-subheader class="pl-0">Clientes</v-subheader>
              <v-switch v-model="filtro.somenteAtivos" dense hide-details class="mt-0" label="Somente ativos"></v-switch>
            </v-col>
          </v-row>
        </v-sheet>

        <div v-if="!carregando && !lojasFiltradas.length" class="text-center py-12 grey--text">
          <v-icon size="56" color="grey lighten-1">mdi-store-off-outline</v-icon>
          <p class="mt-3 mb-0">Nenhuma loja para o filtro atual.</p>
        </div>

        <v-data-table
          v-else
          v-model="selecionadas"
          class="tabela-carga elevation-1"
          :headers="headers"
          :items="lojasFiltradas"
          :loading="carregando"
          item-key="chave"
          show-select
          :items-per-page="25"
          :footer-props="{ 'items-per-page-text': 'Lojas por página' }"
        >
          <template #[`item.cliente`]="{ item }">
            <div class="font-weight-medium">{{ item.cliente }}</div>
            <div class="text-caption grey--text text--darken-1">
              cliente {{ item.tenantId }}
              <v-chip v-if="!item.clienteAtivo" x-small color="grey" dark class="ml-1">inativo</v-chip>
            </div>
          </template>

          <template #[`item.loja`]="{ item }">
            <div class="font-weight-medium">{{ item.codigo }} - {{ item.nome }}</div>
            <div v-if="item.fantasia && item.fantasia !== item.nome" class="text-caption grey--text text--darken-1">
              {{ item.fantasia }}
            </div>
          </template>

          <template #[`item.cargaStatus`]="{ item }">
            <div class="coluna-status py-2">
              <div class="d-flex align-center mb-1">
                <v-icon small :color="estado(item).cor" class="mr-1">{{ estado(item).icone }}</v-icon>
                <span class="text-caption font-weight-medium" :class="`${estado(item).cor}--text`">{{ estado(item).texto }}</span>
                <v-spacer></v-spacer>
                <span v-if="estado(item).mostraPercentual" class="text-caption font-weight-bold" :class="`${estado(item).cor}--text`">{{ estado(item).valor }}%</span>
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
              <div v-if="estado(item).detalhe" class="text-caption grey--text mt-1">{{ estado(item).detalhe }}</div>
            </div>
          </template>
        </v-data-table>

        <div class="d-flex align-center pt-2 text-caption grey--text text--darken-1">
          <v-icon x-small class="mr-1">mdi-autorenew</v-icon>
          Status atualizado automaticamente a cada 2 segundos
          <v-spacer></v-spacer>
          <span v-if="selecionadas.length">
            {{ selecionadas.length }} {{ selecionadas.length === 1 ? "loja selecionada" : "lojas selecionadas" }}
          </span>
        </div>
      </v-card-text>
    </v-card>

    <!-- Carga para o parque inteiro: pede confirmação porque atinge todos os
         clientes de uma vez, não só o que está filtrado na tela. -->
    <v-dialog v-model="dialogTodas" max-width="520" persistent>
      <v-card>
        <v-card-title class="text-h6">Enviar carga para todas as lojas</v-card-title>
        <v-card-text>
          <p class="mb-2">
            A carga vai para <strong>todas as {{ totalLojasAtivas }} loja(s)</strong> dos
            <strong>{{ totalClientesAtivos }} cliente(s) ativo(s)</strong>, ignorando o filtro e a seleção da tela.
          </p>
          <p class="text-caption grey--text text--darken-1">
            Cliente inativo fica de fora: sem sync rodando a carga só ficaria na fila até expirar.
          </p>

          <v-radio-group v-model="tipoTodas" class="mt-2" hide-details>
            <v-radio value="ALTERADOS" label="Somente alterados (mais rápido)"></v-radio>
            <v-radio value="COMPLETA" label="Carga completa (reenvia todo o cadastro)"></v-radio>
          </v-radio-group>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text :disabled="enviando" @click="dialogTodas = false">Cancelar</v-btn>
          <v-btn color="error" depressed :loading="enviando" @click="enviarTodas">Enviar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-snackbar v-model="snackbar" :color="snackbarCor" timeout="6000">{{ mensagem }}</v-snackbar>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";
import { estadoDaCarga } from "@/utils/carga";

export default {
  name: "CargasAdmin",
  components: { MenuAdmin },
  data() {
    return {
      carregando: false,
      enviando: false,
      encerrado: false,
      timerStatus: null,
      dialogTodas: false,
      tipoTodas: "ALTERADOS",
      selecionadas: [],
      filtro: { tenantId: null, busca: "", somenteAtivos: true },
      headers: [
        { text: "Cliente", value: "cliente" },
        { text: "Loja", value: "loja", sortable: false },
        { text: "Status da carga", value: "cargaStatus", width: 260, sortable: false },
      ],
      snackbar: false,
      snackbarCor: "success",
      mensagem: "",
    };
  },
  computed: {
    lojas() {
      return this.$store.state.cargaAdmin.cargaAdminLojas;
    },
    lojasFiltradas() {
      const busca = this.filtro.busca ? this.filtro.busca.toLowerCase() : "";

      return this.lojas.filter((loja) => {
        if (this.filtro.somenteAtivos && !loja.clienteAtivo) return false;
        if (this.filtro.tenantId && loja.tenantId !== this.filtro.tenantId) return false;
        if (!busca) return true;

        return [loja.cliente, loja.nome, loja.fantasia, loja.codigo]
          .filter((campo) => campo)
          .some((campo) => String(campo).toLowerCase().includes(busca));
      });
    },
    clientes() {
      const vistos = new Map();
      this.lojas.forEach((loja) => {
        if (this.filtro.somenteAtivos && !loja.clienteAtivo) return;
        vistos.set(loja.tenantId, { id: loja.tenantId, nome: `${loja.tenantId} - ${loja.cliente}` });
      });
      return Array.from(vistos.values());
    },
    lojasAtivas() {
      return this.lojas.filter((loja) => loja.clienteAtivo);
    },
    totalLojasAtivas() {
      return this.lojasAtivas.length;
    },
    totalClientesAtivos() {
      return new Set(this.lojasAtivas.map((loja) => loja.tenantId)).size;
    },
    subtitulo() {
      const aguardando = this.lojas.filter((l) => l.cargaStatus === "PENDENTE").length;
      const emAndamento = this.lojas.filter((l) => l.cargaStatus === "EM_ANDAMENTO").length;

      const partes = [`${this.lojas.length} loja(s) de ${this.totalClientesAtivos} cliente(s) ativo(s)`];
      if (aguardando) partes.push(`${aguardando} aguardando o sync`);
      if (emAndamento) partes.push(`${emAndamento} recebendo carga`);
      if (!aguardando && !emAndamento) partes.push("nenhuma carga em andamento");

      return partes.join(" · ");
    },
  },
  async mounted() {
    await this.carregar();
    this.agendaStatus();
  },
  beforeDestroy() {
    this.encerrado = true;
    clearTimeout(this.timerStatus);
  },
  methods: {
    estado(item) {
      return estadoDaCarga(item);
    },
    async carregar() {
      this.carregando = true;
      try {
        await this.$store.dispatch("getCargaAdminLojas");
        await this.atualizaStatus();
      } catch (err) {
        this.avisar("Não foi possível carregar as lojas.", "error");
      } finally {
        this.carregando = false;
      }
    },
    async atualizaStatus() {
      try {
        await this.$store.dispatch("getCargaAdminStatus");
      } catch (err) {
        // Uma falha pontual na consulta nao pode derrubar o polling.
      }
    },
    agendaStatus() {
      if (this.encerrado) return;

      this.timerStatus = setTimeout(async () => {
        await this.atualizaStatus();
        this.agendaStatus();
      }, 2000);
    },
    abrirDialogTodas() {
      this.tipoTodas = "ALTERADOS";
      this.dialogTodas = true;
    },
    async enviarSelecionadas(carga) {
      await this.enviar({
        carga,
        lojas: this.selecionadas.map((loja) => ({ tenantId: loja.tenantId, codigo: loja.codigo })),
      });
    },
    async enviarTodas() {
      await this.enviar({ carga: this.tipoTodas, todas: true });
      this.dialogTodas = false;
    },
    async enviar(payload) {
      this.enviando = true;
      try {
        const res = await this.$store.dispatch("enviaCargaAdmin", payload);
        const tipo = payload.carga === "COMPLETA" ? "Carga completa" : "Carga de alterados";
        this.avisar(`${tipo} solicitada para ${res.lojas} loja(s) de ${res.clientes} cliente(s).`);
      } catch (err) {
        this.avisar(err?.response?.data?.message || "Não foi possível solicitar a carga.", "error");
      } finally {
        this.enviando = false;
      }
      await this.atualizaStatus();
    },
    avisar(mensagem, cor = "success") {
      this.mensagem = mensagem;
      this.snackbarCor = cor;
      this.snackbar = true;
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

.coluna-status {
  min-width: 190px;
}
</style>
