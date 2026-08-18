import * as XLSX from "xlsx";
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";

export function gerarExcel(valor: any, nomeArquivo = "data.xlsx") {
  const workbook = XLSX.utils.book_new();

  const worksheet = XLSX.utils.json_to_sheet(valor);

  XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet 1");

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
