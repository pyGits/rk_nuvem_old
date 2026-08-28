<template>
  <div>
    <v-card-text>
      <v-sheet class="pa-4 mb-4" elevation="1" rounded color="grey lighten-4">
        <v-row dense align="center">
          <v-col cols="12" sm="3">
            <v-subheader class="pl-0">Recebido de</v-subheader>
            <v-text-field v-model="filtro.dataDe" type="date" outlined dense hide-details></v-text-field>
          </v-col>
          <v-col cols="12" sm="3">
            <v-subheader class="pl-0">Até</v-subheader>
            <v-text-field v-model="filtro.dataAte" type="date" outlined dense hide-details></v-text-field>
          </v-col>
          <v-col cols="12" sm="4">
            <v-subheader class="pl-0">Cliente</v-subheader>
            <v-text-field :value="clienteDescricao" readonly outlined dense hide-details placeholder="Todos os clientes">
              <template v-slot:append-outer>
                <v-btn icon small @click="dialogCliente = true">
                  <v-icon>mdi-magnify</v-icon>
                </v-btn>
                <v-btn v-if="filtro.selectedCliente" icon small @click="limparCliente">
                  <v-icon>mdi-close</v-icon>
                </v-btn>
              </template>
            </v-text-field>
          </v-col>
          <v-col cols="12" sm="2">
            <v-checkbox v-model="filtro.incluirEstornados" true-value="1" false-value="0" label="Incluir estornados" hide-details dense class="mt-6"></v-checkbox>
          </v-col>
        </v-row>

        <div class="d-flex justify-end mt-4">
          <v-btn color="primary" @click="carregar">
            <v-icon left>mdi-magnify</v-icon>
            Pesquisar
          </v-btn>
        </div>
      </v-sheet>

      <EstadoVazio v-if="!carregando && !recibos.length" mensagem="Nenhum recebimento no período selecionado." icone="mdi-receipt-text-outline" />

      <v-data-table v-else :headers="headers" :items="recibos" :loading="carregando" :items-per-page="20" show-expand item-key="reciboId" class="elevation-1">
        <template v-slot:item.reciboNumero="{ item }">
          <strong>{{ String(item.reciboNumero).padStart(6, "0") }}</strong>
        </template>
        <template v-slot:item.dataPagamento="{ item }">
          {{ formatarData(item.dataPagamento) }}
        </template>
        <template v-slot:item.cliente="{ item }">
          {{ item.clienteCodigo }}{{ item.clienteNome ? ` - ${item.clienteNome}` : "" }}
        </template>
        <template v-slot:item.formaPagamentoNome="{ item }">
          {{ item.formaPagamentoNome || item.formaPagamento || "-" }}
        </template>
        <template v-slot:item.valorEmCaixa="{ item }">
          {{ maskMoney(item.valorEmCaixa) }}
        </template>
        <template v-slot:item.situacao="{ item }">
          <v-chip v-if="item.estornado === 1" x-small color="grey" dark>ESTORNADO</v-chip>
          <v-chip v-else-if="item.estornadoParcial" x-small color="warning" dark>ESTORNO PARCIAL</v-chip>
          <v-chip v-else x-small color="success" dark>VÁLIDO</v-chip>
        </template>

        <template v-slot:item.acoes="{ item }">
          <v-btn icon small title="Imprimir recibo" @click="imprimir(item)">
            <v-icon small>mdi-printer</v-icon>
          </v-btn>
          <v-btn v-if="item.estornado !== 1" icon small title="Estornar recibo" @click="estornar(item)">
            <v-icon small>mdi-undo-variant</v-icon>
          </v-btn>
        </template>

        <!-- Quais títulos esse recebimento quitou: é o que responde "o que eu
             liquidei desse cliente mesmo?" sem precisar abrir o PDF. -->
        <template v-slot:expanded-item="{ headers: colunas, item }">
          <td :colspan="colunas.length" class="pa-4 grey lighten-5">
            <div class="text-subtitle-2 mb-2">Títulos quitados neste recibo</div>
            <v-simple-table dense>
              <thead>
                <tr>
                  <th class="text-left">Título</th>
                  <th class="text-right">Parc.</th>
                  <th class="text-right">Vencimento</th>
                  <th class="text-right">Valor do título</th>
                  <th class="text-right">Quitado</th>
                  <th class="text-right">Saldo atual</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="titulo in item.titulos" :key="titulo.id">
                  <td>{{ titulo.codigo }}</td>
                  <td class="text-right">{{ titulo.prestacao }}</td>
                  <td class="text-right">{{ formatarData(titulo.dataVencimento) }}</td>
                  <td class="text-right">{{ maskMoney(titulo.valorTitulo) }}</td>
                  <td class="text-right">{{ maskMoney(titulo.valorRecebimento + titulo.descontoRecebimento) }}</td>
                  <td class="text-right">{{ maskMoney(titulo.saldoTitulo) }}</td>
                </tr>
              </tbody>
            </v-simple-table>

            <div class="mt-3 text-caption grey--text">
              Recebido {{ maskMoney(item.valor) }} · juros {{ maskMoney(item.juros) }} · multa {{ maskMoney(item.multa) }} · desconto {{ maskMoney(item.desconto) }}
            </div>
          </td>
        </template>
      </v-data-table>
    </v-card-text>

    <v-dialog v-model="dialogCliente" max-width="900">
      <LocalizarCliente @selecionar="selecionarCliente" @fechar="dialogCliente = false" />
    </v-dialog>

    <ConfirmDialog ref="confirmDialog"></ConfirmDialog>
  </div>
