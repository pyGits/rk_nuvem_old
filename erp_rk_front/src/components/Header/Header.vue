<template>
  <div>
    <v-app-bar app color="primary" dark class="position-fixed">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-autocomplete
        v-model="itemSelecionado"
        :items="itensMenuPesquisa"
        :filter="filtrarItemMenu"
        item-text="nome"
        item-value="to"
        label="Pesquisar telas..."
        prepend-icon="mdi-magnify"
        hide-details
        hide-no-data
        clearable
        return-object
        dense
        class="max-width"
        label-color="white"
      >
        <template v-slot:item="{ item }">
          <v-list-item-icon>
            <v-icon>{{ item.icon || "mdi-chevron-right" }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ item.nome }}</v-list-item-title>
            <v-list-item-subtitle>{{ item.caminho }}</v-list-item-subtitle>
          </v-list-item-content>
        </template>
      </v-autocomplete>
      <v-spacer></v-spacer>
      <v-btn icon to="/carga/loja" title="Enviar carga para as lojas">
        <v-icon>mdi-cloud-upload-outline</v-icon>
      </v-btn>
      <v-menu offset-y left :close-on-content-click="false" max-width="380">
        <template v-slot:activator="{ on }">
          <v-btn icon v-on="on">
            <v-badge :value="notificacoes.length > 0" :content="notificacoes.length" color="error" overlap>
              <v-icon>mdi-bell</v-icon>
            </v-badge>
          </v-btn>
        </template>
        <v-card>
          <v-card-title class="text-subtitle-1 py-2">Notificações</v-card-title>
          <v-divider></v-divider>
          <div v-if="!notificacoes.length" class="text-center py-6 grey--text text-caption">
            Nenhuma notificação no momento.
          </div>
          <v-list v-else dense class="py-0" style="max-height: 360px; overflow-y: auto">
            <v-list-item
              v-for="notificacao in notificacoes"
              :key="notificacao.id"
              :to="notificacao.link"
            >
              <v-list-item-icon>
                <v-icon :color="notificacao.severidade === 'error' ? 'error' : 'warning'">
                  {{ notificacao.severidade === "error" ? "mdi-alert-circle" : "mdi-alert" }}
                </v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title class="text-body-2 font-weight-medium">{{ notificacao.titulo }}</v-list-item-title>
                <v-list-item-subtitle>{{ notificacao.mensagem }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card>
      </v-menu>
      <v-btn v-if="featureFeedbackAtivo" icon title="Enviar feedback" @click="dialogFeedback = true">
        <v-icon>mdi-message-draw</v-icon>
      </v-btn>

      <div class="d-flex flex-column align-end mr-3 usuario-logado">
        <span class="text-body-2 font-weight-medium">{{ tenant.name || "Cliente" }}</span>
        <span v-if="tenant.cnpjcpf" class="text-caption">{{ tenant.cnpjcpf }}</span>
      </div>

      <v-btn color="secondary" text @click="logout">
        Sair
        <v-icon>mdi-logout</v-icon>
      </v-btn>
    </v-app-bar>

    <v-dialog v-if="featureFeedbackAtivo" v-model="dialogFeedback" max-width="480" persistent>
      <v-card>
        <v-card-title>
          <v-icon color="primary" class="mr-2">mdi-message-draw</v-icon>
          Deixe seu feedback
        </v-card-title>
        <v-card-text>
          <p class="text-body-2 grey--text text--darken-1">
            Conta pra gente o que podemos melhorar no sistema.
          </p>
          <v-rating
            v-model="feedbackNota"
            color="amber"
            background-color="grey lighten-1"
            hover
            class="mb-2"
          ></v-rating>
          <v-textarea
            v-model="feedbackMensagem"
            label="Sua sugestão"
            outlined
            rows="4"
            auto-grow
            counter
            maxlength="1000"
          ></v-textarea>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="fecharFeedback">Cancelar</v-btn>
          <v-btn
            color="primary"
            depressed
            :loading="enviandoFeedback"
            :disabled="!feedbackMensagem.trim()"
            @click="enviarFeedback"
          >
            Enviar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import Vue from "vue";
import menuItems from "@/components/Menu/Menu.json"; // importa o arquivo com os itens do menu

export default {
  data() {
    return {
      // Feature pronta, só desligada a pedido enquanto não é hora de lançar.
      // Reativar: trocar para true (some o botão do sininho de feedback e o diálogo).
      featureFeedbackAtivo: false,
      itemSelecionado: null,
      dialogFeedback: false,
      feedbackMensagem: "",
      feedbackNota: 0,
      enviandoFeedback: false,
    };
  },
  watch: {
    itemSelecionado(valor) {
      if (valor && valor.to) {
        this.$router.push(valor.to).catch((err) => {
          // Ignora só o erro esperado de navegar pra rota já ativa.
          if (err && err.name !== "NavigationDuplicated") throw err;
        });
      }
      // Limpa o campo depois de navegar, senão fica preso mostrando a
      // última tela pesquisada em vez de voltar a ser uma busca em branco.
      this.$nextTick(() => {
        this.itemSelecionado = null;
      });
    },
  },
  async mounted() {
    await this.$store.dispatch("getNotificacoes");
  },
  methods: {
    fecharFeedback() {
      this.dialogFeedback = false;
      this.feedbackMensagem = "";
      this.feedbackNota = 0;
    },
    async enviarFeedback() {
      if (!this.feedbackMensagem.trim()) return;

      this.enviandoFeedback = true;
      try {
        await this.$http.post("/feedback", {
          mensagem: this.feedbackMensagem.trim(),
          nota: this.feedbackNota || null,
        });
        this.$store.dispatch("showToastMessage", "Feedback enviado, obrigado!");
        this.fecharFeedback();
      } catch (err) {
        this.$store.dispatch("showToastMessage", "Não foi possível enviar o feedback.");
      } finally {
        this.enviandoFeedback = false;
      }
    },
    logout() {
      Vue.prototype.$http.defaults.headers.common["x-access-token"] = null;
      localStorage.removeItem("access_token");
      this.$router.push("/login");
    },
    // Alem do "nome" (item-text padrao), busca tambem pelo caminho
    // completo do menu (ex: "Relatórios" acha "Painel de Vendas").
    filtrarItemMenu(item, queryText) {
      const texto = `${item.nome} ${item.caminho}`.toLowerCase();
      return texto.includes(queryText.toLowerCase());
    },
  },
  computed: {
    drawer: {
      get() {
        return this.$store.state.Application.drawer;
      },
      set(value) {
        this.$store.commit("setDrawerApplication", value);
      },
    },
    notificacoes() {
      return this.$store.state.notificacao.notificacaoList;
    },
    tenant() {
      return this.$store.state.tenant.tenant;
    },
    // Achata o menu inteiro (inclusive o terceiro nível, subSubItems, que
    // antes nem entrava na busca) num único array pesquisável, guardando o
    // caminho completo para diferenciar itens com nomes repetidos.
    itensMenuPesquisa() {
      const itens = [];
      menuItems.forEach((secao) => {
        (secao.subItems || []).forEach((sub) => {
          if (sub.to) {
            itens.push({
              nome: sub.name,
              caminho: `${secao.text} › ${sub.name}`,
              to: sub.to,
              icon: sub.icon || secao.icon,
            });
          }
          (sub.subSubItems || []).forEach((subSub) => {
            itens.push({
              nome: subSub.name,
              caminho: `${secao.text} › ${sub.name} › ${subSub.name}`,
              to: subSub.to,
              icon: secao.icon,
            });
          });
        });
      });
      return itens;
    },
  },
};
</script>

<style lang="scss" scoped>
.v-app-bar {
  background-color: #1976d2 !important; // Define a cor de fundo da barra como azul
}
.max-width {
  max-width: 300px; // Define a largura máxima do campo de pesquisa
}
.v-input .v-label {
  color: white !important ;
}
.usuario-logado {
  line-height: 1.1;
}
.usuario-logado .text-caption {
  color: rgba(255, 255, 255, 0.75);
}
</style>
