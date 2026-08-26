import moment from "moment";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberFactory from "../entity/Factory.ts/ContaReceberFactory";
import RecebimentoTituloFactory from "../entity/Factory.ts/RecebimentoTituloFactory";
import ContaReceberRecebimentoRepository from "../repository/ContaReceberRecebimentoRepository";
import ContaReceberRepository from "../repository/ContaReceberRepository";

// O sync manda data no formato do Delphi (DD/MM/YYYY, como em VendaController);
// o resto do modulo trabalha com 'YYYY-MM-DD'.
function dataDoSync(valor: string): string {
  if (!valor) return null;
  return moment(valor, "DD/MM/YYYY").format("YYYY-MM-DD");
}

export default class ContaReceberUseCase {
  constructor(readonly contaReceberRepository: ContaReceberRepository, readonly contaReceberRecebimentoRepository: ContaReceberRecebimentoRepository) {}

  // Chamado pelo Sync_NUVEM, que le CUPOM_CREDIARIO em cada PDV. Titulo ja chega
  // parcelado: uma requisicao por parcela.
  async sincronizar(input: Input): Promise<Output> {
    const body = input.body;

    const titulo = new ContaReceberTitulo(
      "",
      String(body.codigo || ""),
      Number(body.loja || 0),
      String(body.codigo_cliente || ""),
      String(body.cpf_cliente || ""),
      String(body.codigo_cupom || ""),
      String(body.numero || ""),
      Number(body.prestacao || 1),
      String(body.caixa || ""),
      String(body.vendedor || ""),
      dataDoSync(body.data_emissao),
      dataDoSync(body.data_vencimento),
      Number(body.valor || 0),
      String(body.descricao || ""),
      "PDV",
      Number(body.cancelado || 0)
    );
    titulo.status = titulo.cancelado === 1 ? "CANCELADO" : "ABERTO";

    await this.contaReceberRepository.sincronizar(titulo, input.tenant_id);

    return { status: 201, data: { message: "SINCRONIZADO" } };
  }

  async getAllTitulos(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getAll(input.filter || {}, input.tenant_id);
    return { status: 200, data: this.serializar(titulos.items) };
  }

  async insert(input: Input): Promise<Output> {
    const contaReceber = ContaReceberFactory.create(input.body);
    contaReceber.validate();
    contaReceber.codigo = await this.contaReceberRepository.proximoCodigoManual(input.tenant_id);

    await this.contaReceberRepository.insert(contaReceber, input.tenant_id);

    return { status: 201 };
  }

  // O saldo vem sempre do banco: o navegador manda apenas quais titulos e quanto
  // foi recebido.
  async receber(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    const recebimento = RecebimentoTituloFactory.create(input.body?.recebimento || {});

    titulos.registrarRecebimento(recebimento);

    for (const titulo of titulos.items) {
      await this.contaReceberRecebimentoRepository.insertByTitulo(titulo, input.tenant_id);
      await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id);
    }

    return { status: 201 };
  }

  async estornar(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    titulos.estornarTitulos();

    for (const titulo of titulos.items) {
      await this.contaReceberRecebimentoRepository.estornarByTitulo(titulo, input.tenant_id);
      await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id);
    }

    return { status: 201 };
  }

  async cancelar(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    titulos.cancelarTitulos();

    for (const titulo of titulos.items) {
      await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id);
    }

    return { status: 201 };
  }

  async update(input: Input): Promise<Output> {
    const [titulo] = (await this.contaReceberRepository.getByIds([input.body?.id], input.tenant_id)).items;
    if (!titulo) throw new Error("Título não encontrado !");
    if (titulo.cancelado === 1) throw new Error("Título cancelado não pode ser alterado !");

    titulo.valor = Number(input.body.valor || 0);
    titulo.dataVencimento = input.body.dataVencimento;
    titulo.descricao = input.body.descricao;
    if (titulo.valor <= 0) throw new Error("Valor não pode ser 0 ou negativo !");
    if (titulo.valor < titulo.valorRecebido()) throw new Error("Valor menor que o total já recebido !");

    await this.contaReceberRepository.update(titulo, input.tenant_id);
    titulo.atualizarStatus();
    await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id);

    return { status: 200 };
  }

  // Extrato do cliente: os titulos do periodo, os recebimentos de cada um e o
  // saldo devedor total (que inclui titulos vencidos fora do periodo filtrado).
  async getExtrato(input: Input): Promise<Output> {
    const filtro = input.filter || {};
    if (!filtro.selectedCliente) throw new Error("Selecione o cliente !");

    const titulos = await this.contaReceberRepository.getAll(filtro, input.tenant_id);
    const todos = await this.contaReceberRepository.getAll({ selectedCliente: filtro.selectedCliente }, input.tenant_id);

    return {
      status: 200,
      data: {
        titulos: this.serializar(titulos.items),
        totais: {
          valor: titulos.valorTotal(),
          recebido: titulos.valorRecebido(),
          aReceber: titulos.valorReceber(),
          saldoDevedorCliente: todos.valorReceber(),
        },
      },
    };
  }

  // O front recalcula saldo/status pelas mesmas regras, mas manda os totais
  // prontos junto para a grid nao precisar somar antes de renderizar.
  private serializar(titulos: ContaReceberTitulo[]) {
    return titulos.map((titulo) => ({
      id: titulo.id,
      codigo: titulo.codigo,
      lojaId: titulo.lojaId,
      clienteCodigo: titulo.clienteCodigo,
      clienteCpf: titulo.clienteCpf,
      codigoCupom: titulo.codigoCupom,
      numero: titulo.numero,
      prestacao: titulo.prestacao,
      caixa: titulo.caixa,
      vendedor: titulo.vendedor,
      dataEmissao: titulo.dataEmissao,
      dataVencimento: titulo.dataVencimento,
      valor: titulo.valor,
      descricao: titulo.descricao,
      origem: titulo.origem,
      cancelado: titulo.cancelado,
      status: titulo.status,
      valorRecebido: titulo.valorRecebido(),
      valorDesconto: titulo.valorDesconto(),
      valorAcrescimo: titulo.valorAcrescimo(),
      valorAReceber: titulo.valorAReceber(),
      recebimentos: titulo.recebimentos.map((recebimento) => ({
        id: recebimento.id,
        valor: recebimento.valor,
        formaPagamento: recebimento.formaPagamento,
        juros: recebimento.juros,
        multa: recebimento.multa,
        desconto: recebimento.desconto,
        dataPagamento: recebimento.dataPagamento,
        usuario: recebimento.usuario,
        estornado: recebimento.estornado,
      })),
    }));
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  filter?: any;
};

type Output = {
  status: number;
  data?: any;
};
