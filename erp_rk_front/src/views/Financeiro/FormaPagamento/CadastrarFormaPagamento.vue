<template>
  <div>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <div>
          <span>Forma Pagamento Financeiro</span>
        </div>

        <div class="d-flex gap-2" style="margin-left: auto">
          <v-btn color="primary" @click="novo">
            <v-icon left>mdi-plus</v-icon>
            Incluir Nova Forma Pagamento
          </v-btn>
        </div>
      </v-card-title>
      <v-tabs v-model="tab" background-color="primary" dark>
        <v-tab>Listar</v-tab>
        <v-tab>Editar</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-card-text>
            <v-data-table :headers="headers" :items="pagamentos" item-key="id">
              <template v-slot:[`item.actions`]="{ item }">
                <v-icon @click.stop="editarFormaPagamento(item)">mdi-pencil</v-icon>
                <!-- <v-icon @click.stop="deletarCategoriaFinanceira(item)">mdi-delete</v-icon> -->
              </template>
            </v-data-table>
          </v-card-text>
        </v-tab-item>
        <v-tab-item>
          <v-card-text>
            <v-row>
              <v-col cols="12" sm="2"><span>Código:</span> <InputText v-model="pagamento.codigo" disabled></InputText> </v-col>
              <v-col cols="12" sm="8"><span>Código:</span> <InputText upper-case :limit="80" v-model="pagamento.nome"></InputText> </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="3">
                <v-btn color="primary" @click="gravar">Gravar</v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-tab-item>
      </v-tabs-items>
    </v-card>
  </div>
</template>

<script>
import InputText from "@/components/Input/InputText.vue";
import FormaPagamento from "@/infra/entity/FormaPagamento";
import FormaPagamentoService from "@/infra/service/FormaPagamentoService";

export default {
  components: {
    InputText,
  },
  async mounted() {
    await this.carregar();
  },
  data() {
    return {
      pagamento: new FormaPagamento(),
      tab: 0,
      pagamentos: [],
      headers: [
        { text: "Código", value: "codigo" },
        { text: "Nome", value: "nome" },
        { value: "actions", sortable: false },
      ],
    };
  },
  methods: {
    async carregar() {
      this.pagamentos = await FormaPagamentoService.getAll();
    },
    novo() {
      this.tab = 1;
      this.pagamento = new FormaPagamento();
    },
    isInserting() {
      return this.pagamento.codigo === "";
    },
    async gravar() {
      if (this.isInserting()) await FormaPagamentoService.insert(this.pagamento);
      if (!this.isInserting()) await FormaPagamentoService.update(this.pagamento);
      await this.carregar();
      this.tab = 0;
    },
    editarFormaPagamento(forma) {
      this.tab = 1;
      this.pagamento = forma;
    },
  },
};
</script>

<style lang="scss" scoped></style>
