// Mesma regra do backend (src/infra/repository/codigoCliente.ts), para o front
// conseguir casar um código de cliente vindo do cadastro com o gravado no
// título.
//
// O mesmo cliente aparece escrito de formas diferentes: o cadastro da web gera
// "1" e o título que veio do PDV guarda "000001". Comparar com === deixava o
// nome do cliente sem aparecer na grade.
export function chaveCodigoCliente(codigo: any): string {
  const texto = String(codigo ?? "").trim();
  if (!/^[0-9]+$/.test(texto)) return texto.toUpperCase();

  const semZeros = texto.replace(/^0+/, "");
  // "0" e "000" continuam sendo "0": vazio faria dois codigos invalidos
  // diferentes casarem entre si.
  return semZeros === "" ? "0" : semZeros;
}

// Compara dois códigos de cliente ignorando a diferença de escrita.
export function mesmoCliente(a: any, b: any): boolean {
  const chaveA = chaveCodigoCliente(a);
  return chaveA !== "" && chaveA === chaveCodigoCliente(b);
}
