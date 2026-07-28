import * as XLSX from "xlsx";

export function gerarExcel(valor: any) {
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
  link.download = "data.xlsx";
  link.click();

  window.URL.revokeObjectURL(url);
}
