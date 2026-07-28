import ContaPagar, { SubCategoriaRateio } from "@/infra/entity/ContaPagar";

describe("Teste Contas A Pagar", () => {
  describe("ContaPagar", () => {
    it("atualiza valor ao digitar percentual", () => {
      const conta = new ContaPagar();
      conta.valorNominal = 1000;
      conta.categoriaFinanceira.percentual = 10;
      conta.atualizarValorCategoriaFinanceira();
      expect(conta.categoriaFinanceira.valor).toBe(100);
    });

    it("atualiza percentual ao digitar valor", () => {
      const conta = new ContaPagar();
      conta.valorNominal = 2000;
      conta.categoriaFinanceira.valor = 400;
      conta.atualizarPercentualCategoriaFinanceira();
      expect(conta.categoriaFinanceira.percentual).toBe(20);
    });
    it("atualiza todos os valores de rateio ao mudar valorNominal", () => {
      const conta = new ContaPagar();

      conta.valorNominal = 1000;
      conta.categoriaFinanceira.percentual = 10;
      conta.categoriaFinanceira.valor = 100;
      conta.categoriaFinanceira.subcategoria_id = "3";

      conta.adicionarCategoriaFinanceira();

      // Define o valor nominal novo
      conta.valorNominal = 2000;

      // Chama o método que atualiza os valores baseado no percentual
      conta.atualizar();

      // Esperado: 10% de 2000 = 200
      expect(conta.categoriaFinanceiraList[0].valor).toBe(200);

      // resetar valor
      expect(conta.categoriaFinanceira.percentual).toBe(90);
      expect(conta.categoriaFinanceira.valor).toBe(1800);
    });

    it("adiciona uma subcategoria ao clicar no botão", () => {
      const conta = new ContaPagar();
      conta.valorNominal = 1000;
      conta.categoriaFinanceira.subcategoria_id = "123";
      conta.categoriaFinanceira.percentual = 10;
      conta.categoriaFinanceira.valor = 100;

      conta.adicionarCategoriaFinanceira();

      expect(conta.categoriaFinanceiraList.length).toBe(1);
      expect(conta.categoriaFinanceiraList[0].subcategoria_id).toBe("123");
      expect(conta.categoriaFinanceiraList[0].valor).toBe(100);
      expect(conta.categoriaFinanceira.valor).toBe(900);
      expect(conta.categoriaFinanceira.percentual).toBe(90);

      conta.categoriaFinanceira.valor = 1000;
      conta.categoriaFinanceira.subcategoria_id = "3";
      expect(() => conta.adicionarCategoriaFinanceira()).toThrow("Valor excede o total");
    });
  });

  it("Deve gerar titulos a pagar por prazo em dias", () => {
    const conta = new ContaPagar("1", "1", "123", undefined, 110, 0, 0);

    conta.parcelas = 10;
    conta.intervalo = 31;
    conta.dataVencimento = new Date("2025-06-03");

    conta.gerarTitulosDias();

    expect(conta.valorTotal()).toBe(110);
    expect(conta.titulos.items.length).toBe(10);

    expect(conta.titulos.items[0].vencimento).toStrictEqual(new Date("2025-06-03"));
    expect(conta.titulos.items[0].valor).toBe(11);
    expect(conta.titulos.items[0].seq).toBe(1);

    expect(conta.titulos.items[1].vencimento).toStrictEqual(new Date("2025-07-04"));
    expect(conta.titulos.items[1].seq).toBe(2);
    expect(conta.titulos.items[1].valor).toBe(11);

    expect(conta.titulos.items[2].vencimento).toStrictEqual(new Date("2025-08-04"));
    expect(conta.titulos.items[2].seq).toBe(3);
    expect(conta.titulos.items[2].valor).toBe(11);
  });
  it("Deve gerar titulos a pagar por prazo em mes", () => {
    const conta = new ContaPagar("1", "1", "123", undefined, 110, 0, 0);

    conta.parcelas = 10;
    conta.intervalo = 1;
    conta.dataVencimento = new Date("2025-06-03");

    conta.gerarTitulosMes();

    expect(conta.valorTotal()).toBe(110);
    expect(conta.titulos.items.length).toBe(10);

    expect(conta.titulos.items[0].vencimento).toStrictEqual(new Date("2025-06-03"));
    expect(conta.titulos.items[0].valor).toBe(11);
    expect(conta.titulos.items[0].seq).toBe(1);

    expect(conta.titulos.items[1].vencimento).toStrictEqual(new Date("2025-07-03"));
    expect(conta.titulos.items[1].seq).toBe(2);
    expect(conta.titulos.items[1].valor).toBe(11);

    expect(conta.titulos.items[2].vencimento).toStrictEqual(new Date("2025-08-03"));
    expect(conta.titulos.items[2].seq).toBe(3);
    expect(conta.titulos.items[2].valor).toBe(11);
  });

  it("Deve validar contas a pagar", () => {
    const conta = new ContaPagar("1", "1", "123", undefined, 110, 0, 0);

    conta.parcelas = 10;
    conta.intervalo = 31;
    conta.dataVencimento = new Date("2025-06-03");

    conta.numeroDocumento = "";
    expect(() => {
      conta.validate();
    }).toThrow();

    conta.numeroDocumento = "123";
    conta.titulos.limpar();
    expect(() => {
      conta.validate();
    }).toThrow();

    conta.valorNominal = 0;
    // sem valor nominal
    expect(() => {
      conta.gerarTitulosDias();
    }).toThrow();
  });
});
