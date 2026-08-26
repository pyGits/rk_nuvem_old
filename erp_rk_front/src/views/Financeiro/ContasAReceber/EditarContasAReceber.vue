<template>
  <div>
    <v-card flat>
      <v-card-text>
        <v-row dense>
          <v-col cols="12" sm="4">
            <span class="text-caption grey--text">Loja</span>
            <v-autocomplete v-model="contaReceber.lojaId" :items="lojas" item-text="descricao" item-value="codigo" outlined dense hide-details></v-autocomplete>
          </v-col>

          <v-col cols="12" sm="5">
            <span class="text-caption grey--text">Cliente</span>
            <v-text-field :value="clienteSelecionado" readonly outlined dense hide-details placeholder="Nenhum cliente selecionado">
              <template v-slot:append-outer>
                <v-btn icon small @click="dialogCliente = true">
                  <v-icon>mdi-magnify</v-icon>
                </v-btn>
              </template>
            </v-text-field>
          </v-col>

          <v-col cols="12" sm="3">
            <span class="text-caption grey--text">Valor total</span>
            <InputMoney v-model="contaReceber.valorNominal" @keyup="atualizar" />
          </v-col>
        </v-row>

        <v-row dense class="mt-2">
          <v-col cols="12" sm="6">
            <span class="text-caption grey--text">Descrição</span>
            <InputText v-model="contaReceber.descricao" />
          </v-col>
          <v-col cols="6" sm="3">
            <span class="text-caption grey--text">Emissão</span>
            <v-text-field v-model="contaReceber.dataEmissao" type="date" outlined dense hide-details></v-text-field>
          </v-col>
          <v-col cols="6" sm="3">
            <span class="text-caption grey--text">1º vencimento</span>
            <v-text-field v-model="contaReceber.dataVencimento" type="date" outlined dense hide-details @change="atualizar"></v-text-field>
          </v-col>
        </v-row>

        <v-row dense class="mt-2" align="center">
          <v-col cols="6" sm="2">
            <span class="text-caption grey--text">Parcelas</span>
            <v-text-field v-model.number="contaReceber.parcelas" type="number" min="1" outlined dense hide-details @input="atualizar"></v-text-field>
          </v-col>
          <v-col cols="6" sm="2">
            <span class="text-caption grey--text">Intervalo</span>
            <v-text-field v-model.number="contaReceber.intervalo" type="number" min="1" outlined dense hide-details @input="atualizar"></v-text-field>
          </v-col>
          <v-col cols="12" sm="4">
            <span class="text-caption grey--text">Tipo do intervalo</span>
            <v-radio-group v-model="contaReceber.tipoIntervalo" row dense hide-details class="mt-1" @change="atualizar">
              <v-radio label="Meses" value="mes"></v-radio>
              <v-radio label="Dias" value="dias"></v-radio>
            </v-radio-group>
          </v-col>
        </v-row>

        <v-data-table :headers="headers" :items="contaReceber.titulos.items" :items-per-page="12" dense class="elevation-1 mt-4">
          <template v-slot:item.dataVencimento="{ item }">
            {{ formatarData(item.dataVencimento) }}
          </template>
          <template v-slot:item.valor="{ item }">
            {{ maskMoney(item.valor) }}
          </template>
          <template v-slot:no-data>
            <span class="grey--text">Informe valor, vencimento e parcelas para gerar os títulos</span>
          </template>
        </v-data-table>

        <div class="d-flex justify-end mt-4">
          <v-btn outlined class="mr-2" @click="limpar">Limpar</v-btn>
          <v-btn color="primary" @click="gravar">
            <v-icon left>mdi-content-save</v-icon>
            Gravar
          </v-btn>
        </div>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialogCliente" max-width="900">
      <LocalizarCliente @selecionar="selecionarCliente" @fechar="dialogCliente = false" />
    </v-dialog>

    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import InputText from "@/components/Input/InputText.vue";
import LocalizarCliente from "@/views/Cliente/LocalizarCliente.vue";
import ContaReceber from "@/infra/entity/ContaReceber";
import ContaReceberService from "@/infra/service/ContaReceberService";
import { maskMoney, maskDateBR } from "@/utils/masks";
import { getCurrentDate } from "@/utils/date";

// Lançamento manual de contas a receber: acerto, venda externa, renegociação.
// O que vem do PDV já nasce parcelado e não passa por aqui.
export default {
  name: "EditarContasAReceber",
  components: { InputText, InputMoney, LocalizarCliente, ConfirmDialog },
  data() {
    return {
      contaReceber: new ContaReceber(),
      dialogCliente: false,
      headers: [
        { text: "Parcela", value: "prestacao" },
        { text: "Vencimento", value: "dataVencimento" },
        { text: "Valor", value: "valor" },
        { text: "Descrição", value: "descricao" },
      ],
    };
  },
  computed: {
    lojaList() {
      return this.$store.state.loja.lojaList || [];
    },
    lojas() {
      return this.lojaList.map((loja) => ({
        codigo: Number(loja.codigo),
        descricao: `${loja.codigo} - ${loja.nome || loja.fantasia || ""}`.trim(),
      }));
    },
    clienteSelecionado() {
      if (!this.contaReceber.clienteCodigo) return "";
      return `${this.contaReceber.clienteCodigo} - ${this.contaReceber.clienteNome || ""}`.trim();
    },
  },
  async mounted() {
    this.limpar();
    await this.$store.dispatch("getLojas");
    if (this.lojas.length === 1) this.contaReceber.lojaId = this.lojas[0].codigo;
  },
  methods: {
    maskMoney,
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    atualizar() {
      this.contaReceber.atualizar();
    },
    selecionarCliente(cliente) {
      this.contaReceber.clienteCodigo = cliente.codigo;
      this.contaReceber.clienteCpf = cliente.cnpjcpf;
      this.contaReceber.clienteNome = cliente.nome;
      this.dialogCliente = false;
      this.atualizar();
    },
    limpar() {
      this.contaReceber = new ContaReceber();
      this.contaReceber.dataEmissao = getCurrentDate();
      this.contaReceber.dataVencimento = getCurrentDate();
      if (this.lojas.length === 1) this.contaReceber.lojaId = this.lojas[0].codigo;
    },
    async gravar() {
      this.contaReceber.atualizar();
      const confirmar = await this.$refs.confirmDialog.abrir("Confirmar lançamento dos títulos ?", `${this.contaReceber.titulos.items.length} parcela(s) serão criadas`);
      if (!confirmar) return;

      await ContaReceberService.insert(this.contaReceber);
      this.limpar();
      this.$emit("gravar");
    },
  },
};
</script>
