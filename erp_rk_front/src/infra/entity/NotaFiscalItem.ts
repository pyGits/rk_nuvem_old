import Produto from "./Produto";

export class ItemDistribuicao {
  constructor(public lojaCodigo: number = 0, public quantidade: number = 0) {}
}

export class NotaFiscalItem {
  constructor(
    public numeroItem: number = 0,
    public codigo: string = "",
    public descricao: string = "",
    public ean: string = "",
    public ncm: string = "",
    public cest: string = "",
    public cfop: number = 0,
    public codigoBeneficioFiscal: string = "",
    public numeroFCI: string = "",
    public unidadeComercial: string = "",
    public valorUnitario: number = 0,
    public unidadeTributavel: string = "",
    public eanTributavel: string = "",
    public quantidadeTributavel: number = 0,
    public quantidadeComercial: number = 0,
    public valorUnitarioTributavel: number = 0,
    public valorOutrasDespesas: number = 0,
    public indicadorTotal: number = 0,
    public codigoANP: string = "",
    public informacoesProduto: string = "",
    public pedido: string = "",
    public numeroItemPedido: string = "",
    public valorProdutos: number = 0,
    public imposto: Imposto = new Imposto(),
    public associacao = new Associacao(),
    public produto = new Produto(),
    public codigo_produto = "",
    public distribuicoes: ItemDistribuicao[] = []
  ) {}

  validate() {
    if (this.quantidadeComercial <= 0) throw new Error("Quantidade não pode ser 0 ou menor");
  }
  calcularTotal() {
    this.valorProdutos = this.quantidadeComercial * this.valorUnitario;
  }

  quantidadeEstoque() {
    return this.quantidadeComercial * this.associacao.qtd_fornecedor;
  }

  // Inicializa a distribuição com 100% na loja padrão (destinatária da nota) caso ainda não exista.
  inicializarDistribuicao(lojaPadrao: number) {
    if (this.distribuicoes && this.distribuicoes.length > 0) return;
    this.distribuicoes = [new ItemDistribuicao(Number(lojaPadrao), this.quantidadeEstoque())];
  }

  totalDistribuido(): number {
    return (this.distribuicoes || []).reduce((acum, d) => acum + Number(d.quantidade || 0), 0);
  }

  distribuicaoValida(): boolean {
    return this.totalDistribuido() === this.quantidadeEstoque();
  }
  // Custo = valorProdutos
  //     + valorFrete
  //     + valorIPI (se não recuperável)
  //     + valorOutrasDespesas
  //     + valorIcmsST (se não recuperável)
  //     - valorDesconto
}

export class Associacao {
  constructor(public codigo_produto = "", public codigo_fornecedor = "", public referencia_fornecedor = "", public unidade_fornecedor = "UN", public qtd_fornecedor = 1, public itemManual = false) {}

  isAssociado() {
    return (this.codigo_produto !== "" && this.codigo_fornecedor !== "" && this.referencia_fornecedor !== "" && this.unidade_fornecedor !== "" && this.qtd_fornecedor !== 0) || this.itemManual;
  }

  validate() {
    if (this.itemManual === true) return;
    if (!this.isAssociado()) throw new Error("Produto Não Associado");
    if (this.codigo_produto.trim() === "") throw new Error("Código do produto em associação não pode estar em branco !");
    if (this.codigo_fornecedor.trim() === "") throw new Error("Codigo do fornecedor em associação em branco !");
    if (this.referencia_fornecedor.trim() === "") throw new Error("Referencia do fornecedor em branco !");
    if (this.unidade_fornecedor.trim() === "") throw new Error("Unidade do Fornecedor em branco !");
    if (this.qtd_fornecedor <= 0) {
      this.qtd_fornecedor = 1;
      throw new Error("Quantidade Fornecedor não pode ser 0 ou menor");
    }
  }
}

export class ICMS {
  constructor(
    public cst: string = "",
    public baseCalculo: number = 0,
    public porcentagemIcms: number = 0,
    public porcentagemIcmsST: number = 0,
    public valorIcms: number = 0,
    public baseCalculoIcmsST: number = 0,
    public valorIcmsST: number = 0,
    public origem: string = "",
    public csosn: string = "",
    public porcentagemMVAST: number = 0,
    public modalidadeBCST: string = "",
    public valorFCP: number = 0,
    public valorFCPST: number = 0,
    public valorFCPSTRetido: number = 0,
    public porcentagemFCP: number = 0,
    public porcentagemFCPST: number = 0,
    public porcentagemFCPSTRetido: number = 0,
    public baseCalculoFCP: number = 0,
    public baseCalculoFCPST: number = 0,
    public baseCalculoFCPSTRetido: number = 0
  ) {}
}

export class IPI {
  constructor(public cst: string = "", public baseCalculo: number = 0, public valorIPI: number = 0, public porcentagemIPI: number = 0) {}
}

export class PIS {
  constructor(public cst: string = "", public baseCalculo: number = 0, public valorPIS: number = 0, public porcentagemPIS: number = 0) {}
}

export class COFINS {
  constructor(public cst: string = "", public baseCalculo: number = 0, public valorCOFINS: number = 0, public porcentagemCOFINS: number = 0) {}
}

export class Imposto {
  constructor(public icms: ICMS = new ICMS(), public ipi: IPI = new IPI(), public pis: PIS = new PIS(), public cofins: COFINS = new COFINS()) {}
}
