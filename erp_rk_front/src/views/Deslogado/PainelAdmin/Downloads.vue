<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="primary" class="mr-3">mdi-cloud-download-outline</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Downloads</h2>
          <span class="text-caption grey--text text--darken-1">
            Arquivos disponíveis para os clientes na tela de Downloads
          </span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" depressed @click="abrirNovo">
          <v-icon left>mdi-plus</v-icon>
          Publicar arquivo
        </v-btn>
      </div>

      <div v-if="!downloads.length" class="text-center py-12 grey--text">
        <v-icon size="56" color="grey lighten-1">mdi-package-variant</v-icon>
        <p class="mt-3 mb-0">Nenhum arquivo publicado ainda.</p>
      </div>

      <v-data-table
        v-else
        :headers="headers"
        :items="downloads"
        :items-per-page="10"
        :footer-props="{ 'items-per-page-text': 'Arquivos por página' }"
      >
        <template #[`item.titulo`]="{ item }">
          <div class="font-weight-medium">{{ item.titulo }}</div>
          <div v-if="item.descricao" class="text-caption grey--text text--darken-1">
            {{ item.descricao }}
          </div>
        </template>

        <template #[`item.versao`]="{ item }">
          <v-chip v-if="item.versao" small label outlined>{{ item.versao }}</v-chip>
          <span v-else class="grey--text">-</span>
        </template>

        <template #[`item.arquivo_original`]="{ item }">
          <div>{{ item.arquivo_original }}</div>
          <div class="text-caption grey--text text--darken-1">
            {{ formataTamanho(item.tamanho) }}
          </div>
        </template>

        <template #[`item.updated_at`]="{ item }">
          {{ formataData(item.updated_at) }}
        </template>

        <template #[`item.ativo`]="{ item }">
          <v-switch
            :input-value="item.ativo"
            dense
            hide-details
            class="mt-0 pt-0"
            :loading="salvandoId === item.id"
            @change="alternaPublicacao(item, $event)"
          ></v-switch>
        </template>

        <template #[`item.acoes`]="{ item }">
          <v-btn icon small title="Nova versão" @click="abrirNovaVersao(item)">
            <v-icon small>mdi-upload</v-icon>
          </v-btn>
          <v-btn icon small title="Editar" @click="abrirEdicao(item)">
            <v-icon small>mdi-pencil</v-icon>
          </v-btn>
          <v-btn icon small title="Remover" @click="confirmarRemocao(item)">
            <v-icon small color="red">mdi-delete</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-card>

    <!-- Publicar / nova versão -->
    <v-dialog v-model="dialogUpload" max-width="560" persistent>
      <v-card>
        <v-card-title class="headline">{{ tituloDialogUpload }}</v-card-title>
        <v-card-text>
          <v-text-field
            v-model="form.titulo"
            label="Título"
            outlined
            dense
            :disabled="enviando"
            :error-messages="erros.titulo"
          ></v-text-field>
          <v-text-field
            v-model="form.descricao"
            label="Descrição"
            outlined
            dense
            :disabled="enviando"
          ></v-text-field>
          <v-text-field
            v-model="form.versao"
            label="Versão"
            placeholder="1.0.0"
            outlined
            dense
            :disabled="enviando"
          ></v-text-field>
          <v-file-input
            v-model="form.arquivo"
            :label="`Arquivo (${extensoes})`"
            :accept="extensoes"
            outlined
            dense
            show-size
            prepend-icon="mdi-paperclip"
            :disabled="enviando"
            :error-messages="erros.arquivo"
          ></v-file-input>

          <div v-if="enviando">
            <v-progress-linear :value="progresso" height="8" rounded color="primary"></v-progress-linear>
            <div class="text-caption grey--text mt-1">Enviando... {{ progresso }}%</div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text :disabled="enviando" @click="dialogUpload = false">Cancelar</v-btn>
          <v-btn color="primary" depressed :loading="enviando" @click="publicar">Publicar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Editar dados sem trocar o arquivo -->
    <v-dialog v-model="dialogEdicao" max-width="560">
      <v-card>
        <v-card-title class="headline">Editar download</v-card-title>
        <v-card-text>
          <v-text-field v-model="form.titulo" label="Título" outlined dense></v-text-field>
          <v-text-field v-model="form.descricao" label="Descrição" outlined dense></v-text-field>
          <v-text-field v-model="form.versao" label="Versão" outlined dense></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="dialogEdicao = false">Cancelar</v-btn>
          <v-btn color="primary" depressed :loading="salvando" @click="salvarEdicao">Salvar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Remoção -->
    <v-dialog v-model="dialogRemocao" max-width="440">
      <v-card>
        <v-card-title class="headline">Remover download</v-card-title>
        <v-card-text>
          O arquivo <strong>{{ form.titulo }}</strong> será apagado do servidor e sairá da
          tela de Downloads dos clientes. Deseja continuar?
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="dialogRemocao = false">Cancelar</v-btn>
          <v-btn color="red" dark depressed :loading="salvando" @click="remover">Remover</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-snackbar v-model="snackbar" :color="snackbarCor" timeout="4000">
      {{ mensagem }}
    </v-snackbar>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";

