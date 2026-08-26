import RecebimentoTitulo from "../RecebimentoTitulo";

export default class RecebimentoTituloFactory {
  static create(data: any) {
    return new RecebimentoTitulo(
      Number(data.valor || 0),
      data.formaPagamento,
      Number(data.juros || 0),
      Number(data.multa || 0),
      Number(data.desconto || 0),
      data.dataPagamento,
      "",
      data.usuario
    );
  }
}
