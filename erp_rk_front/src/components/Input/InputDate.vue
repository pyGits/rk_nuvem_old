<template>
  <div>
    <input :disabled="disabled" type="date" class="form-control" :value="formattedValue" :id="field" :class="{ 'is-invalid': hasError(field) }" @input="onInput" @blur="validateDate" />

    <div v-if="hasError(field)" class="invalid-feedback">
      {{ getError(field) }}
    </div>
  </div>
</template>

<script>
import ErrorService from "@/infra/service/ErrorService";
import ToastService from "@/infra/service/ToastService";

export default {
  props: {
    disabled: {
      type: Boolean,
      default: false,
    },
    value: {
      type: Date,
      required: true,
    },
    field: {
      type: String,
      required: false,
    },
  },
  data() {
    return {
      internalValue: this.value ? this.formatDate(this.value) : "", // controla o valor do input
    };
  },
  watch: {
    value(newVal) {
      this.internalValue = newVal ? this.formatDate(newVal) : "";
    },
  },
  computed: {
    formattedValue() {
      return this.internalValue;
    },
    getError() {
      return (field) => ErrorService.getFirstErrorByField(field);
    },
    hasError() {
      return (field) => ErrorService.hasError(field);
    },
  },
  methods: {
    validateDate() {
      const date = this.parseDate(this.internalValue);

      const isValid = date instanceof Date && !isNaN(date.getTime()) && date.getFullYear() >= 1980;

      const finalDate = isValid ? date : new Date();

      // Ajuste da hora para evitar problemas de fuso horário
      finalDate.setHours(12, 0, 0, 0);

      // Emite a data válida somente no blur
      this.$emit("input", finalDate);
      this.$emit("typing");
    },
    formatDate(date) {
      // Formata para 'YYYY-MM-DD'
      return date.toISOString().substr(0, 10);
    },
    parseDate(value) {
      if (value) {
        // Ajuste adicionando 'T12:00:00' para evitar problemas de fuso
        const date = new Date(value + "T12:00:00");
        console.log("parseDate:", date);
        return date;
      } else {
        ToastService.showError("Data inválida!");
        return new Date();
      }
    },
    onInput(event) {
      this.internalValue = event.target.value;
      // Não emitimos aqui!
    },
  },
};
</script>
