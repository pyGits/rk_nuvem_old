<template>
  <v-card>
    <v-card-title>Alterar Preços</v-card-title>
    <v-card-text>
      <p class="text-caption mb-2">Os preços são definidos por loja que recebeu estoque na distribuição.</p>
      <v-divider></v-divider>

      <v-data-table v-if="produtos.length !== 0" :items="produtos.items" :items-per-page="10" class="elevation-1" :key="updateTable" density="compact">
        <template v-slot:item="{ item }">
          <tr>
            <td :colspan="7">
              <span>Produto: </span>
              <input class="form-control" style="font-weight: bold" :value="item.codigo_barras + ' - ' + item.descricao" disabled />
            </td>
          </tr>
          <tr v-for="(preco, pi) in item.precos" :key="pi">
            <td>
              <span>Loja:</span>
              <input class="form-control" :value="(preco.loja ? preco.loja.codigo + ' - ' + preco.loja.nome : preco.lojaId)" disabled />
            </td>
            <td>
              <span>Custo:</span>
              <InputMoney disabled v-model="preco.custo" label="Custo" />
            </td>
            <td>
              <span>Markup:</span>
              <InputQuantity v-model="preco.markup" label="Markup" />
            </td>
            <td>
              <span>Sugestão</span>
              <InputMoney disabled :value="preco.sugestao()" />
            </td>
            <td>
              <span>Venda:</span>
              <InputQuantity v-model="preco.preco" label="Preço" />
            </td>
            <td>
              <span>Último Custo:</span>
              <InputMoney disabled v-model="preco.ultimo_custo" label="Preço" />
            </td>
            <td>
              <v-btn @click="preco.aceitarSugestao()">Aceitar Sugestão</v-btn>
            </td>
          </tr>
          <v-divider class="mt-5"></v-divider>
        </template>
      </v-data-table>
      <v-divider></v-divider>
      <v-row>
        <span>Alterar Markup Geral:</span>
        <v-col cols="12" md="3">
          <InputQuantity v-model="markupGeral"></InputQuantity>
        </v-col>
        <v-col cols="12" md="3">
          <v-btn color="primary" @click="produtos.alterarMarkupGeral(markupGeral)">Atualizar Markups</v-btn>
        </v-col>
        <v-col cols="12" md="3">
          <v-btn color="primary" @click="produtos.aceitarTodasSugestoes()">Aceitar Todas Sugestões</v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="text-right">
          <v-btn @click="gravarPrecos">Gravar Preços</v-btn>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script>
import InputMoney from "@/components/Input/InputMoney.vue";
import InputQuantity from "@/components/Input/InputQuantity.vue";
import { NotaFiscal } from "@/infra/entity/NotaFiscal";
import { ListaProdutos } from "@/infra/entity/Produto";
import ToastService from "@/infra/service/ToastService";

export default {
  inject: ["produtoController", "notaFiscalEntradaController"],
  methods: {
    async abrir(nota) {
      const res = await this.notaFiscalEntradaController.getByChave({ chave_nota: nota.protocolo.chave });

      let produtos = [];
      this.nota_fiscal = res.nota;

      this.nota_fiscal.items.map((item) => {
        produtos.push(item.produto);
      });

      this.produtos = new ListaProdutos(produtos);
    },
    atualizarForm() {
      this.updateTable++;
    },
    async gravarPrecos() {
      await this.produtoController.updatePrecosByProdutos(this.produtos);
      ToastService.showSuccess("Preços Atualizado com sucesso !");
      this.dialog = false;
    },
  },
  components: {
    InputMoney,
    InputQuantity,
  },
  data() {
    return {
      nota_fiscal: new NotaFiscal(),
      updateTable: 0,
      markupGeral: 0,
      produtos: [],
      headersPrecos: [
        { text: "Cód. Produto", value: "codigo" },
        { text: "Produto", value: "produto_nome" },
        { text: "Custo", value: "custo" },
        { text: "Markup", value: "markup" },
        { text: "Preço Venda", value: "preco" },
      ],
    };
  },
};
</script>

<style lang="scss" scoped></style>
