<template>
  <v-dialog v-model="dialog">
    <v-card>
      <v-card-title>{{ produto.codigo_barras }} - {{ produto.descricao }} </v-card-title>
      <v-tabs v-model="tab">
        <v-tab>Principal</v-tab>
        <v-tab>Preços</v-tab>
        <v-tab>Impostos</v-tab>
        <v-tab>Estoque</v-tab>

        <v-tab-item>
          <!-- PRINCIPAL -->
          <v-container>
            <v-row>
              <v-col cols="12" sm="1">
                <label class="form-label" for="input-example">Código:</label>
                <input type="text" class="form-control" placeholder="Código do Produto" id="codigo" v-model="produto.codigo" :disabled="true" />
              </v-col>
              <v-col cols="12" sm="3">
                <label class="form-label" for="input-example">Código Barras:</label>
                <InputNumber :limit="14" v-model="produto.codigo_barras"></InputNumber>
              </v-col>

              <v-col cols="12" sm="8">
                <label class="form-label" for="input-example">Descrição:</label>
                <InputText v-model="produto.descricao" :upper-case="true" :limit="80"></InputText>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="3">
                Seção:
                <v-autocomplete id="secao" @change="carregarGrupos" v-model="produto.secao" item-text="nome" item-value="codigo" :items="secaoList"></v-autocomplete>
              </v-col>
              <v-col cols="12" sm="3">
                Grupo:
                <v-autocomplete ref="grupo" v-model="produto.grupo" :items="grupoList" item-text="nome" item-value="codigo"></v-autocomplete>
              </v-col>
              <v-col cols="12" sm="4">
                Fornecedor:
                <v-autocomplete ref="fornecedor" v-model="produto.fornecedor" :items="fornecedorList" item-text="nome" item-value="codigo"></v-autocomplete>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" sm="2">
                Forma de Venda:
                <v-radio-group v-model="produto.forma_venda">
                  <v-radio label="Unitario" value="N"></v-radio>
                  <v-radio label="Fracionado" value="S"></v-radio>
                </v-radio-group>
              </v-col>
              <v-col cols="12" sm="2">
                Informações
                <v-checkbox v-model="produto.balanca" true-value="S" false-value="N" label="Envia Balança" class="mt-0"></v-checkbox>
                <v-checkbox v-model="produto.ativo" true-value="N" false-value="S" label="Inativo" class="mt-0"></v-checkbox>
                <v-checkbox v-model="produto.diversos" true-value="S" false-value="N" label="Preço Variável" class="mt-0"></v-checkbox>
              </v-col>
              <v-col cols="12" sm="2">
                Unidade:
                <v-select v-model="produto.unidade" :items="['UN', 'KG', 'GR']"></v-select>
              </v-col>
              <v-col cols="12" sm="3">
                Validade Balança
                <input type="number" class="form-control" placeholder="Validade" v-model.number="produto.balanca_validade" />
              </v-col>
            </v-row>
          </v-container>
        </v-tab-item>
        <v-tab-item>
          <!-- <TabPrecos /> -->
          <div>
            <v-data-table
              id="tablePreco"
              :headers="header_precos"
              :items="produto.precos"
              :key="atualizarTable"
              :footer-props="{
                'items-per-page-text': 'Preços por pág.',
              }"
              @click:row="abrirDialogPreco"
            >
              <template v-slot:item.loja_codigo="{ item }">
                <span>{{ item.loja.codigo }}</span>
              </template>
              <template v-slot:item.loja_descricao="{ item }">
                <InputText v-model="item.loja.nome" :disabled="true"></InputText>
              </template>
              <template v-slot:item.custo="{ item }">
                <InputMoney v-model="item.custo"></InputMoney>
              </template>
              <template v-slot:item.preco="{ item }">
                <InputMoney v-model="item.preco"></InputMoney>
              </template>
              <template v-slot:item.markup="{ item }">
                <InputPercentage v-model="item.markup"></InputPercentage>
              </template>
              <template v-slot:item.oferta="{ item }">
                <InputMoney v-model="item.oferta"></InputMoney>
              </template>
            </v-data-table>
            <!-- MODAL -->
            <v-dialog v-model="dialogPreco" width="auto">
              <v-card>
                <v-card-title>
                  <span class="headline">Preços</span>
                </v-card-title>

                <v-card-text>
                  <v-row>
                    <v-col cols="12" sm="6">
                      <label class="form-label" for="input-example">Loja:</label>
                      <input disabled type="text" class="form-control" placeholder="Loja" v-model="preco_rascunho.loja.nome" />
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Custo:</label>
                      <InputMoney v-model="preco_rascunho.custo"></InputMoney>
                    </v-col>

                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Markup:</label>
                      <InputPercentage v-model="preco_rascunho.markup"></InputPercentage>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Preço:</label>
                      <InputMoney v-model="preco_rascunho.preco"></InputMoney>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Preço Oferta:</label>
                      <InputMoney v-model="preco_rascunho.oferta"></InputMoney>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Margem Praticada:</label>
                      <InputPercentage :disabled="true" :value="preco_rascunho.margemPraticada()"></InputPercentage>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Markdown:</label>
                      <InputPercentage :disabled="true" :value="preco_rascunho.markDown()"></InputPercentage>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="input-example">Sugestão:</label>
                      <InputMoney :disabled="true" :value="preco_rascunho.sugestao()"></InputMoney>
                    </v-col>
                  </v-row>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="primary" @click="atualizarPreco">Atualizar</v-btn>
                  <v-btn color="primary" @click="atualizarPrecoAceitarSugestao">Aceitar Sugestão</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </div>
        </v-tab-item>
        <v-tab-item>
          <v-container>
            <v-row class="align-items-center">
              <v-col cols="12" sm="2">
                <label class="form-label" for="input-example">Tributação:</label>
                <InputText @blur="carregarTributacao" :upper-case="true" v-model="produto.tributacao"></InputText>
              </v-col>
              <v-col cols="12" sm="8">
                <label class="form-label" for="input-example">Descrição Tributação:</label>
                <div class="input-group">
                  <v-btn icon color="primary" @click="abrirDialogTributacao">
                    <v-icon>mdi-magnify</v-icon>
                  </v-btn>
                  <input type="text" class="form-control" placeholder="Descrição da Tributação" v-model="tributacao_descricao" disabled />
                </div>
              </v-col>
            </v-row>
            <v-row class="align-items-center">
              <v-col cols="12" sm="2">
                <label class="form-label" for="input-example">NCM:</label>
                <InputNumber @blur="carregarNCM" v-model="produto.ncm" :pad-left="8" :limit="8"></InputNumber>
              </v-col>
              <v-col cols="12" sm="8">
                <label class="form-label" for="input-example">Descrição NCM:</label>
                <div class="input-group">
                  <v-btn icon color="primary" @click="abrirDialogNCM">
                    <v-icon>mdi-magnify</v-icon>
                  </v-btn>
                  <input type="text" class="form-control" placeholder="Descrição do NCM" v-model="ncm_descricao" readonly />
                </div>
              </v-col>
            </v-row>

            <v-row class="align-items-center">
              <v-col cols="12" sm="2">
                <label class="form-label" for="input-example">CEST:</label>
                <InputNumber @blur="carregarCEST" v-model="produto.cest" :pad-left="7" :limit="7"></InputNumber>
              </v-col>
              <v-col cols="12" sm="8">
                <label class="form-label" for="input-example">Descrição CEST:</label>
                <div class="input-group">
                  <v-btn icon color="primary" @click="abrirDialogCEST">
                    <v-icon>mdi-magnify</v-icon>
                  </v-btn>
                  <input type="text" class="form-control" placeholder="Descrição do CEST" v-model="cest_descricao" readonly />
                </div>
              </v-col>
            </v-row>

            <v-row class="align-items-center">
              <v-col cols="12" sm="2">
                <label class="form-label" for="input-example">Pis/Cofins:</label>
                <InputNumber @blur="carregarPisCofins" v-model="produto.impfederal" :limit="1"></InputNumber>
              </v-col>
              <v-col cols="12" sm="8">
                <label class="form-label" for="input-example">Descrição Pis/Cofins:</label>
                <div class="input-group">
                  <v-btn icon color="primary" @click="abrirDialogPisCofins">
                    <v-icon>mdi-magnify</v-icon>
                  </v-btn>
                  <input type="text" class="form-control" placeholder="Descrição do PIS/Cofins" v-model="imposto_federal_descricao" readonly />
                </div>
              </v-col>
            </v-row>
          </v-container>
        </v-tab-item>
        <v-tab-item>
          <!-- <TabEstoque /> -->
          <div>
            <v-data-table
              id="tableEstoque"
              :headers="header_estoques"
              :items="produto.estoques"
              :key="atualizarTable"
              :footer-props="{
                'items-per-page-text': 'Preços por pág.',
              }"
            >
              <template v-slot:item.loja_codigo="{ item }">
                <span>{{ item.loja.codigo }}</span>
              </template>
              <template v-slot:item.loja_descricao="{ item }">
                <InputText v-model="item.loja.nome" :disabled="true"></InputText>
              </template>
              <template v-slot:item.estoque_minimo="{ item }">
                <InputQuantity v-model="item.estoque_minimo"></InputQuantity>
              </template>
              <template v-slot:item.estoque_maximo="{ item }">
                <InputQuantity v-model="item.estoque_maximo"></InputQuantity>
              </template>
              <template v-slot:item.estoque="{ item }">
                <InputQuantity v-model="item.estoque"></InputQuantity>
              </template>
            </v-data-table>
          </div>
        </v-tab-item>
      </v-tabs>
      <div class="d-flex flex-row-reverse container">
        <v-btn color="secondary" class="mr-2" @click="cancelar">Cancelar</v-btn>
        <v-btn color="primary" class="mr-2" @click="gravar">Gravar</v-btn>
      </div>
      <ModalTributacao ref="modalTributacao" @selecionar-tributacao="atualizarTributacao"></ModalTributacao>
      <v-dialog v-model="dialogNCM">
        <ModalNCMRefact @selecionar-ncm="atualizarNCM"></ModalNCMRefact>
      </v-dialog>
      <v-dialog v-model="dialogCEST">
        <ModalCESTRefact ref="modalCEST" :ncm="produto.ncm" @selecionar-cest="atualizarCEST"></ModalCESTRefact>
      </v-dialog>
      <v-dialog v-model="dialogPisCofins">
        <ModalPisCofinsRefact ref="modalPisCofins" @selecionar-impostosfederais="atualizarImpFederal"></ModalPisCofinsRefact>
      </v-dialog>
    </v-card>
  </v-dialog>
