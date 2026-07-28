<template>
  <div style="min-width: 100px">
    <input @blur="$emit('blur', $event)" :disabled="disabled" type="text" @dragstart.prevent class="form-control" @focus="(event) => event.target.select()" @input="onInput" :value="maskedValue" :id="field" :class="[{ 'is-invalid': hasError(field) }, { 'font-weight-bold': bold }]" />
    <div v-if="hasError(field)" class="invalid-feedback">
      {{ getError(field) }}
    </div>
  </div>
</template>

<script>
import ErrorService from "@/infra/service/ErrorService";
export default {
  props: {
    disabled: {
      type: Boolean,
      required: false,
      default: false,
    },
    value: {
      type: [String, null, Object],
      required: false,
      default: "",
    },
    field: {
      type: String,
      required: false,
    },
    upperCase: {
      type: Boolean,
      required: false,
      default: false,
    },
    limit: {
      type: Number,
      required: false,
      default: 40,
    },
    bold: {
      // nova prop para negrito
      type: Boolean,
      required: false,
      default: false,
    },
  },

  computed: {
    maskedValue() {
      return this.applyMask(this.value); // Atualiza corretamente o input com base na prop 'value'
    },
    getError() {
      return (field) => ErrorService.getFirstErrorByField(field);
    },
    hasError() {
      return (field) => ErrorService.hasError(field);
    },
  },

  watch: {
    value(newValue) {
      // Quando o valor mudar no pai, atualiza o input
      this.$forceUpdate();
    },
  },

  methods: {
    applyMask(value) {
      let result = value || "";

      // Aplica limite de caracteres
      if (this.limit > 0) {
        result = result.slice(0, this.limit);
      }

      // Converte para maiúsculas se necessário
      if (this.upperCase) {
        result = result.toUpperCase();
      }

      return result;
    },

    removeMask(value) {
      return value;
    },

    onInput(event) {
      ErrorService.clearErrorByField(this.field);
      const masked = this.applyMask(event.target.value);
      event.target.value = masked;
      this.$emit("input", this.removeMask(masked)); // Emite o valor desformatado para o pai
    },
  },
};
</script>
