<template>
  <div>
    <!-- Título da página -->
    <v-card>
      <!-- Editar notas  -->

      <v-col cols="12" md="2">
        <div></div>
      </v-col>
      <!-- Tabs -->
      <v-tabs v-model="tabEditar" background-color="primary" dark>
        <v-tab>Destinatário</v-tab>
        <v-tab>Fornecedor</v-tab>
        <v-tab>Produtos da NFe</v-tab>
        <v-tab>Transporte</v-tab>
        <v-tab>Totais</v-tab>
      </v-tabs>

      <v-tabs-items v-model="tabEditar">
        <!-- Editar nota -->
        <v-tab-item>
          <v-container>
            <v-row>
              <v-col cols="12" md="1">
                <span>Cód:</span>
                <InputNumber
                  :limit="1"
                  v-model="nota_fiscal.loja.codigo"
                  :disabled="!tabDestinatario.edtCodLoja || nota_fiscal.entrada_nota_etapa"
                  @keyup.enter="carregarLoja"
                  @blur="carregarLoja"
                ></InputNumber>
              </v-col>
              <v-col cols="12" md="3">
                <span>CNPJ:</span>
                <input class="form-control" v-model="nota_fiscal.loja.cnpjcpf" disabled />
              </v-col>
              <v-col cols="12" md="3" class="mt-6">
                <v-btn color="primary" @click="localizarLoja" :disabled="!tabDestinatario.btnLocalizarLoja || nota_fiscal.entrada_nota_etapa">
                  <v-icon left>mdi-magnify</v-icon>
                  Localizar Loja</v-btn
                >
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="12">
                <span>Loja:</span>
                <input class="form-control" v-model="nota_fiscal.loja.nome" disabled />
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="12" md="12">
                <span>Fantasia:</span>
                <input class="form-control" v-model="nota_fiscal.loja.fantasia" disabled />
              </v-col>
            </v-row>
            <v-row
              ><v-col cols="12" md="8">
                <span>Chave XML:</span>
                <InputNumber :limit="44" v-model="nota_fiscal.protocolo.chave" :disabled="!tabDestinatario.edtChaveXML || nota_fiscal.entrada_nota_etapa" /> </v-col
            ></v-row>
            <v-row>
              <v-col cols="12" md="3">
                <span>Número NF-e:</span>
                <InputNumber :limit="20" v-model="nota_fiscal.nrNota" :disabled="!tabDestinatario.edtNumeroNFe || nota_fiscal.entrada_nota_etapa" />
              </v-col>
              <v-col cols="12" md="1">
                <span>Série:</span>
                <InputNumber :limit="2" v-model="nota_fiscal.serie" :disabled="!tabDestinatario.edtSerie || nota_fiscal.entrada_nota_etapa" />
              </v-col>
              <v-col cols="12" md="2">
                <span>Modelo:</span>
                <InputNumber :limit="2" v-model="nota_fiscal.modelo" :disabled="!tabDestinatario.edtModelo || nota_fiscal.entrada_nota_etapa" />
              </v-col>
              <v-col cols="12" md="3">
                <span>Data de Emissão:</span>
                <InputDate v-model="nota_fiscal.dataEmissao" :disabled="!tabDestinatario.edtDataEmissao || nota_fiscal.entrada_nota_etapa"></InputDate>
              </v-col>
              <v-col cols="12" md="3">
                <span>Valor Total da Nota:</span>
                <InputMoney :value="nota_fiscal.total.valorProdutos" disabled></InputMoney>
              </v-col>
            </v-row>
          </v-container>
        </v-tab-item>

        <v-tab-item>
          <v-row>
            <v-card flat>
              <v-card-text>
                <v-row> </v-row>
                <v-row>
                  <v-col cols="12" md="3">
                    <span>CNPJ:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.cnpjcpf" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="2">
                    <span>Código:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.codigo" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="2" class="mt-5">
                    <v-btn :disabled="!tabFornecedor.btnPesquisar || nota_fiscal.entrada_nota_etapa" color="primary" @click="localizarFornecedor">
                      <v-icon left>mdi-magnify</v-icon>
                      Pesquisar
                    </v-btn>
                  </v-col>
                  <v-col cols="12" md="2" class="mt-5">
                    <v-btn :disabled="nota_fiscal.entrada_nota_etapa" color="primary" @click="abrirDialogFornecedor">
                      <v-icon left>+</v-icon>
                      Novo Fornecedor
                    </v-btn>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="12" md="12">
                    <span>Nome/Razão Social:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.nome" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="12" md="12">
                    <span>Nome Fantasia:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.nome_fantasia" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="12" md="3">
                    <span>Inscri. Estadual:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.ierg" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="3">
                    <span>Telefone:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.telefone" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="12" md="2">
                    <span>CEP:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.cep" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="2">
                    <span>UF:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.uf" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="3">
                    <span>Cidade:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.cidade" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                  <v-col cols="12" md="3">
                    <span>Bairro:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.bairro" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                </v-row>
                <v-row>
                  <v-col cols="12" md="12">
                    <span>Logradouro:</span>
                    <input class="form-control" disabled v-model="nota_fiscal.fornecedor.logradouro" :class="{ 'is-invalid': !isFornecedorExists() }" />
                  </v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-row>
        </v-tab-item>
        <v-tab-item>
          <v-card flat>
            <v-card-text>
              <v-row>
                <v-card-actions class="justify-end">
                  <v-btn color="primary" :disabled="!tabProduto.btnAdicionarProdutos || nota_fiscal.entrada_nota_etapa" @click="adicionarProdutosManual">Adicionar Produtos</v-btn>
                </v-card-actions>
              </v-row>
              <v-divider></v-divider>
              <v-data-table :headers="headers" density="compact" :items="nota_fiscal.items" :items-per-page="10" class="elevation-1" :key="updateTable">
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
                    <v-btn v-if="!item.associacao.itemManual" color="primary" icon class="ml-2" :disabled="nota_fiscal.entrada_nota_etapa" @click="abrirDialogAssociar(item)" title="Associar produto">
                      <v-icon>mdi-link-plus</v-icon>
                    </v-btn>
                  </div>
                </template>
                <template v-slot:item.quantidadeComercial="{ item }">
                  <InputQuantity :disabled="nota_fiscal.entrada_nota_etapa" @input="nota_fiscal.calcularTotal()" v-model="item.quantidadeComercial"></InputQuantity>
                </template>
                <template v-slot:item.valorUnitario="{ item }">
                  <InputMoney :disabled="nota_fiscal.entrada_nota_etapa" @input="nota_fiscal.calcularTotal()" v-model="item.valorUnitario"></InputMoney>
                </template>
                <template v-slot:item.valorProdutos="{ item }">
                  <InputMoney :disabled="true" :value="item.valorProdutos"></InputMoney>
                </template>
                <template v-slot:item.porcentagemIcms="{ item }">
                  <InputQuantity :disabled="true" :value="item.imposto.icms.porcentagemIcms"></InputQuantity>
                </template>

                <template v-slot:item.qtdEstoque="{ item }">
                  <InputQuantity :value="item.quantidadeEstoque()" :disabled="true"></InputQuantity>
                </template>
                <template v-slot:item.itensEmbalagem="{ item }">
                  <InputQuantity
                    @input="
                      () => {
                        nota_fiscal.calcularTotal();
                        item.associacao.validate();
                      }
                    "
                    v-model="item.associacao.qtd_fornecedor"
                    :disabled="!item.associacao.isAssociado() || nota_fiscal.entrada_nota_etapa"
                  ></InputQuantity>
                </template>
                <template v-slot:item.cst="{ item }"> <InputText :disabled="true" :value="item.imposto.icms.cst"></InputText> </template>
              </v-data-table>
            </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <!-- FRETE -->
          <v-card flat>
            <v-card-text>
              <v-row>
                <span>Total Frete:</span>
                <v-col cols="12" md="4">
                  <InputMoney :disabled="nota_fiscal.entrada_nota_etapa" @input="nota_fiscal.calcularTotal()" v-model="nota_fiscal.total.valorFrete"></InputMoney>
                </v-col>
              </v-row>
            </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card flat>
            <v-card-text>
              <!-- Conteúdo da aba Totais -->
              <v-row>
                <v-col cols="12" md="3">
                  <span>Base de Cálculo ICMS:</span>
                  <InputMoney v-model="nota_fiscal.total.baseCalculoIcms" disabled></InputMoney>
                </v-col>

                <v-col cols="12" md="3">
                  <span>Valor ICMS:</span>
                  <InputMoney v-model="nota_fiscal.total.valorIcms" disabled />
                </v-col>
                <v-col cols="12" md="3">
                  <span>Base de cálculo ICMS ST:</span>
                  <InputMoney v-model="nota_fiscal.total.baseCalculoIcmsST" disabled />
                </v-col>
                <v-col cols="12" md="3">
                  <span>Valor ICMS Substituição:</span>
                  <InputMoney v-model="nota_fiscal.total.valorIcmsST" disabled />
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" md="3">
                  <span>Valor Total Produtos:</span>
                  <InputMoney v-model="nota_fiscal.total.valorProdutos" disabled></InputMoney>
                </v-col>
                <v-col cols="12" md="3">
                  <span>Valor Frete:</span>
                  <InputMoney v-model="nota_fiscal.total.valorFrete" disabled />
                </v-col>
                <v-col cols="12" md="3">
                  <span>Valor Seguro:</span>
                  <InputMoney v-model="nota_fiscal.total.valorSeguro" disabled />
                </v-col>
                <v-col cols="12" md="3">
                  <span>Outras Despesas:</span>
                  <InputMoney v-model="nota_fiscal.total.valorOutrasDespesas" disabled />
                </v-col>
              </v-row>
              <v-row>
                <v-col cols="12" md="3">
                  <span>Valor Total do IPI:</span>
                  <InputMoney v-model="nota_fiscal.total.valorIPI" disabled />
                </v-col>
                <v-col cols="12" md="3">
                  <span>Valor Total da Nota:</span>
                  <InputMoney v-model="nota_fiscal.total.valorNota" disabled />
                </v-col>
              </v-row>
            </v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs-items>
      <!-- Contas a pagar -->
      <v-dialog v-model="dialogLocalizarFornecedor">
        <LocalizarFornecedor @selecionar="selecionarFornecedor"></LocalizarFornecedor>
      </v-dialog>
      <v-dialog v-model="dialogLocalizarLoja">
        <LocalizarLoja @selecionar="selecionarLoja"></LocalizarLoja>
      </v-dialog>
    </v-card>
    <AssociarProdutoFornecedor @atualizar-form="atualizarForm" ref="dialogAssociarProdutoFornecedor"></AssociarProdutoFornecedor>
    <ModalCadastroFornecedor ref="dialogFornecedor" />
    <v-dialog v-model="dialogAdicionarProdutos">
      <AdicionarItensNotaFiscal @gravar="gravarProdutosManual"></AdicionarItensNotaFiscal>
    </v-dialog>
  </div>
