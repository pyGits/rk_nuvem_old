<template>
  <v-container>
    <v-stepper v-model="step" non-linear>
      <!-- Cabeçalho dos passos -->
      <v-stepper-header>
        <v-stepper-step :complete="step > 1" step="1">Entrada de Nota</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 2" step="2">Distribuição</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 3" step="3">Lançamento Financeiro</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 4" step="4">Alteração de Preços</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 5" step="5">Romaneio</v-stepper-step>
      </v-stepper-header>

      <v-stepper-items>
        <!-- Etapa 1 -->
        <v-stepper-content step="1" :transition="false">
          <v-card-actions class="justify-end mt-4">
            <v-btn color="primary" @click="avancarWizard">Próximo</v-btn>
          </v-card-actions>
          <v-card-actions class="justify-end mt-4">
            <!-- <v-btn color="primary" @click="$refs.xmlFile.click()">📁 Selecionar XML</v-btn> -->
            <!-- <input id="xmlFile" ref="xmlFile" type="file" class="d-none" accept=".xml" @change="enviarXML" /> -->
          </v-card-actions>
          <RecebimentoXML ref="entradaNota"></RecebimentoXML>
        </v-stepper-content>

        <!-- Etapa 2 - Distribuição -->
        <v-stepper-content step="2" :transition="false">
          <v-card-actions class="justify-end mt-4">
            <v-btn text @click="step--">Voltar</v-btn>
            <v-btn color="primary" @click="avancarWizard">Próximo</v-btn>
          </v-card-actions>
          <DistribuicaoEstoque ref="distribuicao"></DistribuicaoEstoque>
        </v-stepper-content>

        <!-- Etapa 3 -->
        <v-stepper-content step="3" :transition="false">
          <v-card-actions class="justify-end mt-4">
            <v-btn text @click="step--">Voltar</v-btn>
            <v-btn text @click="avancarWizard(false)">Pular Etapa</v-btn>
            <v-btn color="primary" @click="avancarWizard">Próximo</v-btn>
          </v-card-actions>
          <EditarContasAPagar ref="contasPagar"></EditarContasAPagar>
        </v-stepper-content>

        <!-- Etapa 4 -->
        <v-stepper-content step="4" :transition="false">
          <v-card-actions class="justify-end mt-4">
            <v-btn text @click="step--">Voltar</v-btn>
            <v-btn color="primary" @click="avancarWizard">Próximo</v-btn>
          </v-card-actions>
          <PrecosNota ref="precosNota"></PrecosNota>
        </v-stepper-content>

        <!-- Etapa 5 -->
        <v-stepper-content step="5" :transition="false">
          <v-card-actions class="justify-end mt-4">
            <v-btn text @click="step--">Voltar</v-btn>
            <v-btn color="success" @click="avancarWizard">Finalizar</v-btn>
          </v-card-actions>
          <v-card class="pa-4" outlined>
            <TransportadoraSelector ref="transportadoraSelector"></TransportadoraSelector>
          </v-card>
        </v-stepper-content>
        <!-- Etapa 6 - Finalizado -->
        <v-stepper-content step="6" :transition="false">
          <v-card class="pa-4" outlined>
            <v-row align="center" justify="center">
              <v-col cols="12" class="text-center">
                <v-icon color="success" large>mdi-check-circle</v-icon>
                <h3 class="mt-2">Processo finalizado com sucesso!</h3>
                <p>Você concluiu todas as etapas da Entrada de Nota.</p>
                <v-btn color="primary" class="mr-2" @click="step--">Voltar</v-btn>
                <v-btn color="primary" @click="resetWizard">Nova Nota</v-btn>
              </v-col>
            </v-row>
          </v-card>
        </v-stepper-content>
      </v-stepper-items>
    </v-stepper>
    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </v-container>
</template>

