import { montarLinhasSinteticas, ordenarMantendoFilhas } from "@/utils/cupomSintetico";

const chaveCupom = (cupom: any) => `${cupom.data}_${cupom.caixa}_${cupom.codigo}_${cupom.loja}`;
const formatar = (valor: any) => Number(valor || 0).toFixed(2);

function cupom(codigo: string, finalizadoras: any[], extras: any = {}) {
  return { data: "2026-09-14", caixa: 1, codigo, loja: 1, valor_total_original: 100, ...extras, finalizadoras };
}

describe("montarLinhasSinteticas", () => {
  it("cupom com uma forma: tudo na propria linha, sem linha extra", () => {
    const linhas = montarLinhasSinteticas(
      [cupom("1", [{ descricao: "Dinheiro", valor: 50, valor_troco: 0 }])],
      chaveCupom,
      formatar
    );

    expect(linhas).toHaveLength(1);
    expect(linhas[0].ehLinhaFinalizadora).toBeUndefined();
    expect(linhas[0].finalizadora_descricao).toBe("Dinheiro");
    expect(linhas[0].finalizadora_valor).toBe("50.00");
  });

  it("troco zerado nao aparece; troco de verdade aparece", () => {
    const [semTroco] = montarLinhasSinteticas([cupom("1", [{ descricao: "PIX", valor: 30, valor_troco: 0 }])], chaveCupom, formatar);
    const [comTroco] = montarLinhasSinteticas([cupom("2", [{ descricao: "Dinheiro", valor: 50, valor_troco: 7 }])], chaveCupom, formatar);

    expect(semTroco.finalizadora_troco).toBe("");
    expect(comTroco.finalizadora_troco).toBe("7.00");
  });

  it("cupom com duas formas: linha do cupom mais uma linha por forma", () => {
    const linhas = montarLinhasSinteticas(
      [
        cupom("1", [
          { descricao: "Dinheiro", valor: 50, valor_troco: 5 },
          { descricao: "Cartão", valor: 30, valor_troco: 0 },
        ]),
      ],
      chaveCupom,
      formatar
    );

    expect(linhas).toHaveLength(3);

    // A linha do cupom nao repete valor de forma: ele esta nas linhas de baixo.
    expect(linhas[0].finalizadora_descricao).toBe("2 formas");
    expect(linhas[0].finalizadora_valor).toBe("");

    expect(linhas[1].ehLinhaFinalizadora).toBe(true);
    expect(linhas[1].finalizadora_descricao).toBe("Dinheiro");
    expect(linhas[1].finalizadora_valor).toBe("50.00");
    expect(linhas[1].finalizadora_troco).toBe("5.00");
    expect(linhas[1].indiceForma).toBe(0);

    expect(linhas[2].finalizadora_descricao).toBe("Cartão");
    expect(linhas[2].indiceForma).toBe(1);
  });

  it("cupom sem forma de pagamento nao quebra", () => {
    const linhas = montarLinhasSinteticas([cupom("1", [])], chaveCupom, formatar);

    expect(linhas).toHaveLength(1);
    expect(linhas[0].finalizadora_descricao).toBe("");
  });

  it("usa o codigo da finalizadora quando ela nao tem nome cadastrado", () => {
    const [linha] = montarLinhasSinteticas([cupom("1", [{ codigo_finalizadora: "99", valor: 10 }])], chaveCupom, formatar);

    expect(linha.finalizadora_descricao).toBe("99");
  });
});

describe("ordenarMantendoFilhas", () => {
  const cupons = [
    cupom("1", [{ descricao: "Dinheiro", valor: 30 }], { valor_total_original: 30 }),
    cupom("2", [
      { descricao: "Dinheiro", valor: 50 },
      { descricao: "Cartão", valor: 70 },
    ], { valor_total_original: 120 }),
    cupom("3", [{ descricao: "PIX", valor: 10 }], { valor_total_original: 10 }),
  ];

  const linhas = montarLinhasSinteticas(cupons, chaveCupom, formatar);

  it("ordena os cupons e leva as formas junto do cupom delas", () => {
    const ordenadas = ordenarMantendoFilhas(linhas, "valor_total_original", false, chaveCupom);

    // 10, 30, 120 — e as duas formas do cupom 2 logo depois dele, nao soltas.
    expect(ordenadas.map((l) => l.codigo || l.finalizadora_descricao)).toEqual([
      "3",
      "1",
      "2",
      "Dinheiro",
      "Cartão",
    ]);
  });

  it("ordem decrescente mantem o mesmo vinculo", () => {
    const ordenadas = ordenarMantendoFilhas(linhas, "valor_total_original", true, chaveCupom);

    expect(ordenadas.map((l) => l.codigo || l.finalizadora_descricao)).toEqual([
      "2",
      "Dinheiro",
      "Cartão",
      "1",
      "3",
    ]);
  });

  it("sem coluna de ordenacao devolve na ordem original, com as filhas no lugar", () => {
    const ordenadas = ordenarMantendoFilhas(linhas, null, false, chaveCupom);

    expect(ordenadas.map((l) => l.codigo || l.finalizadora_descricao)).toEqual([
      "1",
      "2",
      "Dinheiro",
      "Cartão",
      "3",
    ]);
  });

  it("nenhuma linha de forma fica orfa depois de ordenar", () => {
    const ordenadas = ordenarMantendoFilhas(linhas, "valor_total_original", false, chaveCupom);

    ordenadas.forEach((linha, indice) => {
      if (!linha.ehLinhaFinalizadora) return;

      // Acima de toda linha de forma existe o cupom dela (direta ou
      // indiretamente, quando o cupom tem mais de uma forma).
      const anterior = ordenadas[indice - 1];
      const chaveAnterior = anterior.ehLinhaFinalizadora ? anterior.chavePai : chaveCupom(anterior);
      expect(chaveAnterior).toBe(linha.chavePai);
    });
  });
});
