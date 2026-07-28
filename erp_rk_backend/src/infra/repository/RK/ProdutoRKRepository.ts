import RKConnection from "./RKConnection";
class ProdutoRKRepository {
  async getAll() {
    const produtos = await RKConnection.executeQuery("select * from produto order by codigo asc");
    return produtos;
  }
}

export default new ProdutoRKRepository();
