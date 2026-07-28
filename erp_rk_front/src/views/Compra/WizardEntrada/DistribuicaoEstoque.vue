<template>
  <v-card flat>
    <v-card-title>Distribuição de Estoque entre Lojas</v-card-title>
    <v-card-text>
      <p class="text-caption mb-4">Reparta a quantidade de cada item entre as lojas. A soma deve ser igual à quantidade de estoque do item.</p>

      <div v-for="(item, idx) in itens" :key="idx" class="mb-6">
        <v-row>
          <v-col cols="12">
            <strong>{{ item.numeroItem }} - {{ item.descricao }}</strong>
            <span class="ml-2">(Qtd. de estoque: {{ item.quantidadeEstoque() }})</span>
          </v-col>
        </v-row>

        <v-row v-for="(dist, di) in item.distribuicoes" :key="di" align="center" dense>
          <v-col cols="12" md="6">
            <span>Loja:</span>
            <v-select :items="lojaOptions" :item-text="lojaTexto" item-value="codigo" v-model="dist.lojaCodigo" dense outlined hide-details></v-select>
          </v-col>
          <v-col cols="12" md="4">
            <span>Quantidade:</span>
            <InputQuantity v-model="dist.quantidade" @input="atualizar"></InputQuantity>
          </v-col>
          <v-col cols="12" md="2" class="text-center">
            <v-btn icon color="red" :disabled="item.distribuicoes.length <= 1" @click="removerLinha(item, di)" title="Remover loja">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </v-col>
        </v-row>

        <v-row align="center">
          <v-col cols="12" md="6">
            <v-btn small text color="primary" @click="adicionarLinha(item)">
              <v-icon left small>mdi-plus</v-icon>
              adicionar loja
            </v-btn>
          </v-col>
          <v-col cols="12" md="6" class="text-right">
            <v-chip :color="item.distribuicaoValida() ? 'green' : 'red'" dark small>
              <v-icon left size="14">{{ item.distribuicaoValida() ? "mdi-check-circle" : "mdi-alert-circle" }}</v-icon>
              Total {{ item.totalDistribuido() }} / {{ item.quantidadeEstoque() }}
            </v-chip>
          </v-col>
        </v-row>

        <v-divider class="mt-2"></v-divider>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
import InputQuantity from "@/components/Input/InputQuantity.vue";
import { ItemDistribuicao } from "@/infra/entity/NotaFiscalItem";
import ToastService from "@/infra/service/ToastService";

export default {
  components: { InputQuantity },
  data() {
    return {
      nota_fiscal: null,
      updateKey: 0,
    };
  },
  computed: {
    lojaList() {
      return this.$store.state.loja.lojaList;
    },
    // Normaliza o código da loja para número, casando com o tipo de dist.lojaCodigo (evita select vazio).
    lojaOptions() {
      return this.lojaList.map((loja) => ({ codigo: Number(loja.codigo), nome: loja.nome, cnpjcpf: loja.cnpjcpf }));
    },
    itens() {
      // updateKey força reavaliação dos totais ao editar quantidades
      this.updateKey;
      return this.nota_fiscal ? this.nota_fiscal.items : [];
    },
  },
  async mounted() {
    if (this.lojaList.length === 0) await this.$store.dispatch("getLojas");
  },
  methods: {
    // Recebe a nota do wizard e garante a distribuição padrão (100% na loja destinatária) por item.
    async carregar(nota) {
      this.nota_fiscal = nota;
      if (this.lojaList.length === 0) await this.$store.dispatch("getLojas");
      const lojaPadrao = Number(nota.loja.codigo);
      for (const item of this.nota_fiscal.items) {
        item.inicializarDistribuicao(lojaPadrao);
      }
      this.atualizar();
    },
    lojaTexto(loja) {
      return `${loja.codigo} - ${loja.nome}`;
    },
    adicionarLinha(item) {
      // Pré-preenche a quantidade com o que ainda falta para completar a quantidade de estoque.
      const restante = Math.max(item.quantidadeEstoque() - item.totalDistribuido(), 0);
      item.distribuicoes.push(new ItemDistribuicao(0, restante));
      this.atualizar();
    },
    removerLinha(item, indice) {
      item.distribuicoes.splice(indice, 1);
      this.atualizar();
    },
    atualizar() {
      this.updateKey++;
    },
    // Validação chamada pelo wizard antes de avançar/efetivar.
    validar() {
      for (const item of this.nota_fiscal.items) {
        if (!item.distribuicaoValida()) {
          ToastService.showError(`Distribuição do item ${item.numeroItem} - ${item.descricao} não confere com a quantidade de estoque.`);
          return false;
        }
        const lojas = item.distribuicoes.map((d) => Number(d.lojaCodigo));
        if (lojas.some((l) => !l)) {
          ToastService.showError(`Selecione a loja em todas as linhas do item ${item.numeroItem}.`);
          return false;
        }
        if (new Set(lojas).size !== lojas.length) {
          ToastService.showError(`Loja repetida na distribuição do item ${item.numeroItem}.`);
          return false;
        }
      }
      return true;
    },
  },
};
</script>
