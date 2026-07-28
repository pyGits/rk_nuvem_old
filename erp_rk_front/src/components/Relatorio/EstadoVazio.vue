<template>
  <div class="text-center py-12 grey--text">
    <v-icon size="56" color="grey lighten-1">{{ icone }}</v-icon>
    <p class="mt-3 mb-0">{{ mensagem }}</p>
  </div>
</template>

<script>
// Mostrado no lugar da tabela quando a consulta não retorna linhas, para não
// deixar a tela em branco sem explicação.
export default {
  name: "EstadoVazio",
  props: {
    mensagem: { type: String, default: "Nenhum resultado para os filtros selecionados." },
    icone: { type: String, default: "mdi-database-off-outline" },
  },
};
</script>
