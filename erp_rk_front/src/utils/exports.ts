import * as XLSX from "xlsx";
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";

interface AbaExcel {
  nome: string;
  // `linhas` são objetos e viram uma tabela com cabeçalho único. `matriz` é
  // linha a linha (array de arrays), para relatórios em bloco, onde cada
  // trecho tem um cabeçalho próprio.
  linhas?: any[];
  matriz?: any[][];
  // Largura das colunas, em caracteres.
  larguras?: number[];
}

// Aceita a lista de linhas de sempre (uma única planilha) ou, para os
// relatórios que precisam de mais controle, um objeto { abas: [...] }.
export function gerarExcel(valor: any, nomeArquivo = "data.xlsx") {
  const workbook = XLSX.utils.book_new();

  const abas: AbaExcel[] = Array.isArray(valor)
    ? [{ nome: "Sheet 1", linhas: valor }]
    : valor && Array.isArray(valor.abas) && valor.abas.length
    ? valor.abas
    : [{ nome: "Sheet 1", linhas: [] }];

  abas.forEach((aba) => {
    const worksheet = aba.matriz ? XLSX.utils.aoa_to_sheet(aba.matriz) : XLSX.utils.json_to_sheet(aba.linhas || []);

    if (aba.larguras) {
      (worksheet as any)["!cols"] = aba.larguras.map((largura) => ({ wch: largura }));
    }

    // O Excel nao aceita nome de planilha com mais de 31 caracteres.
    XLSX.utils.book_append_sheet(workbook, worksheet, (aba.nome || "Sheet 1").substring(0, 31));
  });

  const excelData = XLSX.write(workbook, { bookType: "xlsx", type: "array" });

  const blob = new Blob([excelData], {
    type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  });

  const url = window.URL.createObjectURL(blob);

  const link = document.createElement("a");
  link.href = url;
  link.download = nomeArquivo;
  link.click();

  window.URL.revokeObjectURL(url);
}

interface ColunaPDF {
  header: string;
  key: string;
}

// Gera um PDF em modo paisagem com uma tabela simples. `colunas` define a
// ordem/legenda das colunas (evita despejar todas as chaves do objeto, como o
// gerarExcel faz) e `linhas` são os dados já filtrados que estão na tela.
export function gerarPDF(titulo: string, colunas: ColunaPDF[], linhas: any[], nomeArquivo = "relatorio.pdf") {
  const doc = new jsPDF({ orientation: "landscape" });

  doc.setFontSize(14);
  doc.text(titulo, 14, 15);
  doc.setFontSize(9);
  doc.text(new Date().toLocaleString("pt-BR"), 14, 21);

  autoTable(doc, {
    startY: 26,
    head: [colunas.map((coluna) => coluna.header)],
    body: linhas.map((linha) => colunas.map((coluna) => linha[coluna.key] ?? "")),
    styles: { fontSize: 8 },
    headStyles: { fillColor: [41, 98, 255] },
  });

  doc.save(nomeArquivo);
}
