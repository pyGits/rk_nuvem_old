import { cargaList, achaCarga, removeCarga, solicitaCarga } from "./FilaCarga";

// A fila decide o que o sync recebe. O que ela erra aqui aparece em campo como
// "pedi carga e nao foi" ou "mandou carga sozinha quando nao devia".

function limpaFila() {
  cargaList.splice(0, cargaList.length);
}

describe("fila de carga", () => {
  beforeEach(limpaFila);
  afterAll(limpaFila);

  it("enfileira uma loja como PENDENTE", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");

    const carga = achaCarga(1, "001");
    expect(carga?.status).toBe("PENDENTE");
    expect(carga?.carga).toBe("ALTERADOS");
    // Ainda nao comecou: e o verificaCarga quem marca, e o finalizaCarga usa
    // esse valor como corte.
    expect(carga?.comecouEm).toBeNull();
  });

  // E o que faz um lote de gravacoes nao virar um lote de cargas: a segunda
  // gravacao encontra a loja ja na fila e entra na mesma carga.
  it("nao duplica pedido para a mesma loja", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");

    expect(cargaList.filter((c) => c.tenant_id === 1 && c.codigo === "001")).toHaveLength(1);
  });

  it("promove para COMPLETA enquanto o sync nao pegou", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    solicitaCarga(1, [{ codigo: "001" }], "COMPLETA");

    expect(achaCarga(1, "001")?.carga).toBe("COMPLETA");
  });

  // Carga pedida no botao nasce manual: e o que faz o finalizaCarga continuar
  // limpando do jeito antigo para quem nao ligou a carga automatica.
  it("nasce manual, e so a automatica se marca como tal", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    expect(achaCarga(1, "001")?.automatica).toBe(false);

    solicitaCarga(2, [{ codigo: "001" }], "ALTERADOS", true);
    expect(achaCarga(2, "001")?.automatica).toBe(true);
  });

  // Trocar o tipo no meio faria o sync terminar uma carga diferente da que
  // comecou.
  it("nao troca o tipo de uma carga ja em andamento", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    const carga = achaCarga(1, "001")!;
    carga.status = "EM_ANDAMENTO";
    carga.iniciadaEm = Date.now();

    solicitaCarga(1, [{ codigo: "001" }], "COMPLETA");

    expect(achaCarga(1, "001")?.carga).toBe("ALTERADOS");
  });

  // O codigo de loja se repete entre clientes; sem o tenant na chave, a carga
  // de um cliente calaria a do outro.
  it("separa lojas de clientes diferentes com o mesmo codigo", () => {
    solicitaCarga(1, [{ codigo: "001" }], "ALTERADOS");
    solicitaCarga(2, [{ codigo: "001" }], "ALTERADOS");

    expect(achaCarga(1, "001")).toBeDefined();
    expect(achaCarga(2, "001")).toBeDefined();

    removeCarga(1, "001");

    expect(achaCarga(1, "001")).toBeUndefined();
    expect(achaCarga(2, "001")).toBeDefined();
  });
});
