import SyspdvConnection from "./SyspdvConnection";
class CodigoSyspdvRepository {
  async updateCodigosFromList(data: any) {
    for (const indice in data) {
      const produto = data[indice];
      await SyspdvConnection.executeStatement("update produto set procodint = ? where procod = ?", [Number(indice) + 1 + 30000, produto.PROCOD]);
    }
  }
}

export default new CodigoSyspdvRepository();
