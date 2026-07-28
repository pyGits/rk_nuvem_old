<template>
  <div>
    <v-card
      ><v-card-title>Adicionar Itens Nota Fiscal</v-card-title
      ><v-card-text>
        <v-row>
          <v-col cols="12" md="8">
            <ProdutoSelector ref="frmProdutoSelector"></ProdutoSelector>
          </v-col>
          <v-col cols="12" md="1"><span>Unidade:</span><InputText :limit="14" v-model="item.produto.unidade" disabled></InputText></v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="2">
            <span>Itens Embalagem:</span>
            <InputQuantity v-model="item.itens_embalagem" @keyup="item.calcular()"></InputQuantity>
          </v-col>
          <v-col cols="12" md="2">
            <span>Quantidade:</span>
            <InputQuantity v-model="item.qtd" @keyup="item.calcular()"></InputQuantity>
          </v-col>
          <v-col cols="12" md="2">
            <span>Valor Unitário:</span>
            <InputMoney v-model="item.valor_unitario" @keyup="item.calcular()"></InputMoney>
          </v-col>
          <v-col cols="12" md="2">
            <span>Valor Total:</span>
            <InputMoney v-model="item.total" disabled></InputMoney>
          </v-col>
        </v-row>
        <v-row>
          <TributacaoSelector ref="frmTributacaoSelector"></TributacaoSelector>
        </v-row>

        <v-row>
          <v-col cols="12" md="1">
            <v-btn @click="adicionarItem" color="primary">Adicionar Item</v-btn>
          </v-col>
        </v-row>
        <v-data-table :items="list.itens()" :headers="headers">
          <template v-slot:item.acao="{ item }">
            <v-btn icon color="red" @click="excluirItem(item)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </template>
        </v-data-table>
        <v-row>
          <v-col cols="12" md="2">
            <v-btn color="primary" @click="gravar">Gravar</v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
    <v-dialog v-model="dialogProduto">
      <LocalizarProduto></LocalizarProduto>
    </v-dialog>
  </div>
</template>

<script>
import ProdutoSelector from "@/atomic/Produto/ProdutoSelector.vue";
import TributacaoSelector from "@/atomic/Tributacao/TributacaoSelector.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import InputNumber from "@/components/Input/InputNumber.vue";
import InputQuantity from "@/components/Input/InputQuantity.vue";
import InputText from "@/components/Input/InputText.vue";
import NotaFiscalItemFactory from "@/infra/entity/factory/NotaFiscalItemFactory";
import { NotaFiscalItemEfetivo, NotaFiscalItemEfetivoList } from "@/infra/entity/NotaFiscalItemEfetivo";
import Produto from "@/infra/entity/Produto";
import Tributacao from "@/infra/entity/Tributacao";
import LocalizarProduto from "@/views/ProdutoRefact/LocalizarProduto.vue";

export default {
  components: {
    InputNumber,
    InputText,
    InputQuantity,
    InputMoney,
    LocalizarProduto,
    TributacaoSelector,
    ProdutoSelector,
  },
  methods: {
    gravar() {
      this.$emit("gravar", NotaFiscalItemFactory.createFromNotaFiscalItemEfetivoList(this.list));
    },
    excluirItem(item) {
      this.list.excluir(item);
    },
    adicionarItem() {
      this.item.produto = this.$refs.frmProdutoSelector.produto;
      this.item.tributacao = this.$refs.frmTributacaoSelector.tributacao;
      this.list.adicionar(this.item);
      this.item = new NotaFiscalItemEfetivo();
      this.$refs.frmProdutoSelector.produto = new Produto();
      this.$refs.frmTributacaoSelector.tributacao = new Tributacao();
    },
  },

  data() {
    return {
      headers: [
        { text: "Seq.", value: "seq" },
        { text: "Descrição", value: "produto.descricao" },
        { text: "Valor Uni", value: "valor_unitario" },
        { text: "Qtd", value: "qtd" },
        { text: "Total", value: "total" },
        { text: "Ações", value: "acao", sortable: false },
      ],
      dialogProduto: false,
      item: new NotaFiscalItemEfetivo(),
      list: new NotaFiscalItemEfetivoList(),
    };
  },
};
</script>

<style lang="scss" scoped></style>