</template>

<script>
import ConfirmDialog from "@/components/ConfirmDialog/ConfirmDialog.vue";
import EstadoVazio from "@/components/Relatorio/EstadoVazio.vue";
import LocalizarCliente from "@/views/Cliente/LocalizarCliente.vue";
import ContaReceberService from "@/infra/service/ContaReceberService";
import PDFService from "@/infra/service/PDFService";
import { maskMoney, maskDateBR } from "@/utils/masks";

// Lista o que já foi recebido. Existe porque o título liquidado sai da grade de
// títulos (o filtro padrão é "em aberto") e não sobrava nenhum rastro do que
// tinha sido baixado - nem para conferir, nem para reimprimir o comprovante.
export default {
  name: "RecibosRecebimento",
  components: { ConfirmDialog, EstadoVazio, LocalizarCliente },
  data() {
    return {
      carregando: false,
      dialogCliente: false,
      clienteNome: "",
      recibos: [],
      filtro: {
        dataDe: this.trintaDiasAtras(),
        dataAte: this.hoje(),
        selectedCliente: "",
        incluirEstornados: "0",
      },
      headers: [
        { text: "Recibo", value: "reciboNumero" },
        { text: "Data", value: "dataPagamento" },
        { text: "Cliente", value: "cliente", sortable: false },
        { text: "Títulos", value: "qtdTitulos" },
        { text: "Forma", value: "formaPagamentoNome" },
        { text: "Total pago", value: "valorEmCaixa" },
        { text: "Situação", value: "situacao", sortable: false },
        { text: "", value: "acoes", sortable: false },
        { text: "", value: "data-table-expand" },
      ],
    };
  },
  computed: {
    clienteDescricao() {
      if (!this.filtro.selectedCliente) return "";
      return `${this.filtro.selectedCliente} - ${this.clienteNome}`.trim();
    },
  },
  mounted() {
    this.carregar();
  },
  methods: {
    maskMoney,
    hoje() {
      return new Date().toISOString().substring(0, 10);
    },
    trintaDiasAtras() {
      const data = new Date();
      data.setDate(data.getDate() - 30);
      return data.toISOString().substring(0, 10);
    },
    formatarData(data) {
      if (!data) return "";
      return maskDateBR(String(data).substring(0, 10));
    },
    async carregar() {
      this.carregando = true;
      try {
        this.recibos = await ContaReceberService.getRecibos(this.filtro);
      } finally {
        this.carregando = false;
      }
    },
    selecionarCliente(cliente) {
      this.filtro.selectedCliente = cliente.codigo;
      this.clienteNome = cliente.nome;
      this.dialogCliente = false;
      this.carregar();
    },
    limparCliente() {
      this.filtro.selectedCliente = "";
      this.clienteNome = "";
      this.carregar();
    },
    async imprimir(recibo) {
      const gerado = await ContaReceberService.gerarRecibo(recibo.reciboId);
      PDFService.exibirPDF(gerado.arquivo);
    },
    async estornar(recibo) {
      const confirmar = await this.$refs.confirmDialog.abrir(`Estornar o recibo nº ${recibo.reciboNumero} ?`, "Os títulos quitados por ele voltam para em aberto");
      if (!confirmar) return;

      await ContaReceberService.estornarRecibo(recibo.reciboId);
      await this.carregar();
      this.$emit("estornado");
    },
  },
};
</script>
