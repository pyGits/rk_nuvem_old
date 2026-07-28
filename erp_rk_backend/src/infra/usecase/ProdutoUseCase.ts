import Produto from "../entity/Produto";
import EstoqueRepository from "../repository/EstoqueRepository";
import LojaRepository from "../repository/LojaRepository";
import PrecoRepository from "../repository/PrecoRepository";
import ProdutoRepository from "../repository/ProdutoRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class ProdutoUseCase {
  constructor(readonly produtoRepository: ProdutoRepository, readonly precoRepository: PrecoRepository, readonly lojaRepository: LojaRepository, readonly estoqueRepository: EstoqueRepository) {}
  async getAllByFilter(input: Input): Promise<Output> {
    const list = await this.produtoRepository.getAllByFilter(input.filter, input.tenant_id);
    return { status: 200, data: list };
  }
  async updatePrecosByProdutos(input: Input): Promise<Output> {
    const produtos = input.body as Produto[];
    for (const produto of produtos) {
      this.precoRepository.insertByProduto(produto, input.tenant_id);
    }
    return { status: 200 };
  }
  async insert(input: Input): Promise<Output> {
    const produto = Produto.create(input.body);
    produto.validate();
    const isProdutoExists = await this.produtoRepository.getByCodigoBarras(produto.codigo_barras, input.tenant_id);

    if (isProdutoExists) throw new Error("Produto com o código de barras já cadastrado");

    produto.codigo = await SequencialRepository.get("produtos", "codigo", input.tenant_id);

    await this.produtoRepository.insert(produto, input.tenant_id);

    await this.precoRepository.insertByProduto(produto, input.tenant_id);

    await this.estoqueRepository.insertByProduto(produto, input.tenant_id);

    return { status: 201, data: produto.codigo };
  }

  async getAll(input: Input): Promise<Output> {
    const res = await this.produtoRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }

  async getByCodigo(codigo_produto: string, tenant_id: number) {
    if (codigo_produto === "novo") {
      const codigo = await SequencialRepository.get("produtos", "codigo", tenant_id);
      const produto = new Produto(codigo);
      const lojas = await this.lojaRepository.getAll(tenant_id);
      const precos = await this.precoRepository.getByProduto(produto.codigo, lojas, tenant_id);
      const estoques = await this.estoqueRepository.getByProduto(produto, lojas, tenant_id);

      produto.precos = precos;
      produto.estoques = estoques;
      return { status: 200, data: produto };
    }

    const produto = await this.produtoRepository.getByCodigo(codigo_produto, tenant_id);
    if (!produto) throw new Error("Produto não encontrado !");
    const lojas = await this.lojaRepository.getAll(tenant_id);
    produto.precos = await this.precoRepository.getByProduto(produto.codigo, lojas, tenant_id);
    produto.estoques = await this.estoqueRepository.getByProduto(produto, lojas, tenant_id);
    return { status: 200, data: produto };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  filter?: any;
};

type Output = {
  status: number;
  data?: any;
};
