<template>
  <div>
    <v-card
      ><v-card-title>Editar Título</v-card-title>

      <v-card-text>
        <v-row>
          <v-col cols="12" sm="1">
            <label class="form-label" for="input-example">Parcela:</label>
            <input class="form-control" disabled v-model="titulo.seq" />
          </v-col>
          <v-col cols="12" sm="4">
            <label class="form-label" for="input-example">Descrição:</label>
            <InputText :disabled="editMode" v-model="titulo.descricao"></InputText>
          </v-col>
          <v-col cols="12" sm="4">
            <label class="form-label" for="input-example">Número Documento:</label>
            <InputText :disabled="editMode" v-model="titulo.numeroDocumento"></InputText>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Título:</label>
            <InputMoney :disabled="editMode" v-model="titulo.valor"></InputMoney>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Pago:</label>
            <InputMoney disabled v-model="titulo.valorPago"></InputMoney>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Data Vencimento:</label>
            <InputDate :disabled="editMode" v-model="titulo.vencimento"></InputDate>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="3">
            <v-btn color="primary" @click="gravar">Gravar</v-btn>
          </v-col>
        </v-row>
      </v-card-text></v-card
    >
  </div>
</template>

<script>
import InputDate from "@/components/Input/InputDate.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import InputText from "@/components/Input/InputText.vue";
import ContaPagarTitulo from "@/infra/entity/ContaPagarTitulo";
import ContaPagarTituloFactory from "@/infra/entity/factory/ContaPagarTituloFactory";
import ContaPagarTituloService from "@/infra/service/ContaPagarTituloService";

export default {
  components: {
    InputText,
    InputMoney,
    InputDate,
  },
  methods: {
    abrir(titulo) {
      this.titulo = ContaPagarTituloFactory.create(titulo);
      this.editMode = false;
      if (this.titulo.status !== "ABERTO") {
        this.editMode = true;
      }
    },
    async gravar() {
      await ContaPagarTituloService.update(this.titulo);
      this.$emit("gravar");
    },
  },
  data() {
    return {
      editMode: false,
      titulo: new ContaPagarTitulo(1, new Date(), 100, 50, "teste", "123123123", "6", "1", 1, undefined, "3289108312098"),
    };
  },
};
</script>

<style lang="scss" scoped></style>
