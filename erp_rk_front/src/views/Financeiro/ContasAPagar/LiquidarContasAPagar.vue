<template>
  <div>
    <v-card>
      <v-card-title>Liquidar Títulos</v-card-title>
      <v-card-text>
        <v-data-table
          :headers="[
            { text: 'Parcela', value: 'seq' },
            { text: 'Nº Doc', value: 'numeroDocumento' },
            { text: 'Vlr Título', value: 'valor' },
            { text: 'Vlr Pago', value: 'valorPago' },
            { text: 'Vencimento', value: 'vencimento' },
          ]"
          :items="contas.items"
        >
          <template v-slot:item.valor="{ item }">
            <InputMoney :value="item.valor" disabled></InputMoney>
          </template>
          <template v-slot:item.valorPago="{ item }">
            <InputMoney :value="item.valorPago" disabled></InputMoney>
          </template>
          <template v-slot:item.vencimento="{ item }">
            <InputDate :value="item.vencimento" disabled></InputDate>
          </template>
        </v-data-table>
      </v-card-text>
      <v-card-text>
        <v-row>
          <v-col col="12" sm="6">
            <v-card>
              <v-card-title>Pagamentos:</v-card-title>
              <v-card-text>
                <v-row>
                  <span>Forma Pagamento</span>
                  <v-col cols="12"><v-autocomplete :items="pagamentos" v-model="pagamento.formaPagamento" item-text="nome" return-object></v-autocomplete></v-col>
                </v-row>
                <v-row>
                  <span>Valor Pagamento:</span>
                  <v-col cols="12"><InputMoney v-model="pagamento.valor"></InputMoney> </v-col>
                </v-row>
                <v-row>
                  <v-btn color="primary" @click="registrarPagamento">Registrar</v-btn>
                </v-row>
                <v-row>
                  <v-data-table
                    :items="pagamentos_registrados"
                    :headers="[
                      { text: 'Forma', value: 'nome' },
                      { text: 'Valor', value: 'valor' },
                    ]"
                  >
                    <template v-slot:item.valor="{ item }">
                      <InputMoney disabled :value="item.valor" />
                    </template>
                    <template v-slot:item.nome="{ item }">
                      <InputText disabled :value="item.formaPagamento.nome" />
                    </template>
                  </v-data-table>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>
          <v-col col="12" sm="6">
            <v-card>
              <v-card-title>Resumo:</v-card-title>
              <v-card-text>
                <v-row>
                  <span>Total A Receber:</span>
                  <InputMoney :value="contas.valorReceber()"></InputMoney>
                </v-row>
                <v-row>
                  <span>Total Pago:</span>
                  <InputMoney :value="contas.valorPago()"></InputMoney>
                </v-row>
                <v-row>
                  <span>Valor Títulos:</span>
                  <InputMoney :value="contas.valorTotal()"></InputMoney>
                </v-row>
                <v-divider></v-divider>
                <v-row><v-btn color="primary" @click="gravarPagamentos">Gravar</v-btn></v-row>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import InputDate from "@/components/Input/InputDate.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import InputText from "@/components/Input/InputText.vue";
import ContaPagarTituloList from "@/infra/entity/ContaPagarTituloList";
import ContaPagarTituloListFactory from "@/infra/entity/factory/ContaPagarTituloListFactory";
import PagamentoTitulo from "@/infra/entity/PagamentoTitulo";
import ContaPagarService from "@/infra/service/ContaPagarService";
import FormaPagamentoService from "@/infra/service/FormaPagamentoService";

export default {
  async mounted() {
    this.contas = new ContaPagarTituloList();
    this.pagamentos = await FormaPagamentoService.getAll();
    this.pagamento.formaPagamento = this.pagamentos[0];
  },
  methods: {
    abrir(list) {
      this.contas = ContaPagarTituloListFactory.createList(list);
      this.pagamentos_registrados = [];
      this.pagamento.valor = this.contas.valorReceber();
    },
    registrarPagamento() {
      this.contas.registrarPagamento(this.pagamento);
      this.pagamentos_registrados.push(new PagamentoTitulo(this.pagamento.valor, this.pagamento.formaPagamento));
      this.pagamento = new PagamentoTitulo();
      this.pagamento.valor = this.contas.valorReceber();
      this.pagamento.formaPagamento = this.pagamentos[0];
    },
    async gravarPagamentos() {
      const confirmar = await this.$refs.confirmDialog.abrir("Confirmar Pagar Títulos ?", "Operação não pode ser desfeita");
      if (confirmar) {
        await ContaPagarService.liquidarTitulos(this.contas);
        this.$emit("gravar");
      }
    },
  },
  data() {
    return {
      pagamentos: [],
      pagamento: new PagamentoTitulo(),
      pagamentos_registrados: [],
      contas: new ContaPagarTituloList(),
    };
  },
  components: {
    InputMoney,
    InputText,
    ConfirmDialog,
    InputDate,
  },
};
</script>

<style lang="scss" scoped></style>
