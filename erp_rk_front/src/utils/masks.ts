import { format, parseISO } from "date-fns";

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
export function maskQuantityToFloat(value: string, decimalPlaces: number = 2): number | string {
  if (typeof value === "string") {
    // Remove pontos de milhar e troca vírgula por ponto
    const normalized = value.replace(/\./g, "").replace(",", ".");

    // Converte para número com parseFloat
    const parsed = parseFloat(normalized);

    if (isNaN(parsed)) return value;

    // Arredonda para a quantidade de casas decimais
    return parseFloat(parsed.toFixed(decimalPlaces));
  }

  return value;
}
export function maskMoneyToFloat(value: string) {
  if (typeof value === "string") {
    let numericValue: number;
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

export function maskNCM(ncm: string) {
  let ncmNew;
  ncmNew = ncm.replace(/\./g, "");
  ncmNew = ncmNew.padStart(8, "0");
  return ncmNew;
}
export function maskCEST(cest: string) {
  let ncmNew;
  ncmNew = cest.replace(/\./g, "");
  ncmNew = ncmNew.padStart(7, "0");
  return ncmNew;
}

// Tira os zeros de enchimento de um código, só para exibir.
//
// O código do título nasce da retaguarda como cupom + parcela, e o cupom vem
// preenchido até o tamanho da coluna: "00000000000000000000000000000106780001"
// são 38 caracteres para mostrar 106780001. Na grade isso come a largura de
// várias colunas sem informar nada.
//
// SÓ PARA EXIBIÇÃO: o valor original continua sendo o que vai para o filtro, a
// API e a chave do registro — é ele que casa com a retaguarda e com o PDV.
//
// Código não numérico fica como está (ali o zero pode fazer parte do código), e
// um código todo de zeros continua sendo "0", nunca vazio.
export function semZerosEsquerda(valor: any): string {
  const texto = String(valor ?? "").trim();
  if (!/^[0-9]+$/.test(texto)) return texto;

  const semZeros = texto.replace(/^0+/, "");
  return semZeros === "" ? "0" : semZeros;
}

export function zeroEsquerda(str: string, max: number) {
  str = str.toString();
  str = str.length < max ? str.padStart(max, "0") : str; // zero à esquerda
  str = str.length > max ? str.substr(0, max) : str; // máximo de caracteres
  return str;
}

export function maskDateBR(date: any) {
  const parsedDate = parseISO(date); // Converte a string para objeto Date
  const formattedDate = format(parsedDate, "dd/MM/yyyy");
  return formattedDate;
}
