<template>
  <div>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <div>
          <span>Contas A Pagar</span>
        </div>
      </v-card-title>
      <v-container>
        <v-row>
          <v-col cols="12" sm="5">
            <label class="form-label" for="input-example">Loja:</label>
            <v-autocomplete placeholder="Selecione a Loja" dense outlined v-model="contaPagar.lojaId" density="compact" :items="lojas" item-text="nome" item-value="codigo"></v-autocomplete>
          </v-col>
          <v-col cols="12" sm="5">
            <label class="form-label" for="input-example">Fornecedor:</label>
            <v-autocomplete
              placeholder="Selecione o Fornecedor"
              dense
              outlined
              v-model="contaPagar.fornecedorId"
              density="compact"
              :items="fornecedores"
              item-text="nome"
              item-value="codigo"
            ></v-autocomplete>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" sm="4">
            <label class="form-label" for="input-example">Descrição:</label>
            <InputText v-model="contaPagar.descricao"></InputText>
          </v-col>
          <v-col cols="12" sm="4">
            <label class="form-label" for="input-example">Número Documento:</label>
            <InputNumber v-model="contaPagar.numeroDocumento"></InputNumber>
          </v-col>
          <v-col cols="12" sm="2">
            <label class="form-label" for="input-example">Data Vencimento:</label>
            <InputDate v-model="contaPagar.dataVencimento" @typing="atualizarInterface"></InputDate>
          </v-col>
          <v-col cols="12" sm="2">
            <label class="form-label" for="input-example">Data Emissão:</label>
            <InputDate v-model="contaPagar.dataEmissao" @typing="atualizarInterface"></InputDate>
          </v-col>
        </v-row>

        <v-row>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Nominal:</label>
            <InputMoney v-model="contaPagar.valorNominal" @input="contaPagar.atualizar()"></InputMoney>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Acréscimo:</label>
            <InputMoney v-model="contaPagar.acrescimo" @input="contaPagar.atualizar()"></InputMoney>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Desconto:</label>
            <InputMoney v-model="contaPagar.desconto" @input="contaPagar.atualizar()"></InputMoney>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Valor Total:</label>
            <InputMoney disabled :value="contaPagar.valorTotal()"></InputMoney>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Tipo:</label>
            <select
              v-model="contaPagar.tipoIntervalo"
              id="comboSelect"
              @change="
                () => {
                  contaPagar.intervalo = 1;
                  contaPagar.parcelas = 1;
                }
              "
              class="form-select"
            >
              <option disabled value="">Selecione...</option>
              <option value="mes">Mês</option>
              <option value="dias">Dias</option>
            </select>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Intervalo:</label>
            <InputNumber v-model="contaPagar.intervalo" @input="contaPagar.atualizar()"></InputNumber>
          </v-col>
          <v-col cols="12" sm="3">
            <label class="form-label" for="input-example">Parcelas:</label>
            <InputNumber v-model="contaPagar.parcelas" @input="contaPagar.atualizar()"></InputNumber>
          </v-col>
        </v-row>

        <v-card-title>Títulos</v-card-title>
        <v-data-table :headers="headerTitulos" :items="contaPagar.titulos.items" :key="key">
          <template v-slot:item.vencimento="{ item }">
            <span>{{ new Date(item.vencimento).toLocaleDateString("pt-BR") }}</span>
          </template>

          <template v-slot:item.valor="{ item }">
            <InputMoney disabled :value="item.valor" />
          </template>
        </v-data-table>
        <v-card-title>Categoria Financeira:</v-card-title>
        <v-row>
          <v-col cols="12" sm="4" class="mt-5">
            <v-autocomplete
              outlined
              dense
              :items="categorias"
              return-object
              label="Selecione a categoria"
              v-model="sub_categoria_selecionada"
              :item-text="
                (item) => {
                  return `${item.categoria_codigo} - ${item.categoria_nome} > ${item.sub_categoria_codigo} - ${item.sub_categoria_nome}`;
                }
              "
            ></v-autocomplete>
          </v-col>
          <v-col cols="12" sm="2">
            %
            <InputQuantity v-model="contaPagar.categoriaFinanceira.percentual" @keyup="contaPagar.categoriaFinanceira.atualizarValorPorPercentual(contaPagar.valorTotal())"></InputQuantity>
          </v-col>
          <v-col cols="12" sm="2">
            Valor:

            <InputMoney type="text" v-model="contaPagar.categoriaFinanceira.valor" @keyup="contaPagar.categoriaFinanceira.atualizarPercentualPorValor(contaPagar.valorTotal())"></InputMoney>
          </v-col>
          <v-col cols="12" sm="2" class="mt-6">
            <v-btn color="primary" @click="adicionarSubCategoriaFinanceira">+</v-btn>
          </v-col>
        </v-row>
        <v-row>
          <v-data-table :headers="headerCategoriaRateio" :items="contaPagar.categoriaFinanceiraList">
            <template v-slot:item.valor="{ item }">
              <InputMoney disabled :value="item.valor" />
            </template>
            <template v-slot:item.actions="{ item }">
              <v-btn icon color="red" @click="removerCategoria(item)">
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </template>
          </v-data-table>
        </v-row>
        <v-row>
          <v-col cols="12" sm="3">
            <v-btn color="primary" @click="gravar">Gravar</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import InputDate from "@/components/Input/InputDate.vue";
