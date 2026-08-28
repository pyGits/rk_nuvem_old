<template>
  <v-card>
    <v-card-title class="d-flex justify-space-between align-center">
      <span>Editar Título</span>
      <v-btn icon small @click="$emit('fechar')">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </v-card-title>

    <v-card-text>
      <v-row dense>
        <v-col cols="6" sm="3">
          <span class="text-caption grey--text">Título</span>
          <input class="form-control" disabled :value="titulo.codigo" />
        </v-col>
        <v-col cols="6" sm="2">
          <span class="text-caption grey--text">Parcela</span>
          <input class="form-control" disabled :value="titulo.prestacao" />
        </v-col>
        <v-col cols="12" sm="7">
          <span class="text-caption grey--text">Descrição</span>
          <InputText :disabled="somenteLeitura" v-model="titulo.descricao"></InputText>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" sm="3">
          <span class="text-caption grey--text">Valor do título</span>
          <InputMoney :disabled="somenteLeitura" v-model="titulo.valor"></InputMoney>
        </v-col>
        <v-col cols="12" sm="3">
          <span class="text-caption grey--text">Já recebido</span>
          <InputMoney disabled :value="titulo.valorRecebido()"></InputMoney>
        </v-col>
        <v-col cols="12" sm="3">
          <span class="text-caption grey--text">Vencimento</span>
          <v-text-field :disabled="somenteLeitura" v-model="titulo.dataVencimento" type="date" outlined dense hide-details></v-text-field>
        </v-col>
      </v-row>

      <v-alert v-if="somenteLeitura" type="info" dense text class="mt-4 mb-0">{{ motivoBloqueio }}</v-alert>
    </v-card-text>

    <v-card-actions class="px-6 pb-4">
      <v-spacer></v-spacer>
      <v-btn outlined @click="$emit('fechar')">Fechar</v-btn>
      <v-btn color="primary" :disabled="somenteLeitura" @click="gravar">Gravar</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import InputMoney from "@/components/Input/InputMoney.vue";
import InputText from "@/components/Input/InputText.vue";
import ContaReceberTitulo from "@/infra/entity/ContaReceberTitulo";
import ContaReceberTituloListFactory from "@/infra/entity/factory/ContaReceberTituloListFactory";
import ContaReceberService from "@/infra/service/ContaReceberService";

export default {
  name: "EditarTituloReceber",
  components: { InputText, InputMoney },
  data() {
    return {
      titulo: new ContaReceberTitulo(),
    };
  },
  computed: {
    // Título liquidado também trava: mudar o valor de um título já baixado
    // deixaria o recebimento gravado sem relação com o que ele quitou. O
    // Contas a Pagar já bloqueia qualquer status diferente de ABERTO.
    somenteLeitura() {
      return this.titulo.cancelado === 1 || this.titulo.status !== "ABERTO";
    },
    motivoBloqueio() {
      if (this.titulo.cancelado === 1) return "Título cancelado não pode ser alterado.";
      return "Título liquidado não pode ser alterado. Estorne o recebimento antes.";
    },
  },
  methods: {
    // Chamado pela listagem via $refs. Recria a entidade para não editar o
    // objeto que está na grid enquanto o usuário digita.
    abrir(titulo) {
      const [copia] = ContaReceberTituloListFactory.createList([JSON.parse(JSON.stringify(titulo))]).items;
      copia.dataVencimento = String(copia.dataVencimento || "").substring(0, 10);
      this.titulo = copia;
    },
    async gravar() {
      await ContaReceberService.update(this.titulo);
      this.$emit("gravar");
    },
  },
};
</script>
