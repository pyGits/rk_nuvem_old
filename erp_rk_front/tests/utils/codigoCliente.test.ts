import { chaveCodigoCliente, mesmoCliente } from "@/utils/codigoCliente";

// Mesma regra do backend (src/infra/repository/codigoCliente.ts). Se as duas
// divergirem, o nome do cliente aparece na grade vinda da API mas some no
// fallback do front (ou o contrario), que e o tipo de diferenca que ninguem
// liga a uma mudanca de codigo.

describe("codigo de cliente no front", () => {
  it("iguala o mesmo cliente escrito com e sem zeros", () => {
    expect(mesmoCliente("1", "000001")).toBe(true);
    expect(mesmoCliente("000013", "13")).toBe(true);
  });

  it("nao confunde clientes diferentes", () => {
    expect(mesmoCliente("1", "10")).toBe(false);
    expect(mesmoCliente("01", "10")).toBe(false);
  });

  it("ignora espaco nas pontas", () => {
    expect(mesmoCliente(" 7 ", "07")).toBe(true);
  });

  it("nao transforma zero em vazio", () => {
    expect(chaveCodigoCliente("0")).toBe("0");
    expect(chaveCodigoCliente("000")).toBe("0");
  });

  // Sem codigo nao ha cliente: nao pode casar com outro vazio e "achar" um
  // cliente que nao existe.
  it("codigo vazio nunca casa", () => {
    expect(mesmoCliente("", "")).toBe(false);
    expect(mesmoCliente(null, undefined)).toBe(false);
    expect(mesmoCliente("", "1")).toBe(false);
  });

  it("trata codigo nao numerico como texto", () => {
    expect(mesmoCliente("ab12", "AB12")).toBe(true);
    expect(mesmoCliente("ab12", "ab13")).toBe(false);
  });
});

// ---------------------------------------------------------------------------

import { semZerosEsquerda } from "@/utils/masks";

// O codigo do titulo chega da retaguarda como cupom + parcela, preenchido ate
// o tamanho da coluna: 38 caracteres na grade para mostrar 9 digitos.
describe("codigo sem zeros de enchimento na grade", () => {
  it("tira o enchimento do codigo do titulo", () => {
    expect(semZerosEsquerda("00000000000000000000000000000106780001")).toBe("106780001");
    expect(semZerosEsquerda("000001")).toBe("1");
  });

  it("nao mexe em codigo que ja vem sem zeros", () => {
    expect(semZerosEsquerda("106780001")).toBe("106780001");
  });

  // Zero e um codigo; vazio nao e.
  it("codigo todo de zeros continua sendo zero", () => {
    expect(semZerosEsquerda("0")).toBe("0");
    expect(semZerosEsquerda("0000")).toBe("0");
  });

  it("deixa codigo nao numerico intacto", () => {
    expect(semZerosEsquerda("0A15")).toBe("0A15");
    expect(semZerosEsquerda("NF-001")).toBe("NF-001");
  });

  it("aceita vazio e nulo sem quebrar", () => {
    expect(semZerosEsquerda("")).toBe("");
    expect(semZerosEsquerda(null)).toBe("");
    expect(semZerosEsquerda(undefined)).toBe("");
  });
});
