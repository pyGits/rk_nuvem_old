<template>
  <div>
    <v-card>
      <v-card-title class="headline">Configurações do Sistema</v-card-title>
      <v-row>
        <v-col cols="12" sm="12">
          <v-card-text>
            <v-file-input v-model="logo" label="Upload do Logo do Cliente" accept="image/*" @change="handleLogoUpload"></v-file-input>
            <v-btn color="primary" @click="uploadLogo" :disabled="!logo"> Enviar Logo </v-btn>
          </v-card-text>
        </v-col>
      </v-row>
    </v-card>

    <v-card class="mt-4">
      <v-card-title class="headline">Carga Automática para as Lojas</v-card-title>
      <v-card-subtitle>
        Com a carga automática ligada, alterar um cadastro que vai para o PDV
        (produto, preço, estoque, tributação, finalizadora, funcionário ou
        cliente) já envia a carga de alterados para as lojas, sem precisar
        abrir a tela de carga e clicar em "Enviar alterados".
      </v-card-subtitle>
      <v-card-text>
        <v-row align="center">
          <v-col cols="12" sm="5">
            <v-switch
              v-model="cargaAutomatica"
              :label="cargaAutomatica ? 'Ligada' : 'Desligada'"
              color="primary"
              inset
              hide-details
              :disabled="carregandoConfig"
            ></v-switch>
          </v-col>
          <v-col cols="12" sm="4">
            <v-select
              v-model="cargaAutomaticaSegundos"
              :items="opcoesJanela"
              item-text="texto"
              item-value="valor"
              label="Quando enviar"
              hint="Agrupar só vale a pena para importação de lote grande"
              persistent-hint
              :disabled="!cargaAutomatica || carregandoConfig"
            ></v-select>
          </v-col>
        </v-row>

        <!-- Sem explicar o que cada modo faz, "1 minuto" parece um atraso
             sem motivo e o imediato parece arriscado para lote grande. -->
        <v-alert
          v-if="cargaAutomatica"
          type="info"
          text
          dense
          class="mt-4 mb-0"
        >
          <template v-if="!cargaAutomaticaSegundos">
            A carga é pedida assim que o cadastro é gravado — a loja recebe em
            poucos segundos. Cadastros gravados em sequência entram na mesma
            carga, não geram uma carga cada.
          </template>
          <template v-else>
            As alterações são agrupadas: a carga sai
            {{ textoJanelaSelecionada }} depois da última gravação. Útil para
            importar lote grande de uma vez só.
          </template>
        </v-alert>

        <v-btn
          color="primary"
          class="mt-4"
          @click="salvarConfiguracao"
          :disabled="salvandoConfig || carregandoConfig"
          :loading="salvandoConfig"
        >
          Salvar
        </v-btn>
      </v-card-text>
    </v-card>

    <v-card class="mt-4">
      <v-card-title class="headline">Senha do Login Principal</v-card-title>
      <v-card-subtitle>
        Troca a senha do login principal do cliente. Para confirmar, informe a
        senha atual.
      </v-card-subtitle>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="4">
            <v-text-field
              v-model="senhaAtual"
              label="Senha atual"
              type="password"
              autocomplete="current-password"
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="4">
            <v-text-field
              v-model="novaSenha"
              label="Nova senha"
              type="password"
              autocomplete="new-password"
            ></v-text-field>
          </v-col>
          <v-col cols="12" sm="4">
            <v-text-field
              v-model="confirmacaoSenha"
              label="Confirme a nova senha"
              type="password"
              autocomplete="new-password"
            ></v-text-field>
          </v-col>
        </v-row>
        <v-btn
          color="primary"
          @click="alterarSenha"
          :disabled="!podeAlterarSenha || salvandoSenha"
          :loading="salvandoSenha"
        >
          Alterar Senha
        </v-btn>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      logo: null,
      senhaAtual: "",
      novaSenha: "",
      confirmacaoSenha: "",
      salvandoSenha: false,
      cargaAutomatica: false,
      cargaAutomaticaSegundos: 0,
      carregandoConfig: true,
      salvandoConfig: false,
      // Os valores precisam bater com os limites que o backend aceita
      // (CargaAutomatica.ts: 0 = imediato; acima disso, mínimo 10s, máximo 1h).
      opcoesJanela: [
        { valor: 0, texto: "Assim que gravar" },
        { valor: 60, texto: "Agrupar por 1 minuto" },
        { valor: 300, texto: "Agrupar por 5 minutos" },
        { valor: 900, texto: "Agrupar por 15 minutos" },
        { valor: 1800, texto: "Agrupar por 30 minutos" },
      ],
    };
  },
  async mounted() {
    try {
      const config = await this.$store.dispatch("getConfiguracao");
      this.cargaAutomatica = config.carga_automatica;
      this.cargaAutomaticaSegundos = config.carga_automatica_segundos;
    } catch (err) {
      this.$store.dispatch(
        "showToastMessage",
        "Não foi possível carregar as configurações."
      );
    } finally {
      this.carregandoConfig = false;
    }
  },
  computed: {
    textoJanelaSelecionada() {
      const opcao = this.opcoesJanela.find(
        (o) => o.valor === this.cargaAutomaticaSegundos
      );
      return opcao ? opcao.texto : `${this.cargaAutomaticaSegundos} segundos`;
    },
    podeAlterarSenha() {
      return (
        this.senhaAtual.trim() !== "" &&
        this.novaSenha.trim() !== "" &&
        this.confirmacaoSenha.trim() !== ""
      );
    },
  },
  methods: {
    async handleLogoUpload() {
      // Manipular a seleção do arquivo aqui, se necessário
    },
    async uploadLogo() {
      if (this.logo) {
        const formData = new FormData();
        formData.append("logo", this.logo);
        await this.$store.dispatch("uploadClientLogo", formData);
        // Limpar o campo de seleção do arquivo após o envio
        this.logo = null;
        location.reload();
      }
    },
    async salvarConfiguracao() {
      this.salvandoConfig = true;
      try {
        const res = await this.$store.dispatch("salvarConfiguracao", {
          carga_automatica: this.cargaAutomatica,
          carga_automatica_segundos: this.cargaAutomaticaSegundos,
        });
        // O backend normaliza a janela (mínimo/máximo); a tela passa a mostrar
        // o que ficou gravado, não o que foi enviado.
        this.cargaAutomaticaSegundos = res.data.carga_automatica_segundos;
        this.$store.dispatch("showToastMessage", res.data.message);
      } catch (err) {
        this.$store.dispatch(
          "showToastMessage",
          err.response?.data?.message || "Erro ao salvar as configurações"
        );
      } finally {
        this.salvandoConfig = false;
      }
    },
    async alterarSenha() {
      if (!this.podeAlterarSenha) {
        return;
      }

      if (this.novaSenha !== this.confirmacaoSenha) {
        this.$store.dispatch(
          "showToastMessage",
          "Senha não confere com confirmação"
        );
        return;
      }

      this.salvandoSenha = true;
      try {
        const res = await this.$store.dispatch("alterarSenhaPrincipal", {
          senhaAtual: this.senhaAtual,
          novaSenha: this.novaSenha,
          confirmacaoSenha: this.confirmacaoSenha,
        });
        this.$store.dispatch("showToastMessage", res.data.message);
        this.senhaAtual = "";
        this.novaSenha = "";
        this.confirmacaoSenha = "";
      } catch (err) {
        this.$store.dispatch(
          "showToastMessage",
          err.response?.data?.message || "Erro ao alterar a senha"
        );
      } finally {
        this.salvandoSenha = false;
      }
    },
  },
};
</script>
