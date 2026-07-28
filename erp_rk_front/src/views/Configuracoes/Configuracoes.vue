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
  </div>
</template>

<script>
export default {
  data() {
    return {
      logo: null,
    };
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
  },
};
</script>
