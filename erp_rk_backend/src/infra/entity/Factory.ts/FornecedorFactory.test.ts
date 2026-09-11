import { Emitente, Endereco, NotaFiscal } from "../NotaFiscal";
import FornecedorFactory from "./FornecedorFactory";

// Nota de emitente pessoa física (produtor rural, por exemplo) vem sem CNPJ,
// só com CPF. O fornecedor montado a partir dela precisa sair com o documento
// preenchido, senão a aba Fornecedor da entrada de nota fica sem CNPJ/CPF e
// não dá para cadastrar nem associar.
function notaComEmitente(cnpj: string, cpf: string): NotaFiscal {
  const nota = new NotaFiscal();
  nota.emitente = new Emitente("JOSE DA SILVA", "SITIO BOA VISTA", "jose@sitio.com.br", cpf, cnpj, "", "", "ISENTO", "", "", new Endereco("SP"));
  return nota;
}

test("usa o CPF do emitente quando a nota não tem CNPJ", () => {
  const fornecedor = FornecedorFactory.createFromNotaFiscal(notaComEmitente("", "12345678901"));

  expect(fornecedor.cnpjcpf).toBe("12345678901");
});

test("usa o CNPJ do emitente quando ele existe", () => {
  const fornecedor = FornecedorFactory.createFromNotaFiscal(notaComEmitente("12345678000199", ""));

  expect(fornecedor.cnpjcpf).toBe("12345678000199");
});

test("fornecedor fica sem documento quando a nota não traz nem CNPJ nem CPF", () => {
  const fornecedor = FornecedorFactory.createFromNotaFiscal(notaComEmitente("", ""));

  expect(fornecedor.cnpjcpf).toBe("");
});
