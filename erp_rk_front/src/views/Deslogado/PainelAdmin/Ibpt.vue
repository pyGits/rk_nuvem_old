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

        <!-- Correção do zero à esquerda: determinística, separada da sugestão -->
        <v-sheet outlined rounded class="pa-4 mb-4">
          <div class="d-flex align-center flex-wrap">
            <div>
              <h3 class="text-subtitle-1 font-weight-medium mb-0">NCM sem o zero à esquerda</h3>
              <span class="text-caption grey--text text--darken-1">
                O PDV guarda o NCM em campo numérico e o zero da frente se perde. "4039000" é o iogurte 04039000. Não é palpite: completa para 8 dígitos.
              </span>
            </div>
            <v-spacer></v-spacer>
            <span v-if="zeroTotal !== null" class="mr-4 text-body-2">
              <strong :class="zeroTotal ? 'primary--text' : 'grey--text'">{{ zeroTotal }}</strong> produto(s)
            </span>
            <v-btn outlined class="mr-2" :loading="contandoZero" @click="contarZero">
              <v-icon left>mdi-magnify</v-icon>
              Verificar
            </v-btn>
            <v-btn color="primary" depressed :disabled="!zeroTotal" :loading="corrigindoZero" @click="corrigirZero">
              <v-icon left>mdi-numeric-0-box</v-icon>
              Corrigir
            </v-btn>
          </div>
        </v-sheet>

        <!-- Conferência de NCM -->
        <div class="d-flex align-center flex-wrap mb-3">
          <div>
            <h3 class="text-subtitle-1 font-weight-medium mb-0">Produtos com NCM fora da tabela</h3>
            <span class="text-caption grey--text text--darken-1"> NCM em branco, com menos de 8 dígitos, ou que não existe no IBPT carregado </span>
          </div>
          <v-spacer></v-spacer>
          <v-select v-model="tenantId" :items="inquilinos" item-text="nome" item-value="id" label="Inquilino" outlined dense hide-details clearable style="max-width: 260px" class="mr-4" @change="conferir"></v-select>
          <v-checkbox v-model="incluirInativos" label="Incluir inativos" hide-details dense class="mr-4 mt-0" @change="conferir"></v-checkbox>
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
            <v-alert v-if="conferencia.truncado" type="warning" text dense>
              Mostrando os primeiros {{ conferencia.limite }} produtos. Filtre por inquilino para ver o resto — a normalização só age sobre o que está na tela.
            </v-alert>

            <div class="d-flex align-center flex-wrap mb-2">
              <span class="text-caption grey--text text--darken-1">
                {{ conferencia.totais.produtos }} produto(s) em {{ conferencia.totais.clientes }} cliente(s) ·
                <span class="primary--text">{{ porZero.length }} zero à esquerda</span> ·
                {{ comSugestao.length - comPadrao.length - porZero.length }} por descrição ·
                <span class="warning--text">{{ comPadrao.length }} sem correspondência</span>
              </span>
              <v-spacer></v-spacer>
              <v-spacer></v-spacer>
              <v-btn small color="primary" class="mr-2" :disabled="!selecionadosComSugestao.length" :loading="normalizando" @click="normalizar(selecionadosComSugestao)">
                <v-icon left small>mdi-check</v-icon>
                Normalizar selecionados ({{ selecionadosComSugestao.length }})
              </v-btn>
              <v-btn small color="warning" class="mr-2" :disabled="!comSugestao.length" :loading="normalizando" @click="normalizar(comSugestao)">
                <v-icon left small>mdi-check-all</v-icon>
                Normalizar todos ({{ comSugestao.length }})
              </v-btn>
              <v-btn small color="purple" dark class="mr-2" :disabled="!semRespostaIA.length" :loading="buscandoIA" @click="buscarIA(false)">
                <v-icon left small>mdi-robot-outline</v-icon>
                Buscar na IA ({{ semRespostaIA.length }})
              </v-btn>
              <v-btn small color="purple" outlined class="mr-2" :disabled="!semNcmIA.length" :loading="buscandoIA" @click="buscarIA(true)" title="Pergunta de novo para quem a IA não soube responder">
                <v-icon left small>mdi-robot-confused-outline</v-icon>
                Reconsultar vazios ({{ semNcmIA.length }})
              </v-btn>
              <v-btn small color="purple" outlined :disabled="!comSugestaoIA.length" :loading="normalizando" @click="normalizarIA">
                <v-icon left small>mdi-robot</v-icon>
                Usar sugestão da IA ({{ comSugestaoIA.length }})
              </v-btn>
            </div>

            <v-data-table
              v-model="selecionados"
              :headers="headersProdutos"
              :items="produtos"
              :items-per-page="20"
              :footer-props="{ 'items-per-page-text': 'Produtos por página' }"
              item-key="chave"
              show-select
              class="elevation-1"
            >
              <template #[`item.cliente`]="{ item }">
                <div class="font-weight-medium">{{ item.cliente || `Cliente ${item.tenant_id}` }}</div>
                <div v-if="item.cnpjcpf" class="text-caption grey--text text--darken-1">{{ item.cnpjcpf }}</div>
              </template>
              <template #[`item.ncm`]="{ item }">
                <span v-if="item.ncm" class="error--text">{{ item.ncm }}</span>
                <span v-else class="grey--text">(vazio)</span>
              </template>
              <template #[`item.ncm_sugerido`]="{ item }">
                <template v-if="item.ncm_sugerido">
                  <div class="font-weight-medium" :class="corSugestao(item)">
                    {{ item.ncm_sugerido }}
                    <v-chip v-if="item.sugestao_origem === 'zero'" x-small color="primary" dark class="ml-1" title="O NCM atual já estava certo, só faltava o zero à esquerda">zero à esquerda</v-chip>
                    <v-chip v-else-if="item.sugestao_padrao" x-small color="warning" dark class="ml-1">padrão</v-chip>
                    <v-chip v-else x-small color="success" dark class="ml-1">por descrição</v-chip>
                  </div>
                  <div class="text-caption grey--text text--darken-1">{{ item.descricao_sugerida }}</div>
                </template>
                <span v-else class="grey--text">sem sugestão</span>
              </template>
              <template #[`item.ncm_ia`]="{ item }">
                <template v-if="item.ncm_ia">
                  <div class="font-weight-medium purple--text">{{ item.ncm_ia }}</div>
                  <div class="text-caption grey--text text--darken-1">{{ item.descricao_ia }}</div>
                </template>
                <span v-else-if="item.ia_consultada" class="grey--text">IA não soube dizer</span>
                <span v-else class="grey--text">não consultado</span>
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
      tenantId: null,
      zeroTotal: null,
      contandoZero: false,
      corrigindoZero: false,
      buscandoIA: false,
      selecionados: [],
      normalizando: false,
      snackbar: false,
      snackbarCor: "success",
      mensagem: "",
      headersProdutos: [
        { text: "Cliente", value: "cliente" },
        { text: "Código", value: "codigo", width: 100 },
        { text: "Descrição", value: "descricao" },
        { text: "NCM atual", value: "ncm", width: 110 },
        { text: "NCM sugerido", value: "ncm_sugerido", width: 240 },
        { text: "Sugestão da IA", value: "ncm_ia", width: 240 },
        { text: "Motivo", value: "motivo", width: 200 },
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
      // Chave propria: produto e identificado por (tenant, codigo, barras), e a
      // grid precisa de um item-key unico para a selecao funcionar.
      return (this.conferencia.produtos || []).map((produto) => ({
        ...produto,
        chave: `${produto.tenant_id}|${produto.codigo}|${produto.codigo_barras}`,
      }));
    },
    // So da para normalizar o que tem sugestao.
    comSugestao() {
      return this.produtos.filter((produto) => !!produto.ncm_sugerido);
    },
    selecionadosComSugestao() {
      return this.selecionados.filter((produto) => !!produto.ncm_sugerido);
    },
    // Sem correspondência no IBPT: recebe o NCM padrão. Contado à parte porque
    // aplicar padrão em massa é decisão diferente de aceitar uma sugestão.
    comPadrao() {
      return this.produtos.filter((produto) => produto.sugestao_padrao);
    },
    // Correção determinística, não palpite: o NCM atual já era o certo e só
    // perdeu o zero à esquerda. Pode ser aplicada em massa com segurança.
    // Ainda não perguntados à IA. Quem já foi e voltou vazio não entra: seria
    // pagar de novo pela mesma resposta.
    semRespostaIA() {
      return this.produtos.filter((produto) => !produto.ia_consultada && produto.descricao);
    },
    comSugestaoIA() {
      return this.produtos.filter((produto) => !!produto.ncm_ia);
    },
    // Já consultados e sem resposta. Ficam de fora da busca normal para não
    // pagar duas vezes pelo mesmo silêncio, mas podem ser reconsultados.
    semNcmIA() {
      return this.produtos.filter((produto) => produto.ia_consultada && !produto.ncm_ia);
    },
    porZero() {
      return this.produtos.filter((produto) => produto.sugestao_origem === "zero");
    },
    inquilinos() {
      return (this.$store.state.admin.tenantList.tenantList || []).map((tenant) => ({
        id: tenant.id,
        nome: `${tenant.id} - ${tenant.name || tenant.user}`,
      }));
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
      await Promise.all([this.$store.dispatch("getIbptSituacao"), this.$store.dispatch("getAdminTenantList")]);
    } finally {
      this.carregando = false;
    }
  },
  methods: {
    corSugestao(item) {
      if (item.sugestao_origem === "zero") return "primary--text";
      return item.sugestao_padrao ? "warning--text" : "success--text";
    },
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
        const descartados = resposta.ignorados ? ` ${resposta.ignorados} código(s) de serviço do arquivo foram ignorados.` : "";
        this.avisar(`${resposta.message} ${resposta.registros} NCM carregados (versão ${resposta.versao}).${descartados}`);
        // A conferência anterior fala da tabela antiga: refaz se já havia uma.
        if (this.jaConferiu) await this.conferir();
      } catch (erro) {
        this.erroArquivo = erro?.response?.data?.message || "Não foi possível processar o arquivo.";
      } finally {
        this.enviando = false;
      }
    },
    async contarZero() {
      this.contandoZero = true;
      try {
        const res = await this.$store.dispatch("contarZeroAEsquerda", this.tenantId ? { tenant_id: this.tenantId } : {});
        this.zeroTotal = res.total;
      } finally {
        this.contandoZero = false;
      }
    },
    async corrigirZero() {
      const alvo = this.tenantId ? "do inquilino selecionado" : "de TODOS os inquilinos";
      if (!window.confirm(`Completar o zero à esquerda em ${this.zeroTotal} produto(s) ${alvo}?`)) return;

      this.corrigindoZero = true;
      try {
        const res = await this.$store.dispatch("corrigirZeroAEsquerda", this.tenantId ? { tenant_id: this.tenantId } : {});
        this.avisar(`${res.alterados} produto(s) corrigido(s).`);
        await this.contarZero();
        if (this.jaConferiu) await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível corrigir.", "error");
      } finally {
        this.corrigindoZero = false;
      }
    },
    async buscarIA(reconsultar) {
      const alvo = reconsultar ? this.semNcmIA : this.semRespostaIA;
      const texto = reconsultar ? "Perguntar de novo para" : "Consultar a IA para";
      if (!window.confirm(`${texto} ${alvo.length} produto(s)?

A resposta fica gravada, então a conferência seguinte já vem preenchida.`)) return;

      this.buscandoIA = true;
      try {
        const res = await this.$store.dispatch("buscarNcmComIA", {
          produtos: alvo.map((item) => ({ descricao: item.descricao })),
          reconsultarVazios: reconsultar,
        });
        const sobra = res.restantes ? ` ${res.restantes} ficaram para a próxima rodada.` : "";
        this.avisar(res.message || `${res.consultados} descrição(ões) consultada(s), ${res.comSugestao} com NCM.${sobra}`);
        await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível consultar a IA.", "error");
      } finally {
        this.buscandoIA = false;
      }
    },
    // Grava o NCM que a IA escolheu, no mesmo caminho validado da normalização.
    normalizarIA() {
      return this.normalizar(this.comSugestaoIA.map((produto) => ({ ...produto, ncm_sugerido: produto.ncm_ia, sugestao_padrao: false })));
    },
    async conferir() {
      this.conferindo = true;
      try {
        this.selecionados = [];
        await this.$store.dispatch("getIbptProdutosSemNcm", {
          incluirInativos: this.incluirInativos ? "1" : "0",
          ...(this.tenantId ? { tenant_id: this.tenantId } : {}),
        });
        this.jaConferiu = true;
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível conferir os NCM.", "error");
      } finally {
        this.conferindo = false;
      }
    },
    // Grava o NCM sugerido nos produtos indicados. Confirma antes: e alteracao
    // de dado fiscal, em cadastro de cliente, e nao tem desfazer.
    async normalizar(itens) {
      if (!itens.length) return;

      const clientes = new Set(itens.map((item) => item.tenant_id)).size;
      const padroes = itens.filter((item) => item.sugestao_padrao).length;
      const avisoPadrao = padroes ? `

ATENÇÃO: ${padroes} deles não tiveram correspondência no IBPT e vão receber o NCM padrão.` : "";

      const confirmado = window.confirm(`Gravar o NCM sugerido em ${itens.length} produto(s) de ${clientes} cliente(s)?${avisoPadrao}

A alteração não pode ser desfeita.`);
      if (!confirmado) return;

      this.normalizando = true;
      try {
        const resposta = await this.$store.dispatch(
          "normalizarNcm",
          itens.map((item) => ({
            tenant_id: item.tenant_id,
            codigo: item.codigo,
            codigo_barras: item.codigo_barras,
            ncm: item.ncm_sugerido,
          }))
        );

        const recusados = resposta.rejeitados?.length ? ` ${resposta.rejeitados.length} recusado(s).` : "";
        this.avisar(`${resposta.alterados} produto(s) atualizado(s).${recusados}`, resposta.rejeitados?.length ? "warning" : "success");

        await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível normalizar.", "error");
      } finally {
        this.normalizando = false;
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
        ncm_sugerido: produto.ncm_sugerido,
        descricao_sugerida: produto.descricao_sugerida,
        origem_sugestao: produto.sugestao_origem || "",
        ncm_ia: produto.ncm_ia,
        descricao_ia: produto.descricao_ia,
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
