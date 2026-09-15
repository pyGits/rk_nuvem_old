import { chaveCodigoCliente, variantesDeCodigoCliente, sqlCodigoClienteNormalizado } from "./codigoCliente";

// O defeito que isto existe para pegar: cliente cadastrado na web fica com
// codigo "1" e o titulo que veio do PDV guarda "000001". Sao o mesmo cliente,
// e antes disto o nome vinha vazio na grade e filtrar por cliente nao trazia
// nada.

describe("chave de comparacao do codigo de cliente", () => {
  it("iguala o mesmo codigo escrito com e sem zeros", () => {
    expect(chaveCodigoCliente("000001")).toBe(chaveCodigoCliente("1"));
    expect(chaveCodigoCliente("0013")).toBe(chaveCodigoCliente("13"));
  });

  it("ignora espaco nas pontas", () => {
    expect(chaveCodigoCliente("  7 ")).toBe(chaveCodigoCliente("7"));
  });

  // Zero a esquerda tirado sem cuidado transforma "0" em vazio, e ai qualquer
  // codigo invalido casaria com qualquer outro.
  it("nao transforma zero em vazio", () => {
    expect(chaveCodigoCliente("0")).toBe("0");
    expect(chaveCodigoCliente("000")).toBe("0");
    expect(chaveCodigoCliente("0")).not.toBe(chaveCodigoCliente(""));
  });

  it("nao confunde clientes diferentes", () => {
    expect(chaveCodigoCliente("1")).not.toBe(chaveCodigoCliente("10"));
    expect(chaveCodigoCliente("01")).not.toBe(chaveCodigoCliente("10"));
  });

  // Base migrada tem codigo que nao e numero; ali nao ha padding para desfazer.
  it("trata codigo nao numerico como texto", () => {
    expect(chaveCodigoCliente("ab12")).toBe("AB12");
    expect(chaveCodigoCliente(" ab12 ")).toBe("AB12");
    expect(chaveCodigoCliente("0A")).toBe("0A");
  });

  it("aceita vazio e nulo sem quebrar", () => {
    expect(chaveCodigoCliente(null)).toBe("");
    expect(chaveCodigoCliente(undefined)).toBe("");
  });
});

describe("variantes usadas no filtro", () => {
  it("cobre o codigo com e sem zeros ate a largura da coluna", () => {
    const variantes = variantesDeCodigoCliente("1");

    expect(variantes).toContain("1");
    expect(variantes).toContain("000001");
    // varchar(15) nas duas tabelas
    expect(variantes).toContain("000000000000001");
    expect(variantes.every((v) => v.length <= 15)).toBe(true);
  });

  it("funciona tambem quando o filtro ja vem preenchido com zeros", () => {
    const variantes = variantesDeCodigoCliente("000001");

    expect(variantes).toContain("1");
    expect(variantes).toContain("000001");
  });

  it("nao gera variante de codigo nao numerico", () => {
    expect(variantesDeCodigoCliente("ab12")).toEqual(["ab12"]);
  });

  // Lista vazia com `= ANY` nao casa nada; quem chama so usa quando ha filtro.
  it("devolve vazio para codigo em branco", () => {
    expect(variantesDeCodigoCliente("")).toEqual([]);
    expect(variantesDeCodigoCliente(null)).toEqual([]);
  });

  it("nao repete valores", () => {
    const variantes = variantesDeCodigoCliente("7");
    expect(new Set(variantes).size).toBe(variantes.length);
  });
});

describe("normalizacao em SQL", () => {
  // O SQL precisa dar a MESMA resposta que a chave em memoria, senao o nome
  // casa num lugar e nao casa no outro.
  it("monta a expressao sobre a coluna pedida", () => {
    const sql = sqlCodigoClienteNormalizado("cl.codigo");

    expect(sql).toContain("cl.codigo");
    expect(sql).toContain("^0+");
    // o coalesce e o que impede "0" de virar vazio, como na chave acima
    expect(sql).toContain("coalesce");
  });
});
