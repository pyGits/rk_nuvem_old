<template>
  <v-dialog v-model="dialog" max-width="800">
    <v-card>
      <v-card-title class="headline">{{ titulo }}</v-card-title>
      <v-card-text>{{ mensagem }}</v-card-text>
      <v-card-actions class="justify-end">
        <v-btn text color="grey" @click="responder(false)">Não</v-btn>
        <v-btn text color="primary" @click="responder(true)">Sim</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      resolve: null,
      titulo: "Confirmar",
      mensagem: "Tem certeza que deseja continuar?",
    };
  },
  methods: {
    abrir(titulo = "Confirmar", mensagem = "Tem certeza?") {
      this.titulo = titulo;
      this.mensagem = mensagem;
      this.dialog = true;

      return new Promise((resolve) => {
        this.resolve = resolve;
      });
    },
    responder(valor) {
      this.dialog = false;
      if (this.resolve) this.resolve(valor);
    },
  },
};
</script>
