import Fornecedor from "./Fornecedor";
import Loja from "./Loja";
import { NotaFiscalItem } from "./NotaFiscalItem";
export class NotaFiscal {
  constructor(
    public naturezaOperacao: string = "",
    public nrNota: string = "",
    public serie: string = "",
    public modelo: string = "",
    public tipoAmbiente: string = "",
    public tipoOperacao: string = "",
    public operacao: string = "",
    public dataEmissao: Date = new Date(),
    public dataEntradaSaida: string = "",
    public protocolo: Protocolo = new Protocolo(),
    public emitente: Emitente = new Emitente(),
    public destinatario: Destinatario = new Destinatario(),
    public total: Total = new Total(),
    public informacoesComplementares: string = "",
    public informacoesFisco: string = "",
    public nrObservacoes: number = 0,
    public observacoes: Observacao[] = [],
    public items: NotaFiscalItem[] = [],
    public loja: Loja = new Loja(),
    public situacao: string = "",
    public entrada_nota_etapa: boolean = false,
    public lancamento_financeiro_etapa: boolean = false,
    public alteracao_precos_etapa: boolean = false,
    public romaneio_etapa: boolean = false,
    public fornecedor: Fornecedor = new Fornecedor(),
    public transportadora: Fornecedor = new Fornecedor(),
    public notaManual: boolean = false
  ) {}
  validate() {
    if (this.loja.codigo.trim() === "") throw new Error("Loja Destinatário em branco !");
    if (this.fornecedor.codigo.trim() === "") throw new Error("Fornecedor em branco !");
    if (this.items.length === 0) throw new Error("Nenhum item preenchido !");

    if (this.protocolo.chave.trim() === "") throw new Error("Nota Fiscal sem Chave");
    for (const item of this.items) {
      item.associacao.validate();
    }
  }
  observacao(index: number): Observacao {
    return this.observacoes[index];
  }
  calcularTotal() {
    // Primeiro, recalcula os totais de cada item individualmente
    for (const item of this.items) {
      item.calcularTotal();
    }

    // Soma dos produtos
    this.total.valorProdutos = this.items.reduce((acum, item) => {
      return acum + item.valorProdutos;
    }, 0);

    // Recalcula o valor total da nota considerando todos os componentes
    const { valorProdutos, valorFrete, valorSeguro, valorDesconto, valorII, valorIPI, valorPIS, valorCOFINS, valorOutrasDespesas } = this.total;

    this.total.valorNota = valorProdutos + valorFrete + valorIPI + this.total.valorIcmsST;
    // this.total.valorNota = valorProdutos + valorFrete +
    // console.log(valorProdutos, valorFrete, valorSeguro, valorII, valorIPI, valorPIS, valorCOFINS, valorOutrasDespesas, valorDesconto);
  }

  rateioFrete() {
    return this.total.valorFrete / this.items.length;
  }
  rateioDesconto() {
    return this.total.valorDesconto / this.items.length;
  }
  itensNaoAssociados(): NotaFiscalItem[] {
    return this.items.filter((item: NotaFiscalItem) => !item.associacao.isAssociado());
  }
}
export class Protocolo {
  constructor(public dataHoraRecebimento: string = "", public protocolo: string = "", public chave: string = "", public tipoAmbiente: string = "", public codigoStatusResposta: string = "") {}
}

export class Emitente {
  constructor(
    public nome: string = "",
    public fantasia: string = "",
    public email: string = "",
    public cpf: string = "",
    public cnpj: string = "",
    public inscricaoNacional: string = "",
    public inscricaoMunicipal: string = "",
    public inscricaoEstadual: string = "",
    public inscricaoEstadualST: string = "",
    public codigoRegimeTributario: string = "",
    public endereco: Endereco = new Endereco()
  ) {}
}

export class Destinatario {
  constructor(
    public nome: string = "",
    public fantasia: string = "",
    public email: string = "",
    public cpf: string = "",
    public cnpj: string = "",
    public inscricaoNacional: string = "",
    public inscricaoMunicipal: string = "",
    public inscricaoEstadual: string = "",
    public inscricaoEstadualST: string = "",
    public endereco: Endereco = new Endereco()
  ) {}
}

export class Endereco {
  constructor(
    public uf: string = "",
    public cep: string = "",
    public logradouro: string = "",
    public numero: string = "",
    public bairro: string = "",
    public complemento: string = "",
    public municipio: string = "",
    public codigoMunicipio: string = "",
    public pais: string = "",
    public codigoPais: string = "",
    public telefone: string = ""
  ) {}
}

export class Total {
  constructor(
    public baseCalculoIcms: number = 0,
    public valorIcms: number = 0,
    public valorIcmsDesonerado: number = 0,
    public baseCalculoIcmsST: number = 0,
    public baseCalculoIcmsSTRetido: number = 0,
    public valorIcmsST: number = 0,
    public valorIcmsSTRetido: number = 0,
    public valorProdutos: number = 0,
    public valorFrete: number = 0,
    public valorSeguro: number = 0,
    public valorDesconto: number = 0,
    public valorII: number = 0,
    public valorIPI: number = 0,
    public valorPIS: number = 0,
    public valorCOFINS: number = 0,
    public valorOutrasDespesas: number = 0,
    public valorNota: number = 0,
    public valorTotalTributos: number = 0
  ) {}
}

class Observacao {
  constructor(public texto: string = "", public campoObservacao: string = "") {}
}
