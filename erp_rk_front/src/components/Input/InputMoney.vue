<template>
  <div>
    <div style="min-width: 100px">
      <input :disabled="disabled" class="form-control" @keyup="$emit('keyup', $event)" @dragstart.prevent @input="onInput" @focus="(event) => event.target.select()" :value="maskedValue" inputmode="numeric" :draggable="false" />
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
      required: true,
    },
  },

  computed: {
    maskedValue() {
      return this.applyMask(this.value);
    },
  },

  methods: {
    applyMask(value) {
      if (value === null || value === undefined || isNaN(value)) return "";

      const number = Number(value);

      return (
        "R$ " +
        number.toLocaleString("pt-BR", {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        })
      );
    },

    removeMask(value) {
      if (!value) return 0;

      // Remove tudo que não for número
      const onlyNumbers = value.replace(/\D/g, "");
      // Divide por 100 para obter valor com centavos
      const number = parseFloat(onlyNumbers) / 100;
      return isNaN(number) ? 0 : number;
    },

    onInput(event) {
      ErrorService.clearErrorByField(this.field);

      // Remove tudo que não for número
      const rawValue = event.target.value.replace(/\D/g, "");

      // Se não tiver números, define como 0
      if (!rawValue) {
        event.target.value = "0,00";
        this.$emit("input", 0);
        return;
      }

      const numeric = parseFloat(rawValue) / 100;
      const masked = this.applyMask(numeric);

      event.target.value = masked;
      this.$emit("input", numeric);
    },
  },
};
</script>
