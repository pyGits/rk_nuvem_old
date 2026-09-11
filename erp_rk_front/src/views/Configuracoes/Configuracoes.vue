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
    };
  },
  computed: {
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
