import ContaPagarTitulo from "../ContaPagarTitulo";
import ContaPagarTituloList from "../ContaPagarTituloList";
import { v4 as uuidv4 } from "uuid";
import PagamentoTitulo from "../PagamentoTitulo";
import FormaPagamento from "../FormaPagamento";

export default class ContaPagarTituloListFactory {
  static createList(list: any): ContaPagarTituloList {
    const titulos = new ContaPagarTituloList();
    list.items?.map((titulo: any) => {
      if (titulo.id.trim() === "") titulo.id = uuidv4();

      const pagamentos = titulo.pagamentos.map((pag) => {
        return new PagamentoTitulo(pag.valor, new FormaPagamento(pag.formaPagamento.codigo, pag.formaPagamento.nome));
      });

      titulos.adicionarTitulo(
        new ContaPagarTitulo(titulo.seq, new Date(titulo.vencimento), Number(titulo.valor), Number(titulo.valorPago), titulo.descricao, titulo.numeroDocumento, titulo.fornecedorId, titulo.lojaId, titulo.categoriaFinanceiraId, titulo.subCategoriaFinanceiraId, titulo.id, titulo.status, pagamentos)
      );
    });

    return titulos;
  }
}
