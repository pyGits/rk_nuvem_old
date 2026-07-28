<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="fechamentoListMasked"
      :items-per-page="10"
      id="tableFechamento"
      @click:row="getFechamento"
      class="elevation-1"
    ></v-data-table>
    <v-data-table
      :headers="headersForma"
      :items="fechamentoFormaListMasked"
      :items-per-page="10"
      id="tableFechamento"
      class="elevation-1"
    ></v-data-table>
  </div>
</template>

<script>
import { maskMoney, maskDateBR } from "@/utils/masks";

export default {
  mounted() {
    this.fechamentoList = [];
    this.fechamentoFormaList = [];
  },
  data() {
    return {
      headers: [
        { text: "Caixa", value: "codCaixa" },
        { text: "Loja", value: "loja" },
        { text: "Cód. Op.", value: "codOperador" },
        { text: "Operador", value: "operador" },
        { text: "Dt Abertura", value: "dataAbertura" },
        { text: "Hr Abertura", value: "horaAbertura" },
        { text: "Dt Fechamento", value: "dataFechamento" },
        { text: "Hr Fechamento", value: "horaFechamento" },
        { text: "Vd. Bruta", value: "vendaBruta" },
        { text: "Cancelamento Cupom", value: "cancelamentoCupom" },
        { text: "Cancelamento Item", value: "cancelamentoItem" },
        { text: "Desconto Item", value: "descontoItem" },
        { text: "Desconto Cupom", value: "descontoCupom" },
        { text: "Venda Líquida", value: "vendaLiquida" },
        { text: "Reforço Caixa", value: "fundoCaixa" },
        { text: "Sangria", value: "sangria" },
      ],
      headersForma: [
        { text: "Loja", value: "loja" },
        { text: "Caixa", value: "cod_caixa" },
        { text: "Cód Fin", value: "codigo" },
        { text: "Finalizadora", value: "nome" },
        { text: "Vlr. Líquido", value: "valor_liquido" },
        { text: "Vlr. Troco", value: "valor_troco" },
        { text: "Vlr. Reforço", value: "valor_reforco" },
        { text: "Vlr. Sangria", value: "valor_sangria" },
        { text: "Vlr. Conferência", value: "valor_conferencia" },
        { text: "Vlr. Total", value: "valor_total" },
      ],
    };
  },
  methods: {
    async getFechamento(fechamento) {
      const fechamentoParams = {
        codCaixa: fechamento.codCaixa,
        codigo: fechamento.codigo,
        id: fechamento.id,
      };
      this.$store.dispatch("getFechamentoFormas", fechamentoParams);
    },
  },
  computed: {
    fechamentoListMasked() {
      return this.fechamentoList.map((fechamento) => {
        return {
          ...fechamento,
          vendaBruta: maskMoney(fechamento.vendaBruta),
          cancelamentoCupom: maskMoney(fechamento.cancelamentoCupom),
          cancelamentoItem: maskMoney(fechamento.cancelamentoItem),
          descontoItem: maskMoney(fechamento.descontoItem),
          descontoCupom: maskMoney(fechamento.descontoCupom),
          vendaLiquida: maskMoney(fechamento.vendaLiquida),
          fundoCaixa: maskMoney(fechamento.fundoCaixa),
          sangria: maskMoney(fechamento.sangria),
          dataAbertura: maskDateBR(fechamento.dataAbertura),
          dataFechamento: maskDateBR(fechamento.dataFechamento),
        };
      });
    },
    fechamentoFormaListMasked() {
      return this.fechamentoFormaList.map((forma) => {
        return {
          ...forma,
          valor_liquido: maskMoney(forma.valor_liquido),
          valor_troco: maskMoney(forma.valor_troco),
          valor_reforco: maskMoney(forma.valor_reforco),
          valor_sangria: maskMoney(forma.valor_sangria),
          valor_conferencia: maskMoney(forma.valor_conferencia),
          valor_total: maskMoney(forma.valor_total),
        };
      });
    },
    fechamentoList: {
      get() {
        return this.$store.state.fechamento.fechamentoList;
      },
      set(valor) {
        this.$store.commit("setFechamentoList", valor);
      },
    },
    fechamentoFormaList: {
      get() {
        return this.$store.state.fechamento.fechamentoFormaList;
      },
      set(valor) {
        this.$store.commit("setFechamentoFormaList", valor);
      },
    },
  },
};
</script>

<style lang="scss" scoped>
#tableFechamento {
  cursor: pointer;
}
</style>