</template>

<script>
import InputMoney from "@/components/Input/InputMoney.vue";
import InputNumber from "@/components/Input/InputNumber.vue";
import InputPercentage from "@/components/Input/InputPercentage.vue";
import InputText from "@/components/Input/InputText.vue";
import Preco from "@/infra/entity/Preco";
import Produto from "@/infra/entity/Produto";
import ModalTributacao from "@/views/FiscalRefact/ModalTributacaoRefact.vue";
import ModalNCMRefact from "../FiscalRefact/ModalNCMRefact.vue";
import ModalCESTRefact from "../FiscalRefact/ModalCESTRefact.vue";
import CEST from "@/infra/entity/CEST";
import NCM from "@/infra/entity/NCM";
import ToastService from "@/infra/service/ToastService";
import ModalPisCofinsRefact from "../FiscalRefact/ModalPisCofinsRefact.vue";
import InputQuantity from "@/components/Input/InputQuantity.vue";

export default {
  inject: ["secaoController", "grupoController", "fornecedorController", "produtoController", "tributacaoController", "impostosFederaisController"],
  methods: {
    async abrirPorNotaFiscalCompra(item_nota_rascunho) {
      await this.carregarSecoes();
      await this.carregarGrupos();
      await this.carregarFornecedores();
      this.produto = await this.produtoController.createProdutoFromNotaCompra(item_nota_rascunho);
      this.dialog = true;
      await this.carregarNCM();
      await this.carregarTributacao();
    },
    async carregarNCM() {
      const ncm = await NCM.findByNCM(this.produto.ncm);
      this.produto.cest = "";
      if (ncm) this.ncm_descricao = ncm.Descricao;
      if (!ncm) {
        this.ncm_descricao = "";
        this.produto.ncm = "";
      }
    },
    carregarCEST() {
      const cest = CEST.filterByNcmAndCest(this.produto.ncm, this.produto.cest);
      if (cest) this.cest_descricao = cest.DESCRICAO;
      if (!cest) {
        this.cest_descricao = "";
        this.produto.cest = "";
      }
    },

    async carregarTributacao() {
      try {
        const res = await this.tributacaoController.getByCodigo(this.produto.tributacao);
        this.produto.tributacao = res.data.codigo;
        this.tributacao_descricao = res.data.nome;
      } catch (error) {
        this.tributacao_descricao = "";
        this.produto.tributacao = "";
        throw error;
      }
    },
    async carregarPisCofins() {
      try {
        const res = await this.impostosFederaisController.getByCodigo(this.produto.impfederal);
        this.produto.impfederal = res.data.codigo;
        this.imposto_federal_descricao = res.data.nome;
      } catch (error) {
        this.produto.impfederal = "";
        this.imposto_federal_descricao = "";
        throw error;
      }
    },
    atualizarPreco() {
      this.produto.atualizarPreco(this.preco_rascunho);
      this.dialogPreco = false;
      this.atualizarTable++;
    },
    atualizarPrecoAceitarSugestao() {
      this.preco_rascunho.aceitarSugestao();
      this.produto.atualizarPreco(this.preco_rascunho);
      this.dialogPreco = false;
      this.atualizarTable++;
    },
    abrirDialogPreco(preco) {
      this.dialogPreco = true;
      this.preco_rascunho = new Preco(preco.lojaId, preco.preco, preco.custo, preco.oferta, preco.markup, preco.loja);
    },
    abrirDialogTributacao() {
      this.$refs.modalTributacao.abrir();
    },
    abrirDialogNCM() {
      this.dialogNCM = true;
    },
    abrirDialogCEST() {
      this.dialogCEST = true;
      this.$nextTick(() => {
        this.$refs.modalCEST.carregarPorNCM(this.produto.ncm);
      });
    },
    abrirDialogPisCofins() {
      this.dialogPisCofins = true;
      this.$nextTick(() => {
        this.$refs.modalPisCofins.carregar();
      });
    },

    atualizarTributacao(tributacao) {
      this.produto.tributacao = tributacao.codigo;
      this.tributacao_descricao = tributacao.nome;
    },
    atualizarNCM(ncm) {
      this.produto.ncm = ncm.Codigo;
      this.ncm_descricao = ncm.Descricao;
      this.dialogNCM = false;
    },
    atualizarCEST(cest) {
      this.produto.cest = String(cest.CEST);
      this.cest_descricao = cest.DESCRICAO;
      this.dialogCEST = false;
    },
    atualizarImpFederal(imp) {
      this.produto.impfederal = imp.codigo;
      this.imposto_federal_descricao = imp.nome;
      this.dialogPisCofins = false;
    },
    cancelar() {
      this.dialog = false;
    },

    async gravar() {
      const res = await this.produtoController.insert(this.produto);
      this.$emit("produto-inserido", res.data);
      this.dialog = false;
      ToastService.showSuccess("Produto inserido com sucesso !");
    },
    async carregar() {
      await this.carregarSecoes();
      await this.carregarGrupos();
      await this.carregarFornecedores();
      await this.carregarProduto();
    },
    async carregarProduto() {
      const res = await this.produtoController.getByCodigo();
      this.produto = res.data;
      this.carregarNCM();
      this.carregarCEST();
      this.carregarPisCofins();
      this.carregarTributacao();
    },
    async carregarFornecedores() {
      const res = await this.fornecedorController.getAll();
      this.fornecedorList = res.data;
    },

    async carregarSecoes() {
      const res = await this.secaoController.getAll();
      this.secaoList = res.data;
    },

    async carregarGrupos() {
      this.produto.grupo = "";
      const res = await this.grupoController.getAllByCodigoSecao(this.produto.secao);
      this.grupoList = res.data;
    },
  },
  data() {
    return {
      dialog: false,
      tab: 0,
      dialogPreco: false,
      dialogNCM: false,
      dialogCEST: false,
      dialogPisCofins: false,
      produto: new Produto(),
      preco_rascunho: new Preco(),
      secaoList: [],
      grupoList: [],
      fornecedorList: [],
      header_precos: [
        { text: "Cód.", value: "loja_codigo" },
        { text: "Loja", value: "loja_descricao" },
        { text: "Custo", value: "custo" },
        { text: "Markup", value: "markup" },
        { text: "Preço", value: "preco" },
        { text: "Oferta", value: "oferta" },
      ],
      header_estoques: [
        { text: "Cód.", value: "loja_codigo" },
        { text: "Loja", value: "loja_descricao" },
        { text: "Estoque Mínimo", value: "estoque_minimo" },
        { text: "Estoque Máximo", value: "estoque_maximo" },
        { text: "Saldo Estoque", value: "estoque" },
      ],
      atualizarTable: 0,
      tributacao_descricao: "",
      ncm_descricao: "",
      cest_descricao: "",
      imposto_federal_descricao: "",
    };
  },
  components: {
    InputNumber,
    InputText,
    InputMoney,
    InputQuantity,
    InputPercentage,
    ModalTributacao,
    ModalNCMRefact,
    ModalCESTRefact,
    ModalPisCofinsRefact,
  },
};
</script>

<style lang="scss" scoped></style>
