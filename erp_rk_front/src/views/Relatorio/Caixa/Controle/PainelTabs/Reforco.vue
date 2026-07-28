<template>
  <div>
    <v-data-table
      :items-per-page="10"
      :items="reforcoListMasked"
      :headers="headers"
      id="tableReforco"
      class="elevation-1"
    ></v-data-table>
  </div>
</template>

<script>
import { maskMoney } from "@/utils/masks";

export default {
  data() {
    return {
      headers: [
        { text: "Cód. Loja", value: "Loja.codigo" },
        { text: "Loja", value: "Loja.nome" },
        { text: "Cód. Fun", value: "Funcionario.codigo" },
        { text: "Funcionário", value: "Funcionario.nome" },
        { text: "Cód. Fin", value: "Finalizadora.codigo" },
        { text: "Finalizadora", value: "Finalizadora.nome" },
        { text: "Data", value: "data" },
        { text: "Hora", value: "Hora" },
        { text: "Valor", value: "Valor" },
      ],
    };
  },
  computed: {
    reforcoListMasked() {
      return this.reforcoList.map((reforco) => {
        console.log(reforco);
        return { ...reforco, Valor: maskMoney(reforco.Valor) };
      });
    },
    reforcoList: {
      get() {
        return this.$store.state.naofiscal.reforcoList;
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
