export function maskDateBR(data: any): string {
  const dia = String(data.getDate()).padStart(2, "0");
  const mes = String(data.getMonth() + 1).padStart(2, "0"); // Janeiro = 0
  const ano = data.getFullYear();

  return `${dia}/${mes}/${ano}`;
}

export function maskMoney(value: number) {
  return Number(value).toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
  });
}
export function maskAmount(value: number) {
  if (typeof value === "number") {
    return value.toLocaleString("pt-BR", { minimumFractionDigits: 2 }) + "%";
  }
}
export function maskQtd(value: any) {
  if (typeof value === "number") {
    return value.toLocaleString("pt-BR", { minimumFractionDigits: 2 });
  } else {
    return Number(value).toLocaleString("pt-BR", { minimumFractionDigits: 2 });
  }
}
