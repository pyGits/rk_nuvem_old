import ContaReceber from "../ContaReceber";

export default class ContaReceberFactory {
  static create(data: any) {
    const conta = new ContaReceber(
      Number(data.lojaId || 0),
      data.clienteCodigo,
      data.clienteCpf,
      data.descricao,
      Number(data.valorNominal || 0),
      Number(data.parcelas || 1),
      Number(data.intervalo || 1),
      data.tipoIntervalo,
      data.dataEmissao,
      data.dataVencimento,
      data.codigo
    );
    conta.gerarTitulos();
    return conta;
  }
}
