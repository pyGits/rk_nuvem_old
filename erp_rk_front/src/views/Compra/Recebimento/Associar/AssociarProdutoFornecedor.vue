<template>
  <div>
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-text>
          <v-card-title class="d-flex justify-space-between align-center">
            <span>Informações Produto da Nota</span>
          </v-card-title>
          <v-row>
            <v-col cols="12" md="3">
              <span>Seq. Nota</span>
              <input v-model="item_nota_rascunho.numeroItem" class="form-control" disabled />
            </v-col>
            <v-col cols="12" md="3">
              <span>Código Produto Na Nota</span>
              <input v-model="item_nota_rascunho.codigo" class="form-control" disabled />
            </v-col>
            <v-col cols="12" md="6">
              <span>Descrição Nota</span>
              <input v-model="item_nota_rascunho.descricao" class="form-control" disabled />
            </v-col>
            <v-row>
              <v-col cols="12" md="3">
                <span>Quantidade na Nota</span>
                <InputQuantity v-model="item_nota_rascunho.quantidadeComercial" disabled></InputQuantity>
              </v-col>
              <v-col cols="12" md="3">
                <span>Unidade na Nota</span>
                <input v-model="item_nota_rascunho.unidadeComercial" class="form-control" disabled />
              </v-col>
            </v-row>
          </v-row>

          <v-row>
            <v-card-title class="d-flex justify-space-between align-center">
              <span>Associação no Sistema:</span>
            </v-card-title>
            <v-col cols="12" md="6">
              <v-autocomplete
                density="compact"
                outlined
                :items="produtos"
                item-text="descricao"
                item-value="codigo"
                label="Selecione o produto do sistema"
                v-model="item_nota_rascunho.associacao.codigo_produto"
              />
            </v-col>
            <v-col cols="12" md="3">
              <v-btn @click="abrirDialogProduto">Cadastrar Produto</v-btn>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="3">
              <span>Itens em Embalagem</span>
              <InputQuantity v-model="item_nota_rascunho.associacao.qtd_fornecedor"></InputQuantity>
            </v-col>
            <v-col cols="12" md="3">
              <span>Unidade</span>
              <v-select v-model="item_nota_rascunho.associacao.unidade_fornecedor" density="compacted" :items="unidades"></v-select>
            </v-col>
            <v-col cols="12" md="3">
              <span>Entrada De Estoque:</span>
              <InputQuantity :value="item_nota_rascunho.quantidadeEstoque()" :disabled="true"></InputQuantity>
            </v-col>
            <v-col cols="12" md="3">
              <v-btn text @click="dialogAssociar = false">Cancelar</v-btn>
              <v-btn @click="confirmarAssociacaoProduto" color="primary">Confirmar</v-btn>
            </v-col>
          </v-row>

          <v-card-title class="d-flex justify-space-between align-center">
            <span>Produtos Não Associados:</span>
          </v-card-title>
          <v-row>
            <v-data-table :headers="headers" :items="nota_fiscal.itensNaoAssociados()" @click:row="carregarItem" :items-per-page="20" class="elevation-1" :key="updateTable">
              <template v-slot:item.associacao="{ item }">
                <div class="d-flex align-center">
                  <v-chip :color="item.associacao.isAssociado() ? 'green' : 'red'" dark small class="ma-1">
                    <v-icon left size="14">
                      {{ item.associacao.isAssociado() ? "mdi-check-circle" : "mdi-alert-circle" }}
                    </v-icon>
                    <v-icon left size="14">
                      {{ item.associacao.isAssociado() ? "Associado" : "Não associado" }}
                    </v-icon>
                  </v-chip>
                </div>
              </template>
            </v-data-table>
          </v-row>
        </v-card-text>
        <v-card-actions class="justify-end"> </v-card-actions>
      </v-card>
    </v-dialog>
    <CadastroProduto @produto-inserido="selecionarProduto" ref="produtoDialog"></CadastroProduto>
  </div>
</template>

<script>
import InputQuantity from "@/components/Input/InputQuantity.vue";
import Fornecedor from "@/infra/entity/Fornecedor";
import { NotaFiscal } from "@/infra/entity/NotaFiscal";
import { NotaFiscalItem } from "@/infra/entity/NotaFiscalItem";
import ToastService from "@/infra/service/ToastService";
import CadastroProduto from "@/views/ProdutoRefact/CadastroProduto.vue";

export default {
  inject: ["produtoController", "associacaoController"],
  data() {
    return {
      dialog: false,
      unidades: ["UN", "KG", "GR", "CX", "FD", "PCT", "PC", "DZ", "LT", "ML", "MT", "M2", "M3", "SC", "ROL", "PAR", "TON"],
      item_nota_rascunho: new NotaFiscalItem(),
      produtos: [],
      nota_fiscal: new NotaFiscal(),
      fornecedor: new Fornecedor(),
      dialogProduto: false,
      updateTable: 0,
      modalProduto: false,
      headers: [
        { text: "Nº", value: "numeroItem" },
        { text: "Produto", value: "descricao" },
        { text: "Quantidade", value: "quantidadeComercial" },
        { text: "Vlr. Unitário", value: "valorUnitario" },
        { text: "Associação", value: "associacao" },
        { text: "Total", value: "valorProdutos" },
      ],
    };
  },
  methods: {
    async abrirDialogProduto() {
      await this.$refs.produtoDialog.abrirPorNotaFiscalCompra(this.item_nota_rascunho);
    },
    async abrir(nota_fiscal, fornecedor, item) {
      this.nota_fiscal = nota_fiscal;
      this.fornecedor = fornecedor;
      this.item_nota_rascunho = item;
      this.dialog = true;
      await this.carregarProdutos();
    },
    carregarItem(item) {
      this.item_nota_rascunho = item;
    },
    async selecionarProduto(codigoProduto) {
      await this.carregarProdutos();
      this.item_nota_rascunho.associacao.codigo_produto = codigoProduto;
    },
    async carregarProdutos() {
      const res = await this.produtoController.getAll();
      this.produtos = res.data;
    },
    async confirmarAssociacaoProduto() {
      this.item_nota_rascunho.associacao.codigo_fornecedor = this.fornecedor.codigo;
      this.item_nota_rascunho.associacao.referencia_fornecedor = this.item_nota_rascunho.codigo;
      await this.associacaoController.insert(this.item_nota_rascunho.associacao);
      this.item_nota_rascunho = this.nota_fiscal.itensNaoAssociados()[0] ?? new NotaFiscalItem();
      ToastService.showSuccess("Produto Associado com sucesso !");
      this.updateTable++;

      this.$emit("atualizar-form");
      if (this.nota_fiscal.itensNaoAssociados().length === 0) this.dialog = false;
    },
  },
  components: {
    InputQuantity,
    CadastroProduto,
  },
};
</script>

<style lang="scss" scoped></style>
