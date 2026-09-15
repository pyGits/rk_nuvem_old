import { shallowMount } from "@vue/test-utils";
import ExtratoCliente from "@/views/Financeiro/ContasAReceber/ExtratoCliente.vue";
import RecibosRecebimento from "@/views/Financeiro/ContasAReceber/RecibosRecebimento.vue";
import ContaReceberService from "@/infra/service/ContaReceberService";

// As duas abas tinham busca de cliente propria, alem da do topo da tela: dois
// campos para a mesma coisa, e resultado diferente conforme qual a pessoa
// usasse. Agora o cliente chega por prop e a aba nao escolhe mais.

// jsPDF/xlsx nao carregam no jsdom (TextEncoder); o teste nao exporta nada.
jest.mock("@/utils/exports", () => ({ gerarExcel: jest.fn() }));
jest.mock("@/infra/service/PDFService", () => ({ __esModule: true, default: { exibirPDF: jest.fn() } }));

jest.mock("@/infra/service/ContaReceberService", () => ({
  __esModule: true,
  default: {
    getExtrato: jest.fn().mockResolvedValue({ titulos: { items: [] }, totais: {} }),
    getSaldoClientes: jest.fn().mockResolvedValue({ clientes: [], totais: {} }),
    getRecibos: jest.fn().mockResolvedValue([]),
  },
}));

const servico: any = ContaReceberService;

function montar(componente: any, props: any = {}) {
  return shallowMount(componente, {
    propsData: props,
    mocks: {
      $store: { state: { cliente: { clienteList: [] }, relatorio: {} }, commit: jest.fn(), dispatch: jest.fn() },
    },
    stubs: { CabecalhoRelatorio: true, EstadoVazio: true, FiltroPeriodo: true, ConfirmDialog: true },
  });
}

beforeEach(() => jest.clearAllMocks());

describe("aba Extrato do cliente", () => {
  it("nao tem mais busca de cliente propria", () => {
    const tela: any = montar(ExtratoCliente);

    expect(tela.vm.$options.components.LocalizarCliente).toBeUndefined();
    expect(tela.vm.dialogCliente).toBeUndefined();
  });

  it("usa o cliente que vem do filtro do topo", async () => {
    const tela: any = montar(ExtratoCliente, { clienteCodigo: "000007", clienteNomeSelecionado: "JOAO" });
    await tela.vm.$nextTick();

    expect(tela.vm.filtro.selectedCliente).toBe("000007");
    expect(tela.vm.clienteNome).toBe("JOAO");
    expect(servico.getExtrato).toHaveBeenCalledWith(expect.objectContaining({ selectedCliente: "000007" }));
  });

  // Sem isto a aba consultaria duas vezes ao abrir: uma pelo watch com
  // immediate e outra pelo mounted.
  it("nao consulta duas vezes ao abrir", async () => {
    montar(ExtratoCliente, { clienteCodigo: "3" });
    await new Promise((r) => setTimeout(r, 0));

    expect(servico.getExtrato).toHaveBeenCalledTimes(1);
  });

  it("recarrega quando o cliente do topo muda", async () => {
    const tela: any = montar(ExtratoCliente, { clienteCodigo: "3" });
    await tela.vm.$nextTick();

    await tela.setProps({ clienteCodigo: "9" });
    await tela.vm.$nextTick();

    expect(servico.getExtrato).toHaveBeenLastCalledWith(expect.objectContaining({ selectedCliente: "9" }));
  });

  // Clicar num cliente da posicao consolidada tem que mexer no filtro do topo,
  // senao o campo la em cima diria "todos os clientes" com um extrato
  // individual na tela.
  it("avisa o pai ao escolher um cliente da lista consolidada", async () => {
    const tela: any = montar(ExtratoCliente);

    tela.vm.abrirCliente({ clienteCodigo: "000012", clienteNome: "MARIA" });

    expect(tela.emitted("selecionar-cliente")[0]).toEqual([{ codigo: "000012", nome: "MARIA" }]);
  });

  it("avisa o pai ao voltar para todos os clientes", async () => {
    const tela: any = montar(ExtratoCliente, { clienteCodigo: "5" });

    tela.vm.voltarParaTodos();

    expect(tela.emitted("selecionar-cliente")[0]).toEqual([{ codigo: "", nome: "" }]);
  });

  it("tem a coluna Cliente na grade de titulos", () => {
    const tela: any = montar(ExtratoCliente);

    expect(tela.vm.headers.some((coluna: any) => coluna.value === "cliente")).toBe(true);
  });

  it("mostra codigo e nome, e so o codigo quando o cliente nao subiu para a nuvem", () => {
    const tela: any = montar(ExtratoCliente);

    expect(tela.vm.nomeCliente({ clienteCodigo: "12", clienteNome: "MARIA" })).toBe("12 - MARIA");
    expect(tela.vm.nomeCliente({ clienteCodigo: "12", clienteNome: "" })).toBe("12");
    expect(tela.vm.nomeCliente({ clienteCodigo: "", clienteNome: "" })).toBe("");
  });

  // O codigo do cliente gravado no titulo vem preenchido; na tela ele aparece
  // do jeito que o cadastro da web o escreve.
  it("mostra o codigo do cliente sem os zeros de enchimento", () => {
    const tela: any = montar(ExtratoCliente);

    expect(tela.vm.nomeCliente({ clienteCodigo: "000012", clienteNome: "MARIA" })).toBe("12 - MARIA");
  });

  // O filtro continua indo para a API com o codigo original: e ele que casa
  // com o titulo gravado.
  it("exibe sem zeros mas filtra com o codigo original", async () => {
    const tela: any = montar(ExtratoCliente, { clienteCodigo: "000007", clienteNomeSelecionado: "JOAO" });
    await tela.vm.$nextTick();

    expect(tela.vm.clienteDescricao).toBe("7 - JOAO");
    expect(servico.getExtrato).toHaveBeenCalledWith(expect.objectContaining({ selectedCliente: "000007" }));
  });
});

describe("aba Recebimentos", () => {
  it("nao tem mais busca de cliente propria", () => {
    const tela: any = montar(RecibosRecebimento);

    expect(tela.vm.$options.components.LocalizarCliente).toBeUndefined();
    expect(tela.vm.dialogCliente).toBeUndefined();
  });

  it("usa o cliente que vem do filtro do topo", async () => {
    const tela: any = montar(RecibosRecebimento, { clienteCodigo: "000007", clienteNomeSelecionado: "JOAO" });
    await tela.vm.$nextTick();

    expect(tela.vm.filtro.selectedCliente).toBe("000007");
    expect(servico.getRecibos).toHaveBeenCalledWith(expect.objectContaining({ selectedCliente: "000007" }));
  });

  it("nao consulta duas vezes ao abrir", async () => {
    montar(RecibosRecebimento, { clienteCodigo: "3" });
    await new Promise((r) => setTimeout(r, 0));

    expect(servico.getRecibos).toHaveBeenCalledTimes(1);
  });

  it("recarrega quando o cliente do topo muda", async () => {
    const tela: any = montar(RecibosRecebimento, { clienteCodigo: "3" });
    await tela.vm.$nextTick();

    await tela.setProps({ clienteCodigo: "9" });
    await tela.vm.$nextTick();

    expect(servico.getRecibos).toHaveBeenLastCalledWith(expect.objectContaining({ selectedCliente: "9" }));
  });
});
