<template>
  <v-dialog v-model="dialog" persistent max-width="600px">
    <v-card>
      <v-card-title class="headline">{{ title }}</v-card-title>
      <v-card-text>{{ message }}</v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="dialog = false">Não</v-btn>
        <v-btn color="green darken-1" text @click="confirm">Sim</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  computed: {
    dialog: {
      get() {
        return this.$store.state.Application.modalYesOrNo.show;
      },
      set(valor) {
        this.$store.commit("setDialogYesNoShow", valor);
      },
    },
    title: {
      get() {
        return this.$store.state.Application.modalYesOrNo.title;
      },
    },
    message: {
      get() {
        return this.$store.state.Application.modalYesOrNo.message;
      },
    },
    confirmAction: {
      get() {
        return this.$store.state.Application.modalYesOrNo.confirmAction;
      },
    },
  },
  methods: {
    confirm() {
      this.confirmAction();
      this.dialog = false;
    },
  },
};
</script>
