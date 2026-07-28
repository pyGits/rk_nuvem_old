export function formatMoney(value: number): string {
  const numeric = unformatMoney(String(value));
  return numeric.toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
    minimumFractionDigits: 2,
  });
}

export function unformatMoney(value: string): number {
  if (typeof value === "string") {
    // Mantém apenas números e o sinal de negativo no início
    let clean = value.replace(/[^\d-]/g, "");

    // Corrige casos onde o usuário começa com "0"
    if (clean === "" || clean === "-") return 0;

    let negative = false;
    if (clean.startsWith("-")) {
      negative = true;
      clean = clean.substring(1);
    }

    const numericValue = Number(clean) / 100;
    return negative ? -numericValue : numericValue;
  } else {
    return value;
  }
}
