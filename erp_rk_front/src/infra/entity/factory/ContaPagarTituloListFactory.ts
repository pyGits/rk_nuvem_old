import ContaPagarTitulo from "../ContaPagarTitulo";
import ContaPagarTituloList from "../ContaPagarTituloList";
import { v4 as uuidv4 } from "uuid";

export default class ContaPagarTituloListFactory {
  static createList(list: any): ContaPagarTituloList {
    const titulos = new ContaPagarTituloList();
    list.items?.map((titulo: any) => {
      if (titulo.id.trim() === "") titulo.id = uuidv4();
      titulos.adicionarTitulo(
        new ContaPagarTitulo(titulo.seq, new Date(titulo.vencimento), Number(titulo.valor), Number(titulo.valorPago), titulo.descricao, titulo.numeroDocumento, titulo.fornecedorId, titulo.lojaId, titulo.categoriaFinanceiraId, titulo.subCategoriaFinanceiraId, titulo.id, titulo.status)
      );
    });

    return titulos;
  }
}
