<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="error" class="mr-3">mdi-alert-circle-outline</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Erros nos PDVs</h2>
          <span class="text-caption grey--text text--darken-1"> O que falhou no caixa dos clientes, enviado pelo Sync_NUVEM </span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" depressed :loading="carregando" @click="carregar">
          <v-icon left>mdi-refresh</v-icon>
          Atualizar
        </v-btn>
      </div>

      <v-card-text>
        <v-sheet class="pa-4 mb-4" elevation="1" rounded color="grey lighten-4">
          <v-row dense align="center">
            <v-col cols="12" sm="3">
              <v-subheader class="pl-0">De</v-subheader>
              <v-text-field v-model="filtro.dataDe" type="date" outlined dense hide-details></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-subheader class="pl-0">Até</v-subheader>
              <v-text-field v-model="filtro.dataAte" type="date" outlined dense hide-details></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-subheader class="pl-0">Inquilino</v-subheader>
              <v-select v-model="filtro.tenant_id" :items="inquilinos" item-text="nome" item-value="id" outlined dense hide-details clearable></v-select>
            </v-col>
            <v-col cols="12" sm="3">
              <v-subheader class="pl-0">Texto do erro</v-subheader>
              <v-text-field v-model="filtro.busca" outlined dense hide-details clearable placeholder="ex.: impressora"></v-text-field>
            </v-col>
          </v-row>

          <div class="d-flex justify-end mt-4">
            <v-btn color="primary" :loading="carregando" @click="carregar">
              <v-icon left>mdi-magnify</v-icon>
              Pesquisar
            </v-btn>
          </div>
        </v-sheet>

        <div v-if="!carregando && !erros.length" class="text-center py-12 grey--text">
          <v-icon size="56" color="grey lighten-1">mdi-check-circle-outline</v-icon>
          <p class="mt-3 mb-0">Nenhum erro no período.</p>
        </div>

        <v-data-table v-else :headers="headers" :items="erros" :loading="carregando" :items-per-page="25" :footer-props="{ 'items-per-page-text': 'Erros por página' }" class="elevation-1">
          <template #[`item.quando`]="{ item }">
            <div>{{ formatarData(item.data) }}</div>
            <div class="text-caption grey--text text--darken-1">{{ item.hora }}</div>
          </template>

          <template #[`item.cliente`]="{ item }">
            <div class="font-weight-medium">{{ item.cliente }}</div>
            <div class="text-caption grey--text text--darken-1">loja {{ item.loja }} · caixa {{ item.caixa }}</div>
          </template>

          <template #[`item.origem`]="{ item }">
            <v-chip v-if="item.origem" x-small :color="item.origem.indexOf('EXCECAO') === 0 ? 'error' : 'grey'" dark>{{ item.origem }}</v-chip>
            <span v-else class="grey--text">-</span>
          </template>

          <template #[`item.erro`]="{ item }">
            <div class="erro-texto">{{ item.erro }}</div>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";
import { maskDateBR } from "@/utils/masks";

function haUmaSemana() {
  const data = new Date();
  data.setDate(data.getDate() - 7);
  return data.toISOString().substring(0, 10);
}

export default {
  name: "ErrosPdvAdmin",
  components: { MenuAdmin },
  data() {
    return {
      carregando: false,
      // Uma semana por padrão: erro antigo raramente é o que se está caçando, e
      // sem recorte a lista vem cheia de ruído de meses atrás.
      filtro: { dataDe: haUmaSemana(), dataAte: new Date().toISOString().substring(0, 10), tenant_id: null, busca: "" },
      headers: [
        { text: "Quando", value: "quando", width: 120, sortable: false },
        { text: "Cliente", value: "cliente", sortable: false },
        { text: "Origem", value: "origem", width: 200 },
        { text: "Erro", value: "erro", sortable: false },
      ],
    };
  },
  computed: {
    erros() {
      return this.$store.state.erroPdv.erroPdvList;
    },
    inquilinos() {
      return (this.$store.state.admin.tenantList.tenantList || []).map((tenant) => ({
        id: tenant.id,
        nome: `${tenant.id} - ${tenant.name || tenant.user}`,
      }));
    },
  },
  async mounted() {
    await this.$store.dispatch("getAdminTenantList");
    await this.carregar();
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    async carregar() {
      this.carregando = true;
      try {
        await this.$store.dispatch("getErrosPdv", {
          ...(this.filtro.dataDe ? { dataDe: this.filtro.dataDe } : {}),
          ...(this.filtro.dataAte ? { dataAte: this.filtro.dataAte } : {}),
          ...(this.filtro.tenant_id ? { tenant_id: this.filtro.tenant_id } : {}),
          ...(this.filtro.busca ? { busca: this.filtro.busca } : {}),
        });
      } finally {
        this.carregando = false;
      }
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
/* Mensagem de erro pode ser longa (stack, retorno da SEFAZ); quebra em vez de
   esticar a tabela. */
.erro-texto {
  white-space: pre-wrap;
  word-break: break-word;
  max-height: 6em;
  overflow-y: auto;
}
</style>
