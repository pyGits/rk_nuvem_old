import { v4 as uuidv4 } from "uuid";
import ContaReceberTitulo from "../ContaReceberTitulo";
import ContaReceberTituloList from "../ContaReceberTituloList";
import RecebimentoTitulo from "../RecebimentoTitulo";

export default class ContaReceberTituloListFactory {
  static createList(list: any): ContaReceberTituloList {
    const titulos = new ContaReceberTituloList();

    list?.items?.map((titulo: any) => {
      const recebimentos = (titulo.recebimentos || []).map(
        (recebimento: any) =>
          new RecebimentoTitulo(
            Number(recebimento.valor || 0),
            recebimento.formaPagamento,
            Number(recebimento.juros || 0),
            Number(recebimento.multa || 0),
            Number(recebimento.desconto || 0),
            recebimento.dataPagamento,
            recebimento.id,
            recebimento.usuario,
            Number(recebimento.estornado || 0)
          )
      );

      titulos.adicionarTitulo(
        new ContaReceberTitulo(
          titulo.id?.trim() === "" || !titulo.id ? uuidv4() : titulo.id,
          titulo.codigo,
          Number(titulo.lojaId || 0),
          titulo.clienteCodigo,
          titulo.clienteCpf,
          titulo.codigoCupom,
          titulo.numero,
          Number(titulo.prestacao || 1),
          titulo.caixa,
          titulo.vendedor,
          titulo.dataEmissao,
          titulo.dataVencimento,
          Number(titulo.valor || 0),
          titulo.descricao,
          titulo.origem,
          Number(titulo.cancelado || 0),
          titulo.status,
          recebimentos
        )
      );
    });

    return titulos;
  }
}
