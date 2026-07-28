import SyspdvConnection from "./SyspdvConnection";

class ProdutoSyspdvRepository {
  async getAll() {
    const produtos = await SyspdvConnection.executeQuery("select * from produto order by procod asc");
    return produtos;
  }

  async getAllAux() {
    const auxiliares = await SyspdvConnection.executeQuery("select procodint, procodaux from produtoaux order by procodint asc");
    return auxiliares;
  }
}

export default new ProdutoSyspdvRepository();
