import ProdutoFactory from "../entity/Factory.ts/ProdutoFactory";
import Preco from "../entity/Preco";
import PrecoRepository, { PrecoRepositoryPG } from "../repository/PrecoRepository";
import ProdutoRepository, { ProdutoRepositoryPG } from "../repository/ProdutoRepository";
import ProdutoRKRepository from "../repository/RK/ProdutoRKRepository";

class MigrateFromRKUseCase {
  produtoRepository: ProdutoRepository;
  precoRepository: PrecoRepository;
  constructor() {
    this.produtoRepository = new ProdutoRepositoryPG();
    this.precoRepository = new PrecoRepositoryPG();
  }

  async execute(tenant_id: number) {
    const produtosRK = await ProdutoRKRepository.getAll();
    const produtos = ProdutoFactory.fromRKList(produtosRK, "1");

    for (const produto of produtos) {
      //   console.log(produto.precos);
      console.log(produto.descricao);

      await this.produtoRepository.insert(produto, tenant_id);
      produto.precos.map(async (preco: Preco) => {
        await this.precoRepository.insert(preco, tenant_id);
      });
    }
  }
}

export default new MigrateFromRKUseCase();
