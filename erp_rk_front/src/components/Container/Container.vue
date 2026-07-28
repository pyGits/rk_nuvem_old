<template>
  <v-main>
    <v-container>
      <v-overlay :value="loading">
        <v-progress-circular indeterminate size="64" color="primary" class="overlay-spinner"></v-progress-circular>
      </v-overlay>
      <slot></slot>
    </v-container>
  </v-main>
</template>

<script>
export default {
  computed: {
    loading: {
      get() {
        return this.$store.state.Application.containerLoading;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.overlay-spinner {
  position: absolute;
  top: calc(50% - 32px); /* metade da altura do elemento */
  left: calc(50% - 32px); /* metade da largura do elemento */
}
</style>
