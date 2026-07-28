import CESTModel from "./CESTModel";
import { CustomErrorModel } from "./CustomErrorModel";
import EstoqueCollectionModel from "./EstoqueCollectionModel";
import NCMModel from "./NCMModel";
import PrecoCollectionModel from "./PrecoCollectionModel";
import TributacaoModel from "./TributacaoModel";

export default class ProdutoModel {
  codigo: string;
  codigo_barras: string;
  descricao: string;
  secao: string;
  grupo: string;
  fornecedor: string;
  forma_venda: "S" | "N";
  balanca: "S" | "N";
  ativo: "S" | "N";
  diversos: "S" | "N";
  unidade: string;
  balanca_validade: number;
  precos: PrecoCollectionModel;
  tributacao: TributacaoModel;
  ncm: NCMModel;
  cest: CESTModel;
  estoques: EstoqueCollectionModel;

  constructor(
    codigo: string = "",
    codigo_barras: string = "",
    descricao: string = "",
    secao: string = "",
    grupo: string = "",
    fornecedor: string = "",
    unidade: string = "",
    balanca_validade: number = 0,
    forma_venda: "S" | "N" = "N",
    balanca: "S" | "N" = "N",
    ativo: "S" | "N" = "S",
    diversos: "S" | "N" = "N",
    precos: PrecoCollectionModel = new PrecoCollectionModel(),
    tributacao: TributacaoModel = new TributacaoModel(),
    ncm: NCMModel = new NCMModel(),
    cest: CESTModel = new CESTModel(),
    estoques: EstoqueCollectionModel = new EstoqueCollectionModel()
  ) {
    this.codigo = codigo;
    this.codigo_barras = codigo_barras;
    this.descricao = descricao;
    this.secao = secao;
    this.grupo = grupo;
    this.fornecedor = fornecedor;
    this.unidade = unidade;
    this.balanca_validade = balanca_validade;
    this.forma_venda = forma_venda;
    this.balanca = balanca;
    this.ativo = ativo;
    this.diversos = diversos;
    this.precos = precos;
    this.tributacao = tributacao;
    this.ncm = ncm;
    this.cest = cest;
    this.estoques = estoques;
  }

  validate() {
    if (!this.codigo_barras || this.codigo_barras.trim() === "") {
      throw new CustomErrorModel([
        {
          field: "produto.codigo_barras",
          message: "Código de Barras é obrigatório.",
        },
      ]);
    }

    if (!this.descricao || this.descricao.trim() === "") {
      throw new CustomErrorModel([
        { field: "produto.descricao", message: "Descrição é obrigatória." },
      ]);
    }

    if (this.ncm.codigo.trim() === "") {
      throw new CustomErrorModel([
        { field: "produto.ncm", message: "NCM é obrigatório." },
      ]);
    }
    if (this.tributacao.codigo.trim() === "") {
      throw new CustomErrorModel([
        { field: "tributacao.codigo", message: "Tributação é obrigatória." },
      ]);
    }
  }

  static fromDatabase(data: any) {
    return new ProdutoModel(
      data.codigo,
      data.codigo_barras,
      data.descricao,
      data.secao,
      data.grupo,
      data.fornecedor,
      data.unidade,
      data.balanca_validade,
      data.forma_venda,
      data.balanca,
      data.ativo,
      data.diversos,
      undefined,
      new TributacaoModel(data.tributacao),
      new NCMModel(data.ncm),
      new CESTModel(data.cest),
      undefined
    );
  }
}
