<template>
  <v-card>
    <v-tabs v-model="tab" background-color="primary" dark>
      <v-tab>Notas</v-tab>
      <v-tab>Notas na Sefaz</v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab">
      <v-tab-item>
        <v-card flat>
          <v-card-text>
            <v-row>
              <v-col cols="12" class="d-flex justify-end">
                <v-btn color="warning" class="mr-2" :disabled="!notaSelecionada || !notaSelecionada.entrada_nota_etapa" @click="desfazerNota">
                  <v-icon left>mdi-cancel</v-icon>
                  Desfazer Nota
                </v-btn>

                <v-btn color="primary" @click="abrirNota" :disabled="!notaSelecionada">
                  <v-icon left>mdi-eye</v-icon>
                  Editar/Visualizar
                </v-btn>
              </v-col>
            </v-row>
            <v-divider></v-divider>
            <v-data-table :key="notas.length" item-key="protocolo_chave" :items="notas" :headers="headerNotas" item-value="protocolo_chave" :item-class="highlightRow" class="elevation-1" dense>
              <template v-slot:item="{ item }">
                <tr :class="highlightRow(item)" @click="selecionarLinha(item)">
                  <td>{{ item.cnpjcpf }}</td>
                  <td>{{ item.nome }}</td>
                  <td>{{ new Date(item.data_emissao).toLocaleDateString("pt-BR") }}</td>
                  <td>{{ item.loja_id }}</td>
                  <td>{{ item.serie }}</td>
                  <td>{{ item.nr_nota }}</td>
                  <td>{{ item.total_valor_produtos | money }}</td>
                  <td>
                    <v-icon :color="item.entrada_nota_etapa ? 'green' : 'red'">
                      {{ item.entrada_nota_etapa ? "mdi-check-circle" : "mdi-close-circle" }}
                    </v-icon>
                  </td>
                  <td>
                    <v-icon :color="item.lancamento_financeiro_etapa ? 'green' : 'red'">
                      {{ item.lancamento_financeiro_etapa ? "mdi-check-circle" : "mdi-close-circle" }}
                    </v-icon>
                  </td>
                  <td>
                    <v-icon :color="item.alteracao_precos_etapa ? 'green' : 'red'">
                      {{ item.alteracao_precos_etapa ? "mdi-check-circle" : "mdi-close-circle" }}
                    </v-icon>
                  </td>
                  <td>
                    <v-icon :color="item.romaneio_etapa ? 'green' : 'red'">
                      {{ item.romaneio_etapa ? "mdi-check-circle" : "mdi-close-circle" }}
                    </v-icon>
                  </td>
                  <td>{{ item.protocolo_chave }}</td>
                </tr>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-tab-item>

      <v-tab-item>
        <v-card flat>
          <v-card-text>
            <v-data-table @click:row="capturarNota" :headers="headerNotasSefaz" :items="notas_sefaz" item-value="id" class="elevation-1"></v-data-table>
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs-items>
    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </v-card>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import ToastService from "@/infra/service/ToastService";

export default {
  inject: ["notaFiscalEntradaController"],
  components: {
    ConfirmDialog,
  },
  methods: {
    async desfazerNota() {
      await this.notaFiscalEntradaController.desfazerNota({ nota: this.notaSelecionada });
      await this.carregarNotas();
      ToastService.showSuccess("Nota Desfeita com sucesso !");
    },
    highlightRow(item) {
      return this.notaSelecionada && this.notaSelecionada.protocolo_chave === item.protocolo_chave ? "linha-selecionada" : "";
    },
    selecionarLinha(item) {
      this.notaSelecionada = this.notaSelecionada && this.notaSelecionada.protocolo_chave === item.protocolo_chave ? null : item;
    },
    async capturarNota(nota) {
      const confirmar = await this.$refs.confirmDialog.abrir(`Confirma Iniciar Entrada da Nota ?`, `Chave: ${nota.chave} , Fornecedor: ${nota.nome_fornecedor}`);
      if (!confirmar) return;

      await this.notaFiscalEntradaController.capturarNotaDaSefaz(nota.chave);
      this.$router.push(`/compra/recebimento/${nota.chave}`);
    },
    async abrirNota() {
      const confirmar = await this.$refs.confirmDialog.abrir(`Confirma Visualizar Nota ?`, `Chave: ${this.notaSelecionada.protocolo_chave} , Fornecedor: ${this.notaSelecionada.nome}`);
      if (!confirmar) return;

      this.$router.push(`/compra/recebimento/${this.notaSelecionada.protocolo_chave}`);
    },
    async carregarNotas() {
      const res_notas = await this.notaFiscalEntradaController.carregarNotas();
      const res_notas_sefaz = await this.notaFiscalEntradaController.carregarNotasSefaz();
      this.notas = res_notas.data;
      this.notas_sefaz = res_notas_sefaz.data;
      this.notaSelecionada = null;
    },
  },
  async mounted() {
    await this.carregarNotas();
  },
  data() {
    return {
      tab: 0, // índice da aba ativa
      notas: [],
      notas_sefaz: [],
      notaSelecionada: null,
      headerNotasSefaz: [
        { text: "CNPJ Fornecedor", value: "cnpjcpf_fornecedor" },
        { text: "Fornecedor", value: "nome_fornecedor" },
        { text: "CNPJ Dest.", value: "cnpjcpf" },
        { text: "Chave", value: "chave" },
      ],
      headerNotas: [
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Nome", value: "nome" },
        { text: "Emissão", value: "data_emissao" },
        { text: "Cód. Loja", value: "loja_id" },
        { text: "Série", value: "serie" },
        { text: "Núm. Nota", value: "nr_nota" },
        { text: "Total", value: "total_valor_produtos" },
        { text: "Etapa Estoque", value: "entrada_nota_etapa" },
        { text: "Etapa Financeiro", value: "lancamento_financeiro_etapa" },
        { text: "Etapa Preços", value: "alteracao_precos_etapa" },
        { text: "Etapa Romaneio", value: "romaneio_etapa" },
        { text: "Chave", value: "protocolo_chave" },
      ],
    };
  },
};
</script>

<style scoped>
.linha-selecionada {
  background-color: #e3f2fd !important;
}
/* Estilos personalizados, se necessário */
</style>
