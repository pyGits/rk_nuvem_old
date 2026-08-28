import ContaReceber from "./ContaReceber";
import ContaReceberTitulo from "./ContaReceberTitulo";
import ContaReceberTituloList from "./ContaReceberTituloList";
import RecebimentoTitulo from "./RecebimentoTitulo";

// O rateio do recebimento é a regra de dinheiro do módulo e roda sem banco.
// Um erro aqui abate o título errado, ou abate valor a mais, e só aparece na
// conferência de caixa do cliente.

function titulo(id: string, valor: number, cliente = "1"): ContaReceberTitulo {
  const item = new ContaReceberTitulo();
  item.id = id;
  item.codigo = id;
  item.clienteCodigo = cliente;
  item.valor = valor;
  return item;
}

function lista(...titulos: ContaReceberTitulo[]): ContaReceberTituloList {
  const list = new ContaReceberTituloList();
  titulos.forEach((item) => list.adicionarTitulo(item));
  return list;
}

function recebimento(valor: number, extras: Partial<RecebimentoTitulo> = {}): RecebimentoTitulo {
  return new RecebimentoTitulo(valor, extras.formaPagamento ?? "01", extras.juros ?? 0, extras.multa ?? 0, extras.desconto ?? 0, extras.dataPagamento ?? "2026-08-27");
}

describe("ContaReceberTituloList.registrarRecebimento", () => {
  it("consome os títulos na ordem recebida e liquida só o que couber", () => {
    const list = lista(titulo("a", 100), titulo("b", 100));

    list.registrarRecebimento(recebimento(150));

    expect(list.items[0].valorAReceber()).toBe(0);
    expect(list.items[0].status).toBe("LIQUIDADO");
    expect(list.items[1].valorAReceber()).toBe(50);
    expect(list.items[1].status).toBe("ABERTO");
  });

  it("rateia desconto, juros e multa na proporção do que cada título absorveu", () => {
    const list = lista(titulo("a", 100), titulo("b", 300));

    // Abatimento = 380 + 20 de desconto = 400, que quita os dois títulos.
    list.registrarRecebimento(recebimento(380, { desconto: 20, juros: 8, multa: 4 }));

    const [primeiro, segundo] = list.items.map((item) => item.recebimentos[0]);

    expect(primeiro.desconto).toBe(5);
    expect(segundo.desconto).toBe(15);
    expect(primeiro.juros).toBe(2);
    expect(segundo.juros).toBe(6);
    expect(primeiro.multa).toBe(1);
    expect(segundo.multa).toBe(3);

    // O que foi gravado tem que fechar com o que foi digitado.
    expect(primeiro.valor + segundo.valor).toBe(380);
    expect(list.valorReceber()).toBe(0);
  });

  it("não deixa sobrar centavo: a soma dos abatimentos zera os títulos", () => {
    const list = lista(titulo("a", 33.33), titulo("b", 33.33), titulo("c", 33.34));

    list.registrarRecebimento(recebimento(100));

    expect(list.valorReceber()).toBe(0);
    list.items.forEach((item) => expect(item.status).toBe("LIQUIDADO"));
  });

  it("recusa abatimento maior que o saldo", () => {
    const list = lista(titulo("a", 100));

    expect(() => list.registrarRecebimento(recebimento(90, { desconto: 30 }))).toThrow("Valor recebido maior que o saldo dos títulos !");
  });

  it("recusa valor zerado ou negativo", () => {
    const list = lista(titulo("a", 100));

    expect(() => list.registrarRecebimento(recebimento(0))).toThrow("Valor do recebimento não pode ser 0 ou negativo !");
    expect(() => list.registrarRecebimento(recebimento(-10))).toThrow("Valor do recebimento não pode ser 0 ou negativo !");
  });

  it("recusa seleção vazia", () => {
    expect(() => lista().registrarRecebimento(recebimento(10))).toThrow("Nenhum título selecionado !");
  });

  it("recusa títulos de clientes diferentes na mesma baixa", () => {
    const list = lista(titulo("a", 100, "1"), titulo("b", 100, "2"));

    expect(() => list.registrarRecebimento(recebimento(50))).toThrow("Selecione títulos de um mesmo cliente !");
  });

  // O backend valida título a título, e não pelo saldo somado: um título já
  // liquidado no meio da seleção derruba a baixa inteira, em vez de ser
  // silenciosamente ignorado.
  it("recusa a baixa quando algum título da seleção já está liquidado", () => {
    const list = lista(titulo("a", 100), titulo("b", 100));
    list.registrarRecebimento(recebimento(100));

    expect(() => list.registrarRecebimento(recebimento(100))).toThrow("Título a já está liquidado !");
    expect(list.items[0].recebimentos).toHaveLength(1);
  });

  it("recusa título cancelado na seleção", () => {
    const cancelado = titulo("a", 100);
    cancelado.cancelar();

    expect(() => lista(cancelado).registrarRecebimento(recebimento(10))).toThrow("Título a está cancelado !");
  });
});

describe("ContaReceber.gerarTitulos", () => {
  it("divide o valor entre as parcelas e joga a diferença na última", () => {
    const conta = new ContaReceber();
    conta.lojaId = 1;
    conta.clienteCodigo = "1";
    conta.descricao = "TESTE";
    conta.valorNominal = 100;
    conta.parcelas = 3;
    conta.intervalo = 30;
    conta.tipoIntervalo = "dias";
    conta.dataVencimento = "2026-08-27";

    conta.gerarTitulos();

    const valores = conta.titulos.items.map((item) => item.valor);
    expect(valores).toHaveLength(3);
    expect(valores[0] + valores[1] + valores[2]).toBe(100);
    expect(conta.titulos.items.map((item) => item.prestacao)).toEqual([1, 2, 3]);
  });
});
