<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="primary" class="mr-3">mdi-table-large</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Tabela IBPT</h2>
          <span class="text-caption grey--text text--darken-1"> Catálogo de NCM e alíquotas da Lei da Transparência, usado por todos os clientes </span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" depressed @click="dialogUpload = true">
          <v-icon left>mdi-upload</v-icon>
          Enviar tabela
        </v-btn>
      </div>

      <v-card-text>
        <!-- Situação da carga -->
        <v-alert v-if="!carregando && !situacao?.carga" type="warning" text class="mb-4">
          Nenhuma tabela carregada ainda. Envie o arquivo <strong>.csv</strong> do IBPT para que os clientes consigam consultar NCM.
        </v-alert>

        <v-row v-else-if="situacao?.carga" dense class="mb-2">
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Versão</div>
              <div class="text-h6">{{ situacao.carga.versao || "-" }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Vigência</div>
              <div class="text-h6">{{ formatarData(situacao.carga.vigenciaInicio) }} a {{ formatarData(situacao.carga.vigenciaFim) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">NCM na tabela</div>
              <div class="text-h6">{{ situacao.total }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Carregada em</div>
              <div class="text-h6">{{ formatarDataHora(situacao.carga.carregadoEm) }}</div>
              <div class="text-caption grey--text text-truncate">{{ situacao.carga.arquivo }}</div>
            </v-sheet>
          </v-col>
        </v-row>

        <!-- Vigência vencida: a tabela do IBPT é trimestral. -->
        <v-alert v-if="vigenciaVencida" type="info" text dense class="mb-4"> A vigência desta tabela terminou em {{ formatarData(situacao.carga.vigenciaFim) }}. O IBPT publica uma versão nova a cada trimestre. </v-alert>

        <v-divider class="my-4"></v-divider>

        <!-- Conferência de NCM -->
        <div class="d-flex align-center flex-wrap mb-3">
          <div>
            <h3 class="text-subtitle-1 font-weight-medium mb-0">Produtos com NCM fora da tabela</h3>
            <span class="text-caption grey--text text--darken-1"> NCM em branco, com menos de 8 dígitos, ou que não existe no IBPT carregado </span>
          </div>
          <v-spacer></v-spacer>
          <v-checkbox v-model="incluirInativos" label="Incluir produtos inativos" hide-details dense class="mr-4 mt-0" @change="conferir"></v-checkbox>
          <v-btn color="primary" outlined :loading="conferindo" @click="conferir">
            <v-icon left>mdi-magnify</v-icon>
            Conferir
          </v-btn>
          <v-btn class="ml-2" outlined :disabled="!produtos.length" @click="exportar">
            <v-icon left>mdi-file-excel-outline</v-icon>
            Excel
          </v-btn>
        </div>

        <v-alert v-if="conferencia.message" type="warning" text dense>{{ conferencia.message }}</v-alert>

        <template v-else-if="jaConferiu">
          <v-alert v-if="!produtos.length" type="success" text dense> Nenhum produto com NCM irregular. </v-alert>

          <template v-else>
            <div class="mb-2 text-caption grey--text text--darken-1">{{ conferencia.totais.produtos }} produto(s) em {{ conferencia.totais.clientes }} cliente(s)</div>

            <v-data-table :headers="headersProdutos" :items="produtos" :items-per-page="20" :footer-props="{ 'items-per-page-text': 'Produtos por página' }" class="elevation-1">
              <template #[`item.cliente`]="{ item }">
                <div class="font-weight-medium">{{ item.cliente || `Cliente ${item.tenant_id}` }}</div>
                <div v-if="item.cnpjcpf" class="text-caption grey--text text--darken-1">{{ item.cnpjcpf }}</div>
              </template>
              <template #[`item.ncm`]="{ item }">
                <span v-if="item.ncm">{{ item.ncm }}</span>
                <span v-else class="grey--text">(vazio)</span>
              </template>
              <template #[`item.motivo`]="{ item }">
                <v-chip x-small :color="item.motivo === 'NCM em branco' ? 'error' : 'warning'" dark>{{ item.motivo }}</v-chip>
              </template>
            </v-data-table>
          </template>
        </template>
      </v-card-text>
    </v-card>

    <!-- Upload -->
    <v-dialog v-model="dialogUpload" max-width="600" persistent>
      <v-card>
        <v-card-title>Enviar tabela IBPT</v-card-title>
        <v-card-text>
          <p class="text-body-2 grey--text text--darken-1">Envie o arquivo <strong>.csv</strong> publicado pelo IBPT. A tabela atual é substituída por completo.</p>

          <v-file-input v-model="arquivo" accept=".csv" label="Arquivo do IBPT" prepend-icon="mdi-file-delimited-outline" outlined dense show-size :error-messages="erroArquivo" :disabled="enviando"></v-file-input>

          <v-progress-linear v-if="enviando" :value="progresso" height="20" rounded color="primary" class="mt-2">
            <span class="text-caption">{{ progresso }}%</span>
          </v-progress-linear>
          <div v-if="enviando && progresso >= 100" class="text-caption grey--text mt-1">Processando as 12 mil linhas no servidor...</div>
        </v-card-text>
        <v-card-actions class="px-6 pb-4">
          <v-spacer></v-spacer>
          <v-btn text :disabled="enviando" @click="fecharUpload">Cancelar</v-btn>
          <v-btn color="primary" depressed :loading="enviando" @click="enviar">Enviar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-snackbar v-model="snackbar" :color="snackbarCor" timeout="6000">{{ mensagem }}</v-snackbar>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";
import { gerarExcel } from "@/utils/exports";

export default {
  name: "IbptAdmin",
  components: { MenuAdmin },
  data() {
    return {
      carregando: false,
      conferindo: false,
      jaConferiu: false,
      dialogUpload: false,
      enviando: false,
      progresso: 0,
      arquivo: null,
      erroArquivo: "",
      incluirInativos: false,
      snackbar: false,
      snackbarCor: "success",
      mensagem: "",
      headersProdutos: [
        { text: "Cliente", value: "cliente" },
        { text: "Código", value: "codigo", width: 110 },
        { text: "Cód. barras", value: "codigo_barras", width: 150 },
        { text: "Descrição", value: "descricao" },
        { text: "NCM", value: "ncm", width: 110 },
        { text: "Motivo", value: "motivo", width: 220 },
      ],
    };
  },
  computed: {
    situacao() {
      return this.$store.state.ibpt.ibptSituacao;
    },
    conferencia() {
      return this.$store.state.ibpt.ibptProdutosSemNcm;
    },
    produtos() {
      return this.conferencia.produtos || [];
    },
    // A tabela do IBPT é trimestral; passada a vigência, os percentuais deixam
    // de valer mesmo que a consulta de NCM continue funcionando.
    vigenciaVencida() {
      const fim = this.situacao?.carga?.vigenciaFim;
      if (!fim) return false;
      return String(fim).substring(0, 10) < new Date().toISOString().substring(0, 10);
    },
  },
  async mounted() {
    this.carregando = true;
    try {
      await this.$store.dispatch("getIbptSituacao");
    } finally {
      this.carregando = false;
    }
  },
  methods: {
    formatarData(data) {
      if (!data) return "-";
      const [ano, mes, dia] = String(data).substring(0, 10).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    formatarDataHora(data) {
      if (!data) return "-";
      return new Date(data).toLocaleString("pt-BR");
    },
    avisar(mensagem, cor = "success") {
      this.mensagem = mensagem;
      this.snackbarCor = cor;
      this.snackbar = true;
    },
    fecharUpload() {
      this.dialogUpload = false;
      this.arquivo = null;
      this.erroArquivo = "";
      this.progresso = 0;
    },
    async enviar() {
      this.erroArquivo = "";
      if (!this.arquivo) {
        this.erroArquivo = "Selecione o arquivo .csv do IBPT.";
        return;
      }

      this.enviando = true;
      this.progresso = 0;
      try {
        const resposta = await this.$store.dispatch("publicarIbpt", {
          arquivo: this.arquivo,
          onProgress: (evento) => {
            this.progresso = evento.total ? Math.round((evento.loaded * 100) / evento.total) : 0;
          },
        });
        this.fecharUpload();
        this.avisar(`${resposta.message} ${resposta.registros} NCM carregados (versão ${resposta.versao}).`);
        // A conferência anterior fala da tabela antiga: refaz se já havia uma.
        if (this.jaConferiu) await this.conferir();
      } catch (erro) {
        this.erroArquivo = erro?.response?.data?.message || "Não foi possível processar o arquivo.";
      } finally {
        this.enviando = false;
      }
    },
    async conferir() {
      this.conferindo = true;
      try {
        await this.$store.dispatch("getIbptProdutosSemNcm", {
          incluirInativos: this.incluirInativos ? "1" : "0",
        });
        this.jaConferiu = true;
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível conferir os NCM.", "error");
      } finally {
        this.conferindo = false;
      }
    },
    exportar() {
      const linhas = this.produtos.map((produto) => ({
        cliente: produto.cliente,
        cnpjcpf: produto.cnpjcpf,
        codigo: produto.codigo,
        codigo_barras: produto.codigo_barras,
        descricao: produto.descricao,
        ncm: produto.ncm,
        motivo: produto.motivo,
      }));
      gerarExcel(linhas, "produtos_ncm_irregular.xlsx");
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
</style>
