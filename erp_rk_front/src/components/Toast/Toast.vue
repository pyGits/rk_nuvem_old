<template>
  <div>
    <v-snackbar v-model="snackbar" :timeout="timeout">{{ message }}</v-snackbar>
  </div>
</template>

<script>
export default {
  data() {
    return {
      timeout: 3000, // tempo em milissegundos para que o toast desapareça
    };
  },
  computed: {
    snackbar: {
      get() {
        return this.$store.state.Application.toast.show;
      },
      set(valor) {
        this.$store.commit("setToastShow", valor);
      },
    },
    message: {
      get() {
        return this.$store.state.Application.toast.message;
      },
      set(valor) {
        this.$store.commit("setToastMessage", valor);
      },
    },
  },
  watch: {
    snackbar(newVal, oldVal) {
      if (newVal === false) {
        this.message = "";
      }
    },
  },
};
</script>

<style lang="scss" scoped></style>
