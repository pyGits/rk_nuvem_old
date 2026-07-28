<template>
  <div>
    <div style="min-width: 100px">
      <input :disabled="disabled" class="form-control" @input="onInput" @keyup="$emit('keyup', $event)" @focus="(event) => event.target.select()" @dragstart.prevent :value="maskedValue" inputmode="numeric" />
    </div>
  </div>
</template>

<script>
import ErrorService from "@/infra/service/ErrorService";

export default {
  props: ["value", "disabled"],

  computed: {
    maskedValue() {
      return this.applyMask(this.value);
    },
  },

  methods: {
    applyMask(value) {
      if (value === null || value === undefined || isNaN(value)) return "";

      const number = Number(value);
      return number.toLocaleString("pt-BR", {
        minimumFractionDigits: 3,
        maximumFractionDigits: 3,
      });
    },

    removeMask(value) {
      if (!value) return 0;

      const onlyNumbers = value.replace(/\D/g, "");
      const number = parseFloat(onlyNumbers) / 1000; // << AJUSTE AQUI
      return isNaN(number) ? 0 : number;
    },

    onInput(event) {
      ErrorService.clearErrorByField?.(this.field);
      const rawValue = event.target.value.replace(/\D/g, "");

      if (!rawValue) {
        event.target.value = "0,000";
        this.$emit("input", 0);
        return;
      }

      const numeric = parseFloat(rawValue) / 1000; // << AJUSTE AQUI
      const masked = this.applyMask(numeric);

      event.target.value = masked;
      this.$emit("input", numeric);
    },
  },
};
</script>
