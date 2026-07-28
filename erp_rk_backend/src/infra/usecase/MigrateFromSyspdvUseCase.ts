import PrecoFactory from "../entity/Factory.ts/PrecoFactory";
import ProdutoFactory from "../entity/Factory.ts/ProdutoFactory";
import PrecoRepository, { PrecoRepositoryPG } from "../repository/PrecoRepository";
import ProdutoCodigoBarrasRepository, { ProdutoCodigoBarrasRepositoryPG } from "../repository/ProdutoCodigoBarrasRepository";
import ProdutoRepository, { ProdutoRepositoryPG } from "../repository/ProdutoRepository";
import CodigoSyspdvRepository from "../repository/Syspdv/CodigoSyspdvRepository";
import ProdutoSyspdvRepository from "../repository/Syspdv/ProdutoSyspdvRepository";

class MigrateFromSyspdvUseCase {
  produtoRepository: ProdutoRepository;
  precoRepository: PrecoRepository;
  produtoCodigoBarrasRepository: ProdutoCodigoBarrasRepository;
  constructor() {
    this.produtoRepository = new ProdutoRepositoryPG();
    this.precoRepository = new PrecoRepositoryPG();
    this.produtoCodigoBarrasRepository = new ProdutoCodigoBarrasRepositoryPG();
  }

  async execute(tenant_id: number) {
    console.log("Migrando produtos do syspdv ....");
    const lojaId = "1";
    const produtos_syspdv = await ProdutoSyspdvRepository.getAll();

    // await CodigoSyspdvRepository.updateCodigosFromList(produtos_syspdv);
    const produtos_nuvem = ProdutoFactory.fromSyspdvList(produtos_syspdv);
    const precos_nuvem = PrecoFactory.fromSyspdvList(produtos_syspdv, lojaId);

    // for (const produto of produtos_nuvem) {
    //   console.log("Migrando produto : " + produto.codigo);
    //   console.log(produto);
    //   try {
    //     await this.produtoRepository.insert(produto, tenant_id);
    //   } catch (error) {}
    // }
  //   for (const preco of precos_nuvem) {
  //     try {
  //       console.log(preco);
  //       await this.precoRepository.insert(preco, tenant_id);
  //     } catch (error) {}
  //     console.log("Migrando preco: ", preco.codigo_produto);
  //   }
  // }
  }

  async migrateCodigosAuxiliares(tenant_id: number) {
    console.log("Migrando códigos de barras auxiliares do syspdv ....");
    // produtoaux: procodint -> codigo_produto (nuvem) | procodaux -> codigo_barras (nuvem)
    const auxiliares_syspdv = await ProdutoSyspdvRepository.getAllAux();

    for (const aux of auxiliares_syspdv) {
      const codigo_produto = String(aux.PROCODINT);
      const codigo_barras = String(aux.PROCODAUX);

      try {
        await this.produtoCodigoBarrasRepository.insert({ codigo_produto, codigo_barras }, tenant_id);
        console.log("Migrando código auxiliar: ", codigo_produto, codigo_barras);
      } catch (error) {
        console.error("Erro ao migrar código auxiliar: ", codigo_produto, codigo_barras, error);
      }
    }
  }
}

export default new MigrateFromSyspdvUseCase();