<script>
import ContaPagarFactory from "@/infra/entity/factory/ContaPagarFactory";
import PrecosNota from "../Recebimento/PrecosNota.vue";
import RecebimentoXML from "../Recebimento/RecebimentoXML.vue";
import EditarContasAPagar from "@/views/Financeiro/ContasAPagar/EditarContasAPagar.vue";
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import ToastService from "@/infra/service/ToastService";
import PDFService from "@/infra/service/PDFService";
import TransportadoraSelector from "@/atomic/Transportadora/TransportadoraSelector.vue";
import DistribuicaoEstoque from "./DistribuicaoEstoque.vue";
export default {
  inject: ["notaFiscalEntradaController"],
  data() {
    return {
      step: 1,
      form: {
        transportadora: "",
        observacoes: "",
      },
    };
  },
  async mounted() {
    if (this.$route.params.chave.toUpperCase() !== "MANUAL") {
      await this.carregarNota(this.$route.params.chave);
      await this.carregarStep();
    }
  },
  methods: {
    resetWizard() {
      window.location.href = "/compra/recebimento";
    },
    async avancarWizard(skip = false) {
      if (this.step === 1) {
        // Só avança para a Distribuição se a entrada da nota estiver válida.
        const nota = this.$refs.entradaNota.nota_fiscal;
        if (this.$route.params.chave.toUpperCase() === "MANUAL") {
          nota.notaManual = true;
        }
        try {
          nota.validate();
        } catch (e) {
          ToastService.showError(e.message || "Verifique os dados da entrada da nota.");
          return;
        }
        await this.$refs.distribuicao.carregar(nota);
      }
      if (this.step === 2) {
        // Efetiva a entrada com a distribuição de estoque por loja.
        if (!this.$refs.distribuicao.validar()) return;
        const nota = this.$refs.entradaNota.nota_fiscal;
        if (this.$route.params.chave.toUpperCase() === "MANUAL") {
          nota.notaManual = true;
        }
        await this.notaFiscalEntradaController.avancarWizard({ etapa: "ENTRADA", nota });
      }
      if (this.step === 3) {
        const nota = this.$refs.entradaNota.nota_fiscal;
        this.carregarPrecos();
        if (skip) {
          const confirmar = await this.$refs.confirmDialog.abrir("Confirma Lançar Contas a Pagar ?", "Operação não pode ser desfeita");
          if (confirmar) {
            await this.$refs.contasPagar.gravar();
            await this.notaFiscalEntradaController.avancarWizard({ etapa: "FINANCEIRO", nota });
          } else {
            return;
          }
        }
      }
      if (this.step === 4) {
        const nota = this.$refs.entradaNota.nota_fiscal;
        await this.notaFiscalEntradaController.avancarWizard({ etapa: "PRECOS", nota });
      }
      if (this.step === 5) {
        const nota = this.$refs.entradaNota.nota_fiscal;
        nota.transportadora = this.$refs.transportadoraSelector.transportadora;
        const res = await this.notaFiscalEntradaController.avancarWizard({ etapa: "ROMANEIO", nota });
        PDFService.exibirPDF(res.romaneio);
      }
      this.carregarInterface();
      this.step++;
    },
    async carregarStep() {
      const nota = this.$refs.entradaNota.nota_fiscal;
      // Nota ainda não efetivada: começa na Entrada (etapas 1 e 2 ocorrem antes da efetivação).
      if (!nota.entrada_nota_etapa) {
        this.step = 1;
        return;
      }
      if (!nota.lancamento_financeiro_etapa) {
        this.step = 3;
        return;
      }
      if (!nota.alteracao_precos_etapa) {
        this.step = 4;
        return;
      }
      if (!nota.romaneio_etapa) {
        this.step = 5;
        return;
      }
      this.step = 5;
      return;
    },
    async carregarNota(chave) {
      const res = await this.notaFiscalEntradaController.getByChave({ chave_nota: chave });
      this.$refs.entradaNota.produtos = res.produtos;
      this.$refs.entradaNota.nota_fiscal = res.nota;
      this.$refs.entradaNota.nota_fiscal.fornecedor = res.fornecedor;
      this.$refs.transportadoraSelector.transportadora = res.nota.transportadora;
      this.carregarInterface();
    },
    async enviarXML(event) {
      const file = event.target.files[0];
      const res = await this.notaFiscalEntradaController.ImportarXMLDiretorio({ arquivo: file });
      const chave = res.data.nota.protocolo.chave;
      this.$router.push(`/compra/recebimento/${chave}`);
      this.$refs.entradaNota.produtos = res.data.produtos;
      this.$refs.entradaNota.nota_fiscal = res.data.nota;
      this.$refs.entradaNota.fornecedor = res.data.fornecedor;

      ToastService.showSuccess(res.message);
    },

    carregarInterface() {
      this.carregarFinanceiro();
      this.carregarPrecos();
    },
    carregarPrecos() {
      const nota = this.$refs.entradaNota.nota_fiscal;
      this.$refs.precosNota.abrir(nota);
    },
    carregarFinanceiro() {
      const nota_fiscal = this.$refs.entradaNota.nota_fiscal;
      const fornecedor = this.$refs.entradaNota.fornecedor;
      const conta = ContaPagarFactory.createFromNota(nota_fiscal, fornecedor);
      this.$refs.contasPagar.abrir(conta);
    },
  },
  components: {
    TransportadoraSelector,
    RecebimentoXML,
    EditarContasAPagar,
    PrecosNota,
    ConfirmDialog,
    DistribuicaoEstoque,
  },
};
</script>
