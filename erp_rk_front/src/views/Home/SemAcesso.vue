<template>
  <v-card flat class="pa-8 text-center">
    <v-icon size="56" color="grey lighten-1">mdi-lock-outline</v-icon>
    <h2 class="text-h6 mt-4 mb-2">Nenhuma tela liberada para o seu usuário</h2>
    <p class="text-body-2 grey--text text--darken-1 mb-0">
      Peça ao responsável pela empresa para liberar os seus acessos em
      <strong>Usuários &rsaquo; Usuários WEB</strong>, na aba <strong>Acessos</strong>.
    </p>
  </v-card>
</template>

<script>
// Onde cai quem esta logado e nao tem nenhuma tela marcada - o caso do usuario
// recem-criado, que nasce sem acesso nenhum. Sem esta tela o login mandaria
// para "/" (que ele tambem nao pode abrir) e a navegacao entraria em loop.
export default {
  name: "SemAcesso",
};
</script>
