<template>
  <div class="input-group">
    <input :disabled="disabled" ref="input" type="text" class="form-control" @focus="(event) => event.target.select()" @input="onInput" @keyup="$emit('keyup', $event)" :value="maskedValue" :id="field" :class="{ 'is-invalid': hasError(field) }" @blur="$emit('blur', $event)" />
    <button v-if="searchEnabled" class="btn btn-outline-secondary" type="button" @click="buscar">
      <i class="mdi mdi-magnify"></i>
    </button>
    <div v-if="hasError(field)" class="invalid-feedback">
      {{ getError(field) }}
    </div>
  </div>
</template>

<script>
import ErrorService from "@/infra/service/ErrorService";

export default {
  props: {
    searchEnabled: {
      type: Boolean,
      required: false,
      default: false,
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false,
    },
    value: {
      type: null,
      required: true,
    },
    field: {
      type: String,
      required: false,
    },
    limit: {
      type: Number,
      required: false,
    },
  },

  computed: {
    maskedValue() {
      return this.applyMask(this.value);
    },
    getError() {
      return (field) => ErrorService.getFirstErrorByField(field);
    },
    hasError() {
      return (field) => ErrorService.hasError(field);
    },
  },

  watch: {
    value() {
      this.$forceUpdate(); // Garante que o input será atualizado quando a prop mudar
    },
  },

  methods: {
    focus() {
      this.$refs.input?.focus(); // garante que o ref existe antes de chamar focus
    },
    buscar() {
      this.$emit("buscar");
    },
    applyMask(value) {
      let result = String(value || "");

      // Remove tudo que não for dígito
      result = result.replace(/\D/g, "");

      // Aplica limite de caracteres
      if (this.limit > 0) {
        result = result.slice(0, this.limit);
      }

      return result;
    },

    removeMask(value) {
      return value;
    },

    onInput(event) {
      const masked = this.applyMask(event.target.value);
      event.target.value = masked;
      this.$emit("input", this.removeMask(masked));
    },
  },
};
</script>
