export function formatQuantity(value: number): string {
  value = unformatQuantity(String(value)); // reutiliza o mesmo parse
  return Number(value).toLocaleString("pt-BR", {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0, // ou 2 se quiser permitir decimais
  });
}

export function unformatQuantity(value: string): number {
  if (typeof value === "string") {
    let numericValue;
    if (value.includes("-")) {
      numericValue = Number(value.replace(/[^\d-]/g, "").replace(/[-]/g, ""));
      numericValue *= -1;
    } else {
      numericValue = Number(value.replace(/[^\d-]/g, ""));
    }

    return numericValue / 100;
  } else {
    return value;
  }
}