import InputMoney from "@/components/Input/InputMoney.vue";
import InputNumber from "@/components/Input/InputNumber.vue";
import InputPercentage from "@/components/Input/InputPercentage.vue";
import InputQuantity from "@/components/Input/InputQuantity.vue";
import InputText from "@/components/Input/InputText.vue";
import ContaPagar from "@/infra/entity/ContaPagar";
import ContaPagarService from "@/infra/service/ContaPagarService";
import FornecedorService from "@/infra/service/FornecedorService";
import LojaService from "@/infra/service/LojaService";
import SubCategoriaFinanceiraService from "@/infra/service/SubCategoriaFinanceiraService";
export default {
  async mounted() {
    await this.carregar();
  },
  data() {
    return {
      lojas: [],
      key: 0,
      contaPagar: new ContaPagar(),
      fornecedores: [],
      sub_categoria_selecionada: null,
      categorias: [],
      headerCategoriaRateio: [
        { text: "Categoria", value: "subcategoria_nome" },
        { text: "Percentual %", value: "percentual" },
        { text: "Valor", value: "valor" },
        { text: "Ações", value: "actions", sortable: false },
      ],
      headerTitulos: [
        {
          text: "Parcela",
          value: "seq",
        },
        {
          text: "Vencimento",
          value: "vencimento",
        },
        {
          text: "Valor",
          value: "valor",
        },
      ],
    };
  },
  methods: {
    adicionarSubCategoriaFinanceira() {
      if (!this.sub_categoria_selecionada) throw new Error("Selecione a categoria financeira");
      this.contaPagar.categoriaFinanceira.subcategoria_nome = this.sub_categoria_selecionada.sub_categoria_nome;
      this.contaPagar.categoriaFinanceira.subcategoria_id = this.sub_categoria_selecionada.sub_categoria_codigo;

      this.contaPagar.categoriaFinanceira.categoria_nome = this.sub_categoria_selecionada.categoria_nome;
      this.contaPagar.categoriaFinanceira.categoria_codigo = this.sub_categoria_selecionada.categoria_codigo;

      this.contaPagar.adicionarCategoriaFinanceira();
    },
    removerCategoria(item) {
      this.contaPagar.removerCategoriaFinanceira(item);
      console.log("remover", item);
    },
    atualizarInterface() {
      this.contaPagar.atualizar();
      this.key += 1;
    },
    novo() {
      this.contaPagar = new ContaPagar();
    },
    editarTitulo(titulo) {
      this.contaPagar = titulo;
    },
    async carregarConta(codigo) {
      this.contaPagar = await ContaPagarService.getByCodigo(codigo);
    },
    async carregar() {
      const output_lojas = await LojaService.getAll();
      const output_fornecedores = await FornecedorService.getAll();
      const output_categorias = await SubCategoriaFinanceiraService.getAllCategoriaWithSubCategoria();

      this.lojas = output_lojas.lojas;
      this.fornecedores = output_fornecedores.fornecedores;
      this.categorias = output_categorias;
    },
    async abrir(conta) {
      await this.carregar();
      this.contaPagar = conta;
      this.contaPagar.atualizar();
    },

    async gravar() {
      await ContaPagarService.insert(this.contaPagar);
      // this.novo();
      this.$emit("gravar");
    },
  },

  components: {
    InputMoney,
    InputText,
    InputNumber,
    InputDate,
    InputPercentage,
    InputQuantity,
  },
};
</script>

<style lang="scss" scoped></style>
