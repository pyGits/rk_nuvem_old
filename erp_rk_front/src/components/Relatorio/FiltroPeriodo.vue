<template>
  <v-card outlined class="mb-4">
    <v-card-text class="pb-2">
      <v-row dense align="center">
        <v-col cols="12" sm="6" md="3">
          <v-menu v-model="menuInicio" :close-on-content-click="false" transition="scale-transition" offset-y min-width="auto">
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                :value="formatarData(dtInicio)"
                label="Data início"
                prepend-inner-icon="mdi-calendar-start"
                readonly
                dense
                outlined
                hide-details
                v-bind="attrs"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker
              :value="dtInicio"
              locale="pt-BR"
              no-title
              @input="
                atualizar('dtInicio', $event);
                menuInicio = false;
              "
            ></v-date-picker>
          </v-menu>
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-menu v-model="menuFim" :close-on-content-click="false" transition="scale-transition" offset-y min-width="auto">
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                :value="formatarData(dtFim)"
                label="Data fim"
                prepend-inner-icon="mdi-calendar-end"
                readonly
                dense
                outlined
                hide-details
                :error="periodoInvalido"
                v-bind="attrs"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker
              :value="dtFim"
              locale="pt-BR"
              no-title
              :min="dtInicio"
              @input="
                atualizar('dtFim', $event);
                menuFim = false;
              "
            ></v-date-picker>
          </v-menu>
        </v-col>

        <!-- Filtros específicos de cada relatório -->
        <slot></slot>
      </v-row>

      <v-row dense class="mt-1">
        <v-col cols="12">
          <v-chip
            v-for="atalho in atalhos"
            :key="atalho.label"
            small
            outlined
            class="mr-2 mb-1"
            :color="atalhoAtivo === atalho.label ? 'primary' : ''"
            @click="aplicarAtalho(atalho)"
          >
            {{ atalho.label }}
          </v-chip>
          <slot name="acoes-filtro"></slot>
        </v-col>
      </v-row>

      <v-alert v-if="periodoInvalido" type="warning" dense text class="mt-3 mb-0">
        A data fim é anterior à data início.
      </v-alert>
    </v-card-text>
  </v-card>
</template>

<script>
import { getCurrentDate } from "@/utils/date";

// Período dos relatórios: dois date pickers em pt-BR e atalhos para os
// intervalos mais usados. Usa o padrão .sync para as duas datas.
export default {
  name: "FiltroPeriodo",
  props: {
    dtInicio: { type: String, required: true },
    dtFim: { type: String, required: true },
    // Qual atalho nasce destacado. Relatórios que começam com um período
    // pronto usam o padrão; quem começa sem período passa "".
    atalhoInicial: { type: String, default: "Hoje" },
  },
  data() {
    return {
      menuInicio: false,
      menuFim: false,
      atalhoAtivo: this.atalhoInicial,
      atalhos: [
        { label: "Hoje", dias: 0 },
        { label: "Ontem", dias: 1, apenasDia: true },
        { label: "Últimos 7 dias", dias: 6 },
        { label: "Últimos 30 dias", dias: 29 },
        { label: "Este mês", mesAtual: true },
      ],
    };
  },
  computed: {
    periodoInvalido() {
      return !!this.dtInicio && !!this.dtFim && this.dtFim < this.dtInicio;
    },
  },
  methods: {
    formatarData(data) {
      if (!data) return "";
      const [ano, mes, dia] = String(data).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    atualizar(campo, valor) {
      this.atalhoAtivo = "";
      this.$emit(`update:${campo}`, valor);
      this.$emit("alterado");
    },
    aplicarAtalho(atalho) {
      const hoje = new Date();
      const iso = (d) => {
        const ano = d.getFullYear();
        const mes = String(d.getMonth() + 1).padStart(2, "0");
        const dia = String(d.getDate()).padStart(2, "0");
        return `${ano}-${mes}-${dia}`;
      };

      let inicio;
      let fim = getCurrentDate();

      if (atalho.mesAtual) {
        inicio = iso(new Date(hoje.getFullYear(), hoje.getMonth(), 1));
      } else if (atalho.apenasDia) {
        const dia = new Date(hoje);
        dia.setDate(dia.getDate() - atalho.dias);
        inicio = iso(dia);
        fim = iso(dia);
      } else {
        const d = new Date(hoje);
        d.setDate(d.getDate() - atalho.dias);
        inicio = iso(d);
      }

      this.$emit("update:dtInicio", inicio);
      this.$emit("update:dtFim", fim);
      this.atalhoAtivo = atalho.label;
      this.$emit("alterado");
    },
  },
};
</script>