</template>

<script>
import InputQuantity from "@/components/Input/InputQuantity.vue";
import ModalCadastroFornecedor from "@/views/Fornecedor/ModalCadastroFornecedor.vue";
import CadastroProduto from "@/views/ProdutoRefact/CadastroProduto.vue";
import AssociarProdutoFornecedor from "./Associar/AssociarProdutoFornecedor.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import { NotaFiscal } from "@/infra/entity/NotaFiscal";
import Fornecedor from "@/infra/entity/Fornecedor";
import ToastService from "@/infra/service/ToastService";
import InputText from "@/components/Input/InputText.vue";
import EditarContasAPagar from "@/views/Financeiro/ContasAPagar/EditarContasAPagar.vue";
import FornecedorService from "@/infra/service/FornecedorService";
import LocalizarFornecedor from "@/views/Fornecedor/LocalizarFornecedor.vue";
import LocalizarLoja from "@/views/Loja/LocalizarLoja.vue";
import LojaService from "@/infra/service/LojaService";
import InputNumber from "@/components/Input/InputNumber.vue";
import InputDate from "@/components/Input/InputDate.vue";
import AdicionarItensNotaFiscal from "./AdicionarItensNotaFiscal.vue";

export default {
  inject: ["notaFiscalEntradaController", "fornecedorController", "produtoController"],
  components: {
    AdicionarItensNotaFiscal,
    EditarContasAPagar,
    InputText,
    ModalCadastroFornecedor,
    InputQuantity,
    CadastroProduto,
    AssociarProdutoFornecedor,
    InputMoney,
    LocalizarFornecedor,
    LocalizarLoja,
    InputNumber,
    InputDate,
  },

  mounted() {
    if (this.$route.params.chave.toLocaleUpperCase() === "MANUAL") {
      this.estado = "MANUAL";
      this.controlaInterface();
    }
  },
  methods: {
    gravarProdutosManual(itens) {
      this.nota_fiscal.items = itens;
      this.nota_fiscal.calcularTotal();
      this.dialogAdicionarProdutos = false;
    },
    adicionarProdutosManual() {
      this.dialogAdicionarProdutos = true;
    },
    controlaInterface() {
      if (this.estado === "MANUAL") {
        this.tabDestinatario.edtCodLoja = true;
        this.tabDestinatario.btnLocalizarLoja = true;
        this.tabDestinatario.edtNumeroNFe = true;
        this.tabDestinatario.edtSerie = true;
        this.tabDestinatario.edtModelo = true;
        this.tabDestinatario.edtDataEmissao = true;
        this.tabDestinatario.edtChaveXML = true;

        this.tabFornecedor.btnPesquisar = true;

        this.tabProduto.btnAdicionarProdutos = true;

        this.$refs.dialogFornecedor.insertMode = true;
      }
    },
    async carregarLoja() {
      const loja = await LojaService.getByCodigo(this.nota_fiscal.loja.codigo);
      this.nota_fiscal.loja = loja;
    },

    localizarLoja() {
      this.dialogLocalizarLoja = true;
    },
    selecionarLoja(loja) {
      this.dialogLocalizarLoja = false;
      this.nota_fiscal.loja = loja;
    },

    selecionarFornecedor(fornecedor) {
      this.dialogLocalizarFornecedor = false;
      this.nota_fiscal.fornecedor = fornecedor;
    },
    localizarFornecedor() {
      this.dialogLocalizarFornecedor = true;
    },
    async efetivarNota() {
      await this.notaFiscalEntradaController.efetivarNota({ nota: this.nota_fiscal });
      ToastService.showSuccess("Nota efetivada com sucesso !");
    },

    async abrirDialogFornecedor() {
      if (this.estado === "MANUAL") {
        this.nota_fiscal.fornecedor = new Fornecedor();
      }
      await this.$refs.dialogFornecedor.abrir(this.nota_fiscal.fornecedor);
      const fornecedor = await FornecedorService.getByCNPJCPF(this.nota_fiscal.fornecedor.cnpjcpf);
      this.nota_fiscal.fornecedor.codigo = fornecedor.codigo;
    },
    async gravarFornecedor() {
      await this.nota_fiscal.fornecedorController.insert({ fornecedor: this.nota_fiscal.fornecedor });
      const fornecedor = await FornecedorService.getByCNPJCPF(this.nota_fiscal.fornecedor.cnpjcpf);
      this.nota_fiscal.fornecedor.codigo = fornecedor.codigo;
      ToastService.showSuccess("Fornecedor Inserido com Sucesso");
    },

    async abrirDialogAssociar(item) {
      if (!this.isFornecedorExists()) return ToastService.showError("Fornecedor Não Associado !");
      this.$refs.dialogAssociarProdutoFornecedor.abrir(this.nota_fiscal, this.nota_fiscal.fornecedor, item);
    },

    isFornecedorExists() {
      return this.nota_fiscal.fornecedor.codigo !== "";
    },
    atualizarForm() {
      this.updateTable++;
    },
  },
  data() {
    return {
      dialogAdicionarProdutos: false,
      dialogLocalizarFornecedor: false,
      dialogLocalizarLoja: false,
      nota_fiscal: new NotaFiscal(),
      updateTable: 0,
      headers: [
        { text: "Nº", value: "numeroItem" },
        { text: "Produto", value: "descricao" },
        { text: "Quantidade", value: "quantidadeComercial" },
        { text: "Vlr. Unitário", value: "valorUnitario" },
        { text: "Total", value: "valorProdutos" },
        { text: "Associação", value: "associacao" },
        { text: "Qtd. Embalagem", value: "itensEmbalagem" },
        { text: "Qtd. Estoque", value: "qtdEstoque" },
        { text: "CFOP", value: "cfop" },
        { text: "ICMS", value: "porcentagemIcms" },
        { text: "CST", value: "cst" },
      ],
      estado: "",
      xmlSelecionado: null,
      tabEditar: 0,
      dialogAssociar: false,
      modalProduto: false,
      modalContasPagar: false,

      tabDestinatario: {
        edtCodLoja: false,
        btnLocalizarLoja: false,
        edtNumeroNFe: false,
        edtSerie: false,
        edtModelo: false,
        edtDataEmissao: false,
        edtChaveXML: false,
      },
      tabFornecedor: {
        btnPesquisar: false,
      },
      tabProduto: {
        btnAdicionarProdutos: false,
      },
    };
  },
};
</script>

<style scoped>
.selected-row {
  background-color: #e0f7fa !important; /* azul claro */
}
</style>
