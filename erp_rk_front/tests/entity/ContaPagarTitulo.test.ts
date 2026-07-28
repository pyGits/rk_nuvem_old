import ContaPagarTitulo from "@/infra/entity/ContaPagarTitulo";
import ContaPagarTituloList from "@/infra/entity/ContaPagarTituloList";
import FormaPagamento from "@/infra/entity/FormaPagamento";
import PagamentoTitulo from "@/infra/entity/PagamentoTitulo";

describe("Deve testar titulos", () => {
  it("Deve liquidar lista de titulos", () => {
    const titulo1 = new ContaPagarTitulo(1, undefined, 100);
    const titulo2 = new ContaPagarTitulo(2, undefined, 100);

    const titulos = new ContaPagarTituloList();
    titulos.adicionarTitulo(titulo1);
    titulos.adicionarTitulo(titulo2);

    expect(titulos.valorReceber()).toBe(200);
    titulos.registrarPagamento(new PagamentoTitulo(30, new FormaPagamento("1", "DINHEIRO")));

    expect(titulos.items[0].pagamentos[0].formaPagamento.nome).toBe("DINHEIRO");
    expect(titulos.items[0].pagamentos[0].formaPagamento.codigo).toBe("1");
    expect(titulos.items[0].pagamentos[0].valor).toBe(30);

    expect(titulos.items[0].status).toBe("ABERTO");
    expect(titulos.items[0].valorPago).toBe(30);
    expect(titulos.items[0].valorAPagar()).toBe(70);

    expect(titulos.items[1].valorPago).toBe(0);
    expect(titulos.items[1].valorAPagar()).toBe(100);
    expect(titulos.items[1].status).toBe("ABERTO");

    expect(titulos.valorPago()).toBe(30);
    expect(titulos.valorReceber()).toBe(170);
    expect(titulos.valorTotal()).toBe(200);

    titulos.registrarPagamento(new PagamentoTitulo(100, new FormaPagamento("1", "DEBITO")));

    expect(titulos.items[1].seq).toBe(2);

    expect(titulos.items[0].status).toBe("LIQUIDADO");
    expect(titulos.items[0].valorPago).toBe(100);
    expect(titulos.items[0].valorAPagar()).toBe(0);

    expect(titulos.items[0].pagamentos[1].formaPagamento.nome).toBe("DEBITO");
    expect(titulos.items[0].pagamentos[1].formaPagamento.codigo).toBe("1");
    expect(titulos.items[0].pagamentos[1].valor).toBe(70);

    expect(titulos.items[1].status).toBe("ABERTO");
    expect(titulos.items[1].valorPago).toBe(30);
    expect(titulos.items[1].valorAPagar()).toBe(70);

    expect(titulos.items[1].pagamentos[0].formaPagamento.nome).toBe("DEBITO");
    expect(titulos.items[1].pagamentos[0].formaPagamento.codigo).toBe("1");
    expect(titulos.items[1].pagamentos[0].valor).toBe(30);

    expect(titulos.valorPago()).toBe(130);
    expect(titulos.valorReceber()).toBe(70);
    expect(titulos.valorTotal()).toBe(200);

    titulos.registrarPagamento(new PagamentoTitulo(70, new FormaPagamento("1", "DINHEIRO")));
    expect(titulos.items[0].valorPago).toBe(100);
    expect(titulos.items[0].valorAPagar()).toBe(0);
    expect(titulos.items[0].status).toBe("LIQUIDADO");

    expect(titulos.items[1].valorPago).toBe(100);
    expect(titulos.items[1].valorAPagar()).toBe(0);
    expect(titulos.items[1].status).toBe("LIQUIDADO");

    expect(titulos.items[1].pagamentos[1].formaPagamento.nome).toBe("DINHEIRO");
    expect(titulos.items[1].pagamentos[1].formaPagamento.codigo).toBe("1");
    expect(titulos.items[1].pagamentos[1].valor).toBe(70);

    expect(titulos.valorPago()).toBe(200);
    expect(titulos.valorReceber()).toBe(0);
    expect(titulos.valorTotal()).toBe(200);
  });
  it("Deve estornar titulos", () => {
    const titulo1 = new ContaPagarTitulo(1, undefined, 100);
    const titulo2 = new ContaPagarTitulo(2, undefined, 100);

    const titulos = new ContaPagarTituloList();
    titulos.adicionarTitulo(titulo1);
    titulos.adicionarTitulo(titulo2);

    titulos.estornarTitulos();

    expect(titulos.items[0].status).toBe("ABERTO");
    expect(titulos.items[1].status).toBe("ABERTO");
  });
  it("Deve cancelar titulos", () => {
    const titulo1 = new ContaPagarTitulo(1, undefined, 100);
    const titulo2 = new ContaPagarTitulo(2, undefined, 100);

    const titulos = new ContaPagarTituloList();
    titulos.adicionarTitulo(titulo1);
    titulos.adicionarTitulo(titulo2);

    titulos.cancelarTitulos();

    expect(titulos.items[0].status).toBe("CANCELADO");
    expect(titulos.items[1].status).toBe("CANCELADO");
  });
  it("Deve validar pagamento", () => {
    const titulo1 = new ContaPagarTitulo(1, undefined, 100);
    const titulo2 = new ContaPagarTitulo(2, undefined, 100);

    const titulos = new ContaPagarTituloList();
    titulos.adicionarTitulo(titulo1);
    titulos.adicionarTitulo(titulo2);

    // forma pagamento zerada
    expect(() => {
      titulos.registrarPagamento(new PagamentoTitulo(0, new FormaPagamento("1", "DINHEIRO")));
    }).toThrow();
    // forma pagamento vazia
    expect(() => {
      titulos.registrarPagamento(new PagamentoTitulo(13, new FormaPagamento()));
    }).toThrow();

    // forma pagamento maior
    expect(() => {
      titulos.registrarPagamento(new PagamentoTitulo(210, new FormaPagamento("1", "DINHEIRO")));
    }).toThrow();

    // nenhuma form
    // expect(() => {
    //   titulos.validar();
    // }).toThrow("Nenhuma Forma de Pagamento Registrada !");

    titulos.registrarPagamento(new PagamentoTitulo(100, new FormaPagamento("1", "DINHEIRO")));

    // titulos.validar();
  });
});
