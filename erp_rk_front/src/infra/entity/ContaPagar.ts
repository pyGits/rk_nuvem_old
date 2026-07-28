// ContaPagar.ts

import ContaPagarTitulo from "./ContaPagarTitulo";
import ContaPagarTituloList from "./ContaPagarTituloList";

export class SubCategoriaRateio {
  subcategoria_id: string;
  subcategoria_nome: string;

  categoria_codigo: string;
  categoria_nome: string;

  percentual: number;
  valor: number;

  constructor() {
    this.subcategoria_id = "";
    this.subcategoria_nome = "";
    this.categoria_codigo = "";
    this.categoria_nome = "";
    this.percentual = 0;
    this.valor = 0;
  }

  atualizarValorPorPercentual(valorTotal: number): void {
    this.valor = (valorTotal * this.percentual) / 100;
  }

  atualizarPercentualPorValor(valorTotal: number): void {
    this.percentual = valorTotal > 0 ? (this.valor / valorTotal) * 100 : 0;
  }

  clone(): SubCategoriaRateio {
    const clone = new SubCategoriaRateio();
    clone.subcategoria_id = this.subcategoria_id;
    clone.subcategoria_nome = this.subcategoria_nome;
    clone.categoria_codigo = this.categoria_codigo;
    clone.categoria_nome = this.categoria_nome;
    clone.percentual = this.percentual;
    clone.valor = this.valor;
    return clone;
  }
}

export default class ContaPagar {
  constructor(
    public lojaId = "",
    public fornecedorId = "",
    public numeroDocumento = "",
    public dataVencimento = new Date(),
    public valorNominal = 0,
    public acrescimo = 0,
    public desconto = 0,
    public parcelas = 1,
    public intervalo = 1,
    public titulos = new ContaPagarTituloList(),
    public descricao = "",
    public tipoIntervalo = "mes",
    public codigo = "",
    public dataEmissao = new Date(),
    public categoriaFinanceira = new SubCategoriaRateio(),
    public categoriaFinanceiraList: SubCategoriaRateio[] = []
  ) {}

  atualizar() {
    this.gerarTitulos();
    this.atualizarValoresRateio();
  }

  atualizarValorCategoriaFinanceira() {
    this.categoriaFinanceira.atualizarValorPorPercentual(this.valorNominal);
  }

  atualizarPercentualCategoriaFinanceira() {
    this.categoriaFinanceira.atualizarPercentualPorValor(this.valorNominal);
  }

  atualizarValoresRateio() {
    for (const categoria of this.categoriaFinanceiraList) {
      categoria.atualizarValorPorPercentual(this.valorNominal);
    }

    // Soma valores das subcategorias da lista
    const somaRateio = this.valorTotalCategoriaFinanceiraRateio();

    // Calcula restante
    const restante = this.valorNominal - somaRateio;

    // Atualiza categoriaFinanceira principal com o restante
    this.categoriaFinanceira.valor = restante > 0 ? restante : 0;
    this.categoriaFinanceira.percentual = this.valorNominal > 0 ? (this.categoriaFinanceira.valor / this.valorNominal) * 100 : 0;
  }

  adicionarCategoriaFinanceira() {
    if (this.categoriaFinanceira.subcategoria_id.trim() === "") throw new Error("Selecione a categoria financeira");
    // Valida se percentual e valor são maiores que zero
    if (this.categoriaFinanceira.valor <= 0) {
      throw new Error("Valor deve ser maior que zero");
    }

    const valorAtualTotal = this.valorTotalCategoriaFinanceiraRateio();
    // const percentualAtualTotal = this.categoriaFinanceiraList.reduce((soma, cat) => soma + cat.percentual, 0);

    // Valida se o valor ultrapassa o valor nominal
    if (valorAtualTotal + this.categoriaFinanceira.valor > this.valorNominal) {
      throw new Error("Valor excede o total");
    }

    // Valida se o percentual ultrapassa 100%
    // if (percentualAtualTotal + this.categoriaFinanceira.percentual > 100) {
    //   throw new Error("Valor excede o percentual total");
    // }

    // Se passar nas validações, adiciona
    const nova = this.categoriaFinanceira.clone();
    this.categoriaFinanceiraList.push(nova);

    // Limpa os inputs para nova categoria
    this.categoriaFinanceira = new SubCategoriaRateio();
    this.atualizar();
  }
  removerCategoriaFinanceira(categoria: SubCategoriaRateio) {
    const index = this.categoriaFinanceiraList.indexOf(categoria);
    if (index > -1) {
      this.categoriaFinanceiraList.splice(index, 1);
      this.atualizar();
    }
  }

  valorTotalCategoriaFinanceiraRateio() {
    return this.categoriaFinanceiraList.reduce((soma, cat) => soma + cat.valor, 0);
  }

  validateCategoriaFinanceiraRateio() {
    if (this.categoriaFinanceiraList.length !== 0) {
      if (this.valorTotalCategoriaFinanceiraRateio() < this.valorTotal()) {
        throw new Error(`Somatório do total por categoria ${this.valorTotalCategoriaFinanceiraRateio()} diverge do total: ${this.valorTotal()}`);
      }
    }
  }

  valorTotal() {
    return this.valorNominal + this.acrescimo - this.desconto;
  }

  validate() {
    if (this.numeroDocumento.trim() === "") throw new Error("Número do documento em branco");
    if (this.titulos.items.length === 0) throw new Error("Nenhum Título Gerado");
    if (!this.lojaId) throw new Error("Loja não selecionada");
    if (this.descricao.trim() === "") throw new Error("Descrição obrigatória");
    if (this.valorTotal() <= 0) throw new Error("Total não pode ser 0 ou negativo");
    this.validateCategoriaFinanceiraRateio();
  }

  gerarTitulos() {
    if (this.tipoIntervalo === "mes") this.gerarTitulosMes();
    if (this.tipoIntervalo === "dias") this.gerarTitulosDias();
  }

  gerarTitulosDias() {
    if (this.valorNominal <= 0) throw new Error("Valor nominal não pode ser 0 ou negativo");
    if (this.parcelas <= 0 || this.intervalo <= 0) throw new Error("Parcelas/intervalo inválidos");

    this.titulos.limpar();
    const valorParcela = this.valorTotal() / this.parcelas;

    for (let i = 0; i < this.parcelas; i++) {
      const vencimento = new Date(this.dataVencimento);
      vencimento.setDate(vencimento.getDate() + this.intervalo * i);
      const titulo = new ContaPagarTitulo(i + 1, vencimento, valorParcela);
      this.titulos.adicionarTitulo(titulo);
    }
  }

  gerarTitulosMes() {
    if (this.valorNominal <= 0) throw new Error("Valor nominal não pode ser 0 ou negativo");
    if (this.parcelas <= 0 || this.intervalo <= 0) throw new Error("Parcelas/intervalo inválidos");

    this.titulos.limpar();
    const valorParcela = this.valorTotal() / this.parcelas;

    for (let i = 0; i < this.parcelas; i++) {
      const vencimento = new Date(this.dataVencimento);
      vencimento.setMonth(vencimento.getMonth() + this.intervalo * i);
      const titulo = new ContaPagarTitulo(i + 1, vencimento, valorParcela);
      this.titulos.adicionarTitulo(titulo);
    }
  }
}
