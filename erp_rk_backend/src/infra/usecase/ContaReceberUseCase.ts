import moment from "moment";
import { v4 as uuidv4 } from "uuid";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberFactory from "../entity/Factory.ts/ContaReceberFactory";
import RecebimentoTituloFactory from "../entity/Factory.ts/RecebimentoTituloFactory";
import ContaReceberRecebimentoRepository from "../repository/ContaReceberRecebimentoRepository";
import ContaReceberRepository from "../repository/ContaReceberRepository";
import ContaReceberReciboRepository from "../repository/ContaReceberReciboRepository";
import DatabaseConnection from "../repository/DatabaseConnection";
import LojaRepository from "../repository/LojaRepository";
import gerarReciboPDF from "../service/ContaReceberReciboPDF";

// O sync manda data no formato do Delphi (DD/MM/YYYY, como em VendaController);
// o resto do modulo trabalha com 'YYYY-MM-DD'.
function dataDoSync(valor: string): string {
  if (!valor) return null;
  return moment(valor, "DD/MM/YYYY").format("YYYY-MM-DD");
}

export default class ContaReceberUseCase {
  constructor(
    readonly contaReceberRepository: ContaReceberRepository,
    readonly contaReceberRecebimentoRepository: ContaReceberRecebimentoRepository,
    readonly contaReceberReciboRepository: ContaReceberReciboRepository,
    readonly lojaRepository: LojaRepository
  ) {}

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

    // N parcelas em N inserts: sem transacao um erro no meio deixava o
    // lancamento pela metade, com parcelas faltando e sem nenhum aviso.
    await DatabaseConnection.transaction((tx) => this.contaReceberRepository.insert(contaReceber, input.tenant_id, tx));

    return { status: 201 };
  }

  // O saldo vem sempre do banco: o navegador manda apenas quais titulos e quanto
  // foi recebido.
  async receber(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    const recebimento = RecebimentoTituloFactory.create(input.body?.recebimento || {});

    titulos.registrarRecebimento(recebimento);

    // Grava em duas tabelas por titulo. Fora de transacao, uma falha entre as
    // duas deixava o recebimento gravado e o titulo ainda ABERTO - dinheiro
    // recebido que nao aparece como recebido em lugar nenhum.
    //
    // O recibo e alocado uma vez e repetido em todas as linhas: e ele que torna
    // a operacao inteira reimprimivel depois.
    const recibo = await DatabaseConnection.transaction(async (tx) => {
      const numero = await this.contaReceberRecebimentoRepository.proximoNumeroRecibo(input.tenant_id, tx);
      const identidade = { id: uuidv4(), numero };

      for (const titulo of titulos.items) {
        await this.contaReceberRecebimentoRepository.insertByTitulo(titulo, input.tenant_id, tx, identidade);
        await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id, tx);
      }

      return identidade;
    });

    return { status: 201, data: { reciboId: recibo.id, reciboNumero: recibo.numero } };
  }

  async estornar(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    titulos.estornarTitulos();

    await DatabaseConnection.transaction(async (tx) => {
      for (const titulo of titulos.items) {
        await this.contaReceberRecebimentoRepository.estornarByTitulo(titulo, input.tenant_id, tx);
        await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id, tx);
      }
    });

    return { status: 201 };
  }

  async cancelar(input: Input): Promise<Output> {
    const titulos = await this.contaReceberRepository.getByIds(input.body?.ids, input.tenant_id);
    titulos.cancelarTitulos();

    await DatabaseConnection.transaction(async (tx) => {
      for (const titulo of titulos.items) {
        await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id, tx);
      }
    });

    return { status: 201 };
  }

  async update(input: Input): Promise<Output> {
    const [titulo] = (await this.contaReceberRepository.getByIds([input.body?.id], input.tenant_id)).items;
    if (!titulo) throw new Error("Título não encontrado !");
    if (titulo.cancelado === 1) throw new Error("Título cancelado não pode ser alterado !");
    // Alterar o valor de um titulo ja baixado deixaria o recebimento gravado
    // sem relacao com o titulo que ele quitou - o estorno vem primeiro.
    if (titulo.status !== "ABERTO") throw new Error("Título liquidado não pode ser alterado - estorne o recebimento antes !");

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

  // Posicao de todos os clientes. Endpoint proprio, e nao um modo do extrato:
  // consolidar sem filtro de cliente carregaria o crediario inteiro so para
  // somar em JS, e a consulta agregada devolve uma linha por cliente.
  async getSaldoClientes(input: Input): Promise<Output> {
    const clientes = await this.contaReceberRepository.getSaldoClientes(input.filter || {}, input.tenant_id);

    return {
      status: 200,
      data: {
        clientes,
        totais: {
          clientes: clientes.length,
          saldo: clientes.reduce((total, cliente) => total + cliente.saldo, 0),
          saldoVencido: clientes.reduce((total, cliente) => total + cliente.saldoVencido, 0),
        },
      },
    };
  }

  async getRecibos(input: Input): Promise<Output> {
    const recibos = await this.contaReceberReciboRepository.getAll(input.filter || {}, input.tenant_id);
    return { status: 200, data: recibos };
  }

  // O PDF nasce do dado a cada pedido, entao a 2a via e sempre igual ao que
  // esta gravado - inclusive quando o recibo foi estornado depois de impresso.
  async gerarRecibo(input: Input): Promise<Output> {
    const reciboId = String(input.filter?.reciboId || "");
    if (!reciboId) throw new Error("Recibo não informado !");

    const recibo = await this.contaReceberReciboRepository.getById(reciboId, input.tenant_id);
    if (!recibo) throw new Error("Recibo não encontrado !");

    const loja = await this.lojaRepository.getByCodigo(String(recibo.lojaId), input.tenant_id);
    const arquivo = await gerarReciboPDF(recibo, loja, new Date());

    return { status: 200, data: { reciboId: recibo.reciboId, reciboNumero: recibo.reciboNumero, arquivo } };
  }

  // Estorna a operacao inteira. O estorno da grade continua sendo por titulo -
  // este e o que corresponde a "lancei a baixa errada".
  async estornarRecibo(input: Input): Promise<Output> {
    const reciboId = String(input.body?.reciboId || "");
    if (!reciboId) throw new Error("Recibo não informado !");

    const idsAfetados = await DatabaseConnection.transaction(async (tx) => {
      const ids = await this.contaReceberReciboRepository.estornar(reciboId, input.tenant_id, tx);
      if (ids.length === 0) return ids;

      // Recalcula a situacao de cada titulo tocado: so virar a flag do
      // recebimento deixaria o titulo LIQUIDADO sem nenhuma baixa valida.
      const titulos = await this.contaReceberRepository.getByIds(ids, input.tenant_id);
      for (const titulo of titulos.items) {
        titulo.recebimentos.forEach((recebimento) => (recebimento.estornado = 1));
        titulo.atualizarStatus();
        await this.contaReceberRepository.atualizarSituacao(titulo, input.tenant_id, tx);
      }

      return ids;
    });

    return { status: 200, data: { titulosAfetados: idsAfetados.length } };
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
      clienteNome: titulo.clienteNome,
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
        formaPagamentoNome: recebimento.formaPagamentoNome,
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
