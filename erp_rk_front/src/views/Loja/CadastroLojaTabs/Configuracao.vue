<template>
  <div>
    <v-card>
      <v-card-title>Configuração do Certificado Digital (A1)</v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="4">
            <v-file-input v-model="certificado" accept=".pfx" label="Certificado (.pfx)"></v-file-input>
          </v-col>

          <v-col cols="12" sm="4">
            <v-text-field v-model="senha" type="password" label="Senha do Certificado"></v-text-field>
          </v-col>

          <v-col cols="12" sm="4" class="d-flex align-center">
            <v-btn color="primary" @click="uploadCertificado" :disabled="!certificado || !senha || carregando" :loading="carregando"> Enviar Certificado </v-btn>
          </v-col>
        </v-row>

        <v-alert v-if="info" type="success" dense text class="mt-2">
          Certificado válido — <strong>{{ info.titular }}</strong
          >, válido até <strong>{{ formatarData(info.validade) }}</strong
          >.
        </v-alert>
      </v-card-text>
    </v-card>
  </div>
</template>
<script>
import LojaService from "@/infra/service/LojaService";
import ToastService from "@/infra/service/ToastService";

export default {
  data() {
    return {
      certificado: null,
      senha: "",
      carregando: false,
      info: null,
    };
  },
  computed: {
    lojaId: {
      get() {
        return this.$store.state.loja.loja.codigo;
      },
    },
  },

  methods: {
    formatarData(data) {
      if (!data) return "";
      return new Date(data).toLocaleDateString("pt-BR");
    },
    async uploadCertificado() {
      try {
        this.carregando = true;
        this.info = await LojaService.uploadCertificado(this.certificado, this.senha, this.lojaId);
        ToastService.showSuccess("Certificado atualizado com sucesso !");
      } catch (error) {
        ToastService.showError(error?.response?.data?.message || error.message || "Falha ao enviar o certificado");
      } finally {
        this.carregando = false;
      }
    },
  },
};
</script>