const formVazio = { id: null, titulo: "", descricao: "", versao: "", arquivo: null };

export default {
  components: { MenuAdmin },
  data() {
    return {
      extensoes: ".zip,.rar,.7z,.exe,.msi",
      form: { ...formVazio },
      erros: { titulo: "", arquivo: "" },
      dialogUpload: false,
      dialogEdicao: false,
      dialogRemocao: false,
      enviando: false,
      salvando: false,
      salvandoId: null,
      progresso: 0,
      snackbar: false,
      snackbarCor: "success",
      mensagem: "",
      headers: [
        { text: "Título", value: "titulo" },
        { text: "Versão", value: "versao", width: 120 },
        { text: "Arquivo", value: "arquivo_original" },
        { text: "Publicado em", value: "updated_at", width: 160 },
        { text: "Visível", value: "ativo", width: 100, sortable: false },
        { text: "", value: "acoes", width: 140, sortable: false, align: "end" },
      ],
    };
  },
  computed: {
    downloads() {
      return this.$store.state.download.downloadList;
    },
    tituloDialogUpload() {
      return this.form.id ? "Publicar nova versão" : "Publicar arquivo";
    },
  },
  async mounted() {
    await this.carregar();
  },
  methods: {
    async carregar() {
      try {
        await this.$store.dispatch("getDownloadsAdmin");
      } catch (err) {
        this.avisa("Não foi possível carregar a lista.", "error");
      }
    },
    avisa(mensagem, cor = "success") {
      this.mensagem = mensagem;
      this.snackbarCor = cor;
      this.snackbar = true;
    },
    formataTamanho(bytes) {
      const valor = Number(bytes) || 0;
      if (valor < 1024) return `${valor} B`;
      if (valor < 1024 * 1024) return `${(valor / 1024).toFixed(1)} KB`;
      if (valor < 1024 * 1024 * 1024) return `${(valor / 1024 / 1024).toFixed(1)} MB`;
      return `${(valor / 1024 / 1024 / 1024).toFixed(2)} GB`;
    },
    formataData(data) {
      if (!data) return "-";
      return new Date(data).toLocaleString("pt-BR");
    },
    abrirNovo() {
      this.form = { ...formVazio };
      this.erros = { titulo: "", arquivo: "" };
      this.progresso = 0;
      this.dialogUpload = true;
    },
    // Mantem o registro e troca so o arquivo — o cliente continua vendo o mesmo
    // item na lista, agora apontando para a versao nova.
    abrirNovaVersao(item) {
      this.form = {
        id: item.id,
        titulo: item.titulo,
        descricao: item.descricao,
        versao: item.versao,
        arquivo: null,
      };
      this.erros = { titulo: "", arquivo: "" };
      this.progresso = 0;
      this.dialogUpload = true;
    },
    abrirEdicao(item) {
      this.form = { ...item, arquivo: null };
      this.dialogEdicao = true;
    },
    confirmarRemocao(item) {
      this.form = { ...item, arquivo: null };
      this.dialogRemocao = true;
    },
    async publicar() {
      this.erros = {
        titulo: this.form.titulo ? "" : "Informe o título",
        arquivo: this.form.arquivo ? "" : "Selecione o arquivo",
      };
      if (this.erros.titulo || this.erros.arquivo) return;

      this.enviando = true;
      this.progresso = 0;
      try {
        await this.$store.dispatch("publicarDownload", {
          ...this.form,
          onProgress: (evento) => {
            if (evento.total) {
              this.progresso = Math.round((evento.loaded / evento.total) * 100);
            }
          },
        });
        this.dialogUpload = false;
        this.avisa("Arquivo publicado com sucesso.");
        await this.carregar();
      } catch (err) {
        const resposta = err.response && err.response.data;
        this.avisa(resposta ? resposta.message : "Erro ao publicar o arquivo.", "error");
      } finally {
        this.enviando = false;
      }
    },
    async salvarEdicao() {
      this.salvando = true;
      try {
        await this.$store.dispatch("atualizarDownload", this.form);
        this.dialogEdicao = false;
        this.avisa("Download atualizado.");
        await this.carregar();
      } catch (err) {
        this.avisa("Erro ao atualizar o download.", "error");
      } finally {
        this.salvando = false;
      }
    },
    async remover() {
      this.salvando = true;
      try {
        await this.$store.dispatch("removerDownload", this.form);
        this.dialogRemocao = false;
        this.avisa("Download removido.");
        await this.carregar();
      } catch (err) {
        this.avisa("Erro ao remover o download.", "error");
      } finally {
        this.salvando = false;
      }
    },
    async alternaPublicacao(item, valor) {
      this.salvandoId = item.id;
      try {
        await this.$store.dispatch("atualizarDownload", { ...item, ativo: valor });
        this.avisa(valor ? "Arquivo visível para os clientes." : "Arquivo ocultado.");
        await this.carregar();
      } catch (err) {
        this.avisa("Erro ao alterar a visibilidade.", "error");
        await this.carregar();
      } finally {
        this.salvandoId = null;
      }
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
</style>
