<template>
  <v-container>
    <v-stepper v-model="step" non-linear flat>
      <!-- Cabeçalho dos passos -->
      <v-stepper-header>
        <v-stepper-step :complete="step > 1" step="1">Entrada de Nota</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 2" step="2">Lançamento Financeiro</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step :complete="step > 3" step="3">Alteração de Preços</v-stepper-step>
        <v-divider></v-divider>

        <v-stepper-step step="4">Romaneio</v-stepper-step>
      </v-stepper-header>

      <v-stepper-items>
        <!-- Etapa 1 -->
        <v-stepper-content step="1" :transition="false">
          <v-card class="pa-4" outlined>
            <v-text-field label="Número da Nota" v-model="form.numeroNota" />
            <v-text-field label="Data de Emissão" v-model="form.dataEmissao" />
            <v-card-actions class="justify-end">
              <v-btn color="primary" @click="step++">Próximo</v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>

        <!-- Etapa 2 -->
        <v-stepper-content step="2" :transition="false">
          <v-card class="pa-4" outlined>
            <v-text-field label="Forma de Pagamento" v-model="form.pagamento" />
            <v-text-field label="Valor Total" v-model="form.valorTotal" />
            <v-card-actions class="justify-space-between">
              <v-btn text @click="step--">Voltar</v-btn>
              <v-btn color="primary" @click="step++">Próximo</v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>

        <!-- Etapa 3 -->
        <v-stepper-content step="3" :transition="false">
          <v-card class="pa-4" outlined>
            <v-text-field label="Produto" v-model="form.produto" />
            <v-text-field label="Novo Preço" v-model="form.preco" />
            <v-card-actions class="justify-space-between">
              <v-btn text @click="step--">Voltar</v-btn>
              <v-btn color="primary" @click="step++">Próximo</v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>

        <!-- Etapa 4 -->
        <v-stepper-content step="4" :transition="false">
          <v-card class="pa-4" outlined>
            <v-text-field label="Transportadora" v-model="form.transportadora" />
            <v-textarea label="Observações" v-model="form.observacoes" />
            <v-card-actions class="justify-space-between">
              <v-btn text @click="step--">Voltar</v-btn>
              <v-btn color="success" @click="finalizar">Finalizar</v-btn>
            </v-card-actions>
          </v-card>
        </v-stepper-content>
      </v-stepper-items>
    </v-stepper>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      step: 1,
      form: {
        numeroNota: "",
        dataEmissao: "",
        pagamento: "",
        valorTotal: "",
        produto: "",
        preco: "",
        transportadora: "",
        observacoes: "",
      },
    };
  },
  methods: {
    finalizar() {
      alert("Processo finalizado!");
    },
  },
};
</script>
