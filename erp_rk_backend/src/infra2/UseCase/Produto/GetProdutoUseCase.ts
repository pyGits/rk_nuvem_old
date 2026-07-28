import ProdutoBuilder from "../../Builder/ProdutoBuilder";
import ProdutoModel from "../../../../../erp_rk_shared/Entity/ProdutoModel";
import ILojaRepository from "../../Repository/LojaRepository";
import { IPrecoRepository } from "../../Repository/PrecoRepository";
import { IProdutoRepository } from "../../Repository/ProdutoRepository";
import { ITributacaoRepository } from "../../Repository/TributacaoRepository";
import { IEstoqueRepository } from "../../Repository/EstoqueRepository";
import { INCMRepository } from "../../Repository/NCMRepository";
import { ICESTRepository } from "../../Repository/CESTRepository";
import PrecoCollectionBuilder from "../../Builder/PrecoCollectionBuilder";
import EstoqueCollectionBuilder from "../../Builder/EstoqueCollectionBuilder";
export enum TipoPesquisaProduto {
  codigo = "codigo",
  codigo_barras = "codigo_barras",
}
export interface GetProdutoInput {
  tipo: TipoPesquisaProduto;
  valor: string;
  tenantId: number;
}

export default class GetProdutoUseCase {
  produtoRepository: IProdutoRepository;
  precoRepository: IPrecoRepository;
  lojaRepository: ILojaRepository;
  tributacaoRepository: ITributacaoRepository;
  estoqueRepository: IEstoqueRepository;
  ncmRepository: INCMRepository;
  cestRepository: ICESTRepository;
  constructor(produtoRepository: IProdutoRepository, precoRepository: IPrecoRepository, lojaRepository: ILojaRepository, tributacaoRepository: ITributacaoRepository, estoqueRepository: IEstoqueRepository, ncmRepository: INCMRepository, cestRepository: ICESTRepository) {
    this.produtoRepository = produtoRepository;
    this.precoRepository = precoRepository;
    this.lojaRepository = lojaRepository;
    this.tributacaoRepository = tributacaoRepository;
    this.estoqueRepository = estoqueRepository;
    this.ncmRepository = ncmRepository;
    this.cestRepository = cestRepository;
  }
  async execute(input: GetProdutoInput): Promise<ProdutoModel> {
    switch (input.tipo) {
      case TipoPesquisaProduto.codigo:
        const produto = await this.produtoRepository.getByCodigo(input.valor, input.tenantId);
        const precos = await this.precoRepository.getByCodigoProduto(produto.codigo, input.tenantId);
        const lojas = await this.lojaRepository.getAll(input.tenantId);
        const tributacao = await this.tributacaoRepository.getByCodigo(produto.tributacao.codigo, input.tenantId);
        const estoques = await this.estoqueRepository.getByCodigoProduto(produto.codigo, input.tenantId);

        // Carrega NCM e CEST completos
        const ncm = await this.ncmRepository.getByCodigo(produto.ncm.codigo);
        const cest = await this.cestRepository.getByCodigo(produto.cest.codigo);

        const precosBuilder = new PrecoCollectionBuilder();
        precosBuilder.withPrecos(precos);
        precosBuilder.withLojas(lojas);

        const estoqueBuilder = new EstoqueCollectionBuilder();
        estoqueBuilder.withEstoques(estoques);
        estoqueBuilder.withLojas(lojas);

        const produtos = new ProdutoBuilder();
        produtos.withProduto(produto);
        produtos.withPrecos(precosBuilder.build());
        produtos.withTributacao(tributacao);
        produtos.withEstoques(estoqueBuilder.build());
        if (ncm) produtos.withNCM(ncm);
        if (cest) produtos.withCEST(cest);

        return produtos.build();

      case TipoPesquisaProduto.codigo_barras:
        throw new Error("Implementar pesquisa por código de barras");
      default:
        throw new Error("Tipo de pesquisa inválido");
    }
  }
}
