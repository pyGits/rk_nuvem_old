<template>
  <div>
    <v-data-table
      :items-per-page="10"
      :items="sangriaListMasked"
      :headers="headers"
      id="tableSangria"
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
    sangriaListMasked() {
      return this.sangriaList.map((sangria) => {
        return { ...sangria, Valor: maskMoney(sangria.Valor) };
      });
    },
    sangriaList: {
      get() {
        return this.$store.state.naofiscal.sangriaList;
      },
    },
  },
};
</script>

<style lang="scss" scoped></style>
