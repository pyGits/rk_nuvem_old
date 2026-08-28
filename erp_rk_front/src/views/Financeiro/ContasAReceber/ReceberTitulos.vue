<template>
  <div>
    <v-card>
      <v-card-title>Receber Títulos</v-card-title>

      <v-card-text>
        <v-data-table :headers="headers" :items="contas.items" :items-per-page="5" dense class="elevation-1">
          <template v-slot:item.dataVencimento="{ item }">
            {{ formatarData(item.dataVencimento) }}
          </template>
          <template v-slot:item.valor="{ item }">
            {{ maskMoney(item.valor) }}
          </template>
          <template v-slot:item.valorRecebido="{ item }">
            {{ maskMoney(item.valorRecebido()) }}
          </template>
          <template v-slot:item.valorAReceber="{ item }">
            {{ maskMoney(item.valorAReceber()) }}
          </template>
          <template v-slot:item.atraso="{ item }">
            <v-chip v-if="item.diasAtraso() > 0" x-small color="error" dark>{{ item.diasAtraso() }} dias</v-chip>
            <span v-else class="grey--text">-</span>
          </template>
        </v-data-table>
      </v-card-text>

      <v-card-text>
        <v-row>
          <v-col cols="12" sm="7">
            <v-card outlined>
              <v-card-title class="text-subtitle-1">Recebimento</v-card-title>
              <v-card-text>
                <v-row dense>
                  <v-col cols="12" sm="6">
                    <span class="text-caption grey--text">Forma de pagamento</span>
                    <v-autocomplete v-model="recebimento.formaPagamento" :items="formasPagamento" item-text="nome" item-value="codigo" outlined dense hide-details></v-autocomplete>
                  </v-col>
                  <v-col cols="12" sm="6">
                    <span class="text-caption grey--text">Data do recebimento</span>
                    <v-text-field v-model="recebimento.dataPagamento" type="date" outlined dense hide-details></v-text-field>
                  </v-col>
                </v-row>

                <v-row dense class="mt-2">
                  <v-col cols="12" sm="4">
                    <span class="text-caption grey--text">Juros</span>
                    <InputMoney v-model="recebimento.juros" @keyup="recalcularValor" />
                  </v-col>
                  <v-col cols="12" sm="4">
                    <span class="text-caption grey--text">Multa</span>
                    <InputMoney v-model="recebimento.multa" @keyup="recalcularValor" />
                  </v-col>
                  <v-col cols="12" sm="4">
                    <span class="text-caption grey--text">Desconto</span>
                    <InputMoney v-model="recebimento.desconto" @keyup="recalcularValor" />
                  </v-col>
                </v-row>

                <v-row dense class="mt-2">
                  <v-col cols="12" sm="6">
                    <span class="text-caption grey--text">Valor recebido (abate o título)</span>
                    <InputMoney v-model="recebimento.valor" />
                  </v-col>
                  <v-col cols="12" sm="6" class="d-flex align-end">
                    <v-btn text small color="primary" @click="receberTudo">
                      <v-icon left small>mdi-cash-check</v-icon>
                      Receber saldo total
                    </v-btn>
                  </v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>

          <v-col cols="12" sm="5">
            <v-card outlined>
              <v-card-title class="text-subtitle-1">Resumo</v-card-title>
              <v-card-text>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Valor dos títulos</span>
                  <span>{{ maskMoney(contas.valorTotal()) }}</span>
                </div>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Já recebido</span>
                  <span>{{ maskMoney(contas.valorRecebido()) }}</span>
                </div>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Saldo a receber</span>
                  <span class="font-weight-medium">{{ maskMoney(contas.valorReceber()) }}</span>
                </div>
                <v-divider class="my-2"></v-divider>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Abatimento (valor + desconto)</span>
                  <span>{{ maskMoney(abatimento) }}</span>
                </div>
                <div class="d-flex justify-space-between mb-1">
                  <span class="grey--text">Saldo após o recebimento</span>
                  <span :class="saldoRestante > 0 ? '' : 'success--text font-weight-bold'">{{ maskMoney(saldoRestante) }}</span>
                </div>
                <v-divider class="my-2"></v-divider>
                <div class="d-flex justify-space-between">
                  <span class="grey--text">Total em caixa (com juros/multa)</span>
                  <span class="font-weight-bold">{{ maskMoney(totalEmCaixa) }}</span>
                </div>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-card-text>

      <v-card-actions class="px-6 pb-4">
        <v-spacer></v-spacer>
        <v-btn outlined @click="$emit('fechar')">Cancelar</v-btn>
        <v-btn color="primary" @click="gravar">Gravar recebimento</v-btn>
      </v-card-actions>
    </v-card>

    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import ContaReceberTituloList from "@/infra/entity/ContaReceberTituloList";
import RecebimentoTitulo from "@/infra/entity/RecebimentoTitulo";
import ContaReceberService from "@/infra/service/ContaReceberService";
import FormaPagamentoService from "@/infra/service/FormaPagamentoService";
import { maskMoney, maskDateBR } from "@/utils/masks";
import { getCurrentDate } from "@/utils/date";

export default {
  name: "ReceberTitulos",
  components: { InputMoney, ConfirmDialog },
  data() {
    return {
      contas: new ContaReceberTituloList(),
      formasPagamento: [],
      recebimento: new RecebimentoTitulo(),
      headers: [
        { text: "Título", value: "codigo" },
        { text: "Parcela", value: "prestacao" },
        { text: "Vencimento", value: "dataVencimento" },
        { text: "Atraso", value: "atraso", sortable: false },
        { text: "Valor", value: "valor" },
        { text: "Recebido", value: "valorRecebido" },
        { text: "A receber", value: "valorAReceber" },
      ],
    };
  },
  computed: {
    abatimento() {
      return this.recebimento.abatimento();
    },
    saldoRestante() {
      const saldo = this.contas.valorReceber() - this.abatimento;
      return saldo > 0 ? saldo : 0;
    },
    totalEmCaixa() {
      return this.recebimento.valorEmCaixa();
    },
  },
  async mounted() {
    this.formasPagamento = await FormaPagamentoService.getAll();
  },
  methods: {
    maskMoney,
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    // Chamado pela listagem via $refs, no mesmo padrão do Contas a Pagar.
    abrir(titulos) {
      this.contas = titulos;
      this.recebimento = new RecebimentoTitulo();
      this.recebimento.dataPagamento = getCurrentDate();
      this.recebimento.formaPagamento = this.formasPagamento.length ? this.formasPagamento[0].codigo : "";
      this.receberTudo();
    },
    // O valor sugerido é o saldo menos o desconto: juros e multa são cobrados a
    // mais e não entram no abatimento.
    recalcularValor() {
      this.receberTudo();
    },
    receberTudo() {
      const valor = this.contas.valorReceber() - Number(this.recebimento.desconto || 0);
      this.recebimento.valor = valor > 0 ? Number(valor.toFixed(2)) : 0;
    },
    async gravar() {
      const confirmar = await this.$refs.confirmDialog.abrir("Confirmar recebimento dos títulos ?", "O estorno desfaz o lançamento, se precisar");
      if (!confirmar) return;

      // Repassa o recibo criado para a listagem abrir o comprovante.
      const recibo = await ContaReceberService.receber(this.contas, this.recebimento);
      this.$emit("gravar", recibo);
    },
  },
};
</script>
