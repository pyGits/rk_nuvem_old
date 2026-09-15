import { Op } from "sequelize";

// Mocks dos models: este teste e sobre QUAL where o finalizaCarga monta, nao
// sobre o banco.
jest.mock("../models/Produto", () => ({ update: (valores: any, opcoes: any) => mockUpdate("produtos", valores, opcoes) }));
jest.mock("../models/Preco", () => ({ update: (valores: any, opcoes: any) => mockUpdate("precos", valores, opcoes) }));
jest.mock("../models/Finalizadora", () => ({ update: (valores: any, opcoes: any) => mockUpdate("finalizadoras", valores, opcoes) }));
jest.mock("../models/Funcionario", () => ({ update: (valores: any, opcoes: any) => mockUpdate("funcionarios", valores, opcoes) }));
jest.mock("../models/Tributacao", () => ({ update: (valores: any, opcoes: any) => mockUpdate("tributacoes", valores, opcoes) }));
jest.mock("../models/Loja", () => ({ findAll: jest.fn().mockResolvedValue([]) }));
jest.mock("../models/Tenant", () => ({ findAll: jest.fn().mockResolvedValue([]) }));

const chamadas: any[] = [];
function mockUpdate(tabela: string, valores: any, opcoes: any) {
  chamadas.push({ tabela, valores, opcoes });
  return Promise.resolve([0]);
}

import CargaController from "./CargaController";
import { cargaList, solicitaCarga, achaCarga } from "../infra/service/FilaCarga";

function resposta() {
  const res: any = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
}

function whereDe(tabela: string) {
  return chamadas.find((c) => c.tabela === tabela)?.opcoes?.where;
}

describe("finalizaCarga - o que deixa de estar pendente", () => {
  beforeEach(() => {
    chamadas.length = 0;
    cargaList.splice(0, cargaList.length);
  });

  // O CENARIO QUE ISTO PROTEGE: o sync pega a carga, e enquanto ela roda
  // alguem grava um produto. Esse produto nao entrou na carga (a lista foi
  // montada antes), entao ele NAO pode perder o carga_pendente aqui - senao
  // fica dado como enviado sem nunca ter saido, em silencio.
  it("so limpa o que ja estava gravado quando a carga automatica comecou", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS", true);
    const carga = achaCarga(1, "001")!;
    const comecou = Date.now() - 60000;
    carga.status = "EM_ANDAMENTO";
    carga.comecouEm = comecou;

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    const where: any = whereDe("produtos");
    expect(where.tenant_id).toBe(1);
    // O corte: updated_at ate o inicio da carga, ou nulo (dado migrado, que
    // senao ficaria pendente para sempre).
    expect(where[Op.or]).toEqual([
      { updated_at: { [Op.lte]: new Date(comecou) } },
      { updated_at: null },
    ]);
  });

  it("aplica o mesmo corte em todas as tabelas da carga", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS", true);
    achaCarga(1, "001")!.comecouEm = Date.now();

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    ["produtos", "precos", "finalizadoras", "funcionarios", "tributacoes"].forEach((tabela) => {
      expect(whereDe(tabela)[Op.or]).toBeDefined();
    });
  });

  // Preco e por loja desde sempre: limpar o de todas faria a loja que ainda
  // nao recebeu achar que ja recebeu.
  it("limpa preco so da loja que terminou", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS", true);
    achaCarga(1, "001")!.comecouEm = Date.now();

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    expect(whereDe("precos").loja).toBe("001");
    expect(whereDe("produtos").loja).toBeUndefined();
  });

  // ESTE E O TESTE QUE PROTEGE O PARQUE. A rota e chamada pelo agente de todos
  // os clientes, e quase nenhum deles tem carga automatica ligada. Para a
  // carga pedida no botao, a limpeza tem que continuar sendo exatamente a de
  // antes desta feature: tenant inteiro, sem nenhuma condicao nova.
  it("carga MANUAL limpa tudo, como sempre fez", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    const carga = achaCarga(1, "001")!;
    carga.status = "EM_ANDAMENTO";
    carga.comecouEm = Date.now();

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    const where: any = whereDe("produtos");
    expect(where.tenant_id).toBe(1);
    expect(where[Op.or]).toBeUndefined();
  });

  // Carga completa leva o cadastro inteiro: nada fica de fora por ter sido
  // gravado no meio, e ela volta a terminar como as manuais.
  it("automatica promovida para COMPLETA volta a limpar tudo", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS", true);
    solicitaCarga(1, [{ codigo: "001" }], "COMPLETA");
    achaCarga(1, "001")!.comecouEm = Date.now();

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    expect(whereDe("produtos")[Op.or]).toBeUndefined();
  });

  // Entrada ja expirada da fila, ou sync que nao passou pelo verificaCarga:
  // sem saber quando a carga comecou, o comportamento antigo e o certo.
  it("sem carga na fila, limpa tudo como antes", async () => {
    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    const where: any = whereDe("produtos");
    expect(where.tenant_id).toBe(1);
    expect(where[Op.or]).toBeUndefined();
  });

  it("tira a loja da fila ao terminar", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS", true);
    achaCarga(1, "001")!.comecouEm = Date.now();

    await CargaController.finalizaCarga({ tenant_id: 1, query: { loja: "001" } }, resposta());

    expect(achaCarga(1, "001")).toBeUndefined();
  });
});

describe("verificaCarga - entrega para o sync", () => {
  beforeEach(() => {
    chamadas.length = 0;
    cargaList.splice(0, cargaList.length);
  });

  // comecouEm e o que o finalizaCarga usa de corte; se ficasse nulo aqui, o
  // corte nao existiria e a protecao acima nunca valeria na pratica.
  it("marca o inicio da carga ao entregar", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    const res = resposta();

    await CargaController.verificaCarga({ tenant_id: 1, params: { loja: "001" } }, res);

    const carga = achaCarga(1, "001")!;
    expect(carga.status).toBe("EM_ANDAMENTO");
    expect(carga.comecouEm).toBeGreaterThan(0);
    expect(res.json).toHaveBeenCalledWith({ message: "CARGA_ALTERADOS" });
  });

  // O heartbeat empurra iniciadaEm para nao expirar a carga; se empurrasse
  // tambem o comecouEm, o corte andaria junto com a carga e o que foi gravado
  // no meio voltaria a ser dado como enviado.
  it("progresso nao move o marco de inicio", async () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    await CargaController.verificaCarga({ tenant_id: 1, params: { loja: "001" } }, resposta());

    const comecou = achaCarga(1, "001")!.comecouEm;

    await CargaController.atualizaProgressoCarga(
      { tenant_id: 1, query: { loja: "001", etapa: "PRODUTOS", indice: "2", total: "7" } },
      resposta()
    );

    expect(achaCarga(1, "001")!.comecouEm).toBe(comecou);
    expect(achaCarga(1, "001")!.etapa).toBe("PRODUTOS");
  });
});
