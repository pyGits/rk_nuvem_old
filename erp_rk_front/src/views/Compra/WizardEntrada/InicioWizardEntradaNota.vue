<template>
  <div>
    <v-card outlined class="pa-4">
      <v-card-title class="headline">Importar Nota Fiscal</v-card-title>

      <v-card-text>
        <v-btn color="primary" class="ma-2" @click="irPara('manual')">Entrada Manual</v-btn>

        <v-btn color="primary" class="ma-2" @click="abrirModalChave = true">Pela Chave de Acesso</v-btn>

        <v-btn color="primary" @click="$refs.xmlFile.click()">📁 Selecionar XML</v-btn>
        <input id="xmlFile" ref="xmlFile" type="file" class="d-none" accept=".xml" @change="enviarXML" />
        <v-divider></v-divider>
        <v-row>
          <ListarNota></ListarNota>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Modal da chave de acesso -->
    <v-dialog v-model="abrirModalChave" max-width="500px">
      <v-card>
        <v-card-title class="headline">Digite a chave de acesso</v-card-title>

        <v-card-text>
          <input class="form-control" v-model="chaveAcesso" label="Chave da NFe" required @input="limparChave" />
        </v-card-text>

        <v-card-actions>
          <v-spacer />
          <v-btn text @click="abrirModalChave = false">Cancelar</v-btn>
          <v-btn color="primary" @click="buscarPorChave">Buscar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import ToastService from "@/infra/service/ToastService";
import ListarNota from "../Recebimento/ListarNota.vue";

export default {
  inject: ["notaFiscalEntradaController"],
  components: {
    ListarNota,
  },
  data() {
    return {
      abrirModalChave: false,
      chaveAcesso: "",
      notas: [],
    };
  },
  methods: {
    irPara(tipo) {
      this.$router.push(`/compra/recebimento/${tipo}`);
    },
    limparChave(e) {
      // Remove tudo que não for número
      this.chaveAcesso = e.target.value.replace(/\D/g, "");
    },
    async enviarXML(event) {
      const file = event.target.files[0];
      const res = await this.notaFiscalEntradaController.ImportarXMLDiretorio({ arquivo: file });
      const chave = res.data.nota.protocolo.chave;
      this.$router.push(`/compra/recebimento/${chave}`);
      ToastService.showSuccess(res.message);
    },
    async buscarPorChave() {
      await this.notaFiscalEntradaController.capturarNotaDaSefaz(this.chaveAcesso);
      this.$router.push(`/compra/recebimento/${this.chaveAcesso}`);
    },
  },
};
</script>
