import Preco from "../Preco";

export default class PrecoFactory {
  static fromSyspdvList(data: any, lojaId: string) {
    let list = [];
    for (const indice in data) {
      const produto = data[indice];
      const codigo = produto.PROCODINT;
      const preco = produto.PROPRCVDAVAR;
      const custo = produto.PROPRCCST;
      const markup = produto.PROPRCMRG1;

      const preco_adapter = new Preco(lojaId, preco, custo, 0, markup, undefined, codigo);
      list.push(preco_adapter);
    }
    return list;
  }
}
