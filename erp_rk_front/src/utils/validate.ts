export function validarEmail(email: string) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Expressão regular para verificar o formato do email

  if (regex.test(email)) {
    // O email está em um formato válido
    return true;
  } else {
    // O email não está em um formato válido
    return false;
  }
}
export function validarCpfCnpj(cpfCnpj: string) {
  cpfCnpj = cpfCnpj.replace(/[^\d]+/g, ""); // remove caracteres não numéricos

  if (cpfCnpj.length === 11) {
    // Validar CPF
    let sum = 0;
    let rest;

    if (cpfCnpj === "00000000000") {
      return false;
    }

    for (let i = 1; i <= 9; i++) {
      sum += parseInt(cpfCnpj.substring(i - 1, i)) * (11 - i);
    }

    rest = (sum * 10) % 11;

    if (rest === 10 || rest === 11) {
      rest = 0;
    }

    if (rest !== parseInt(cpfCnpj.substring(9, 10))) {
      return false;
    }

    sum = 0;

    for (let i = 1; i <= 10; i++) {
      sum += parseInt(cpfCnpj.substring(i - 1, i)) * (12 - i);
    }

    rest = (sum * 10) % 11;

    if (rest === 10 || rest === 11) {
      rest = 0;
    }

    if (rest !== parseInt(cpfCnpj.substring(10, 11))) {
      return false;
    }

    return true;
  } else if (cpfCnpj.length === 14) {
    cpfCnpj = cpfCnpj.replace(/[^\d]+/g, "");

    if (cpfCnpj == "") return false;

    if (cpfCnpj.length != 14) return false;

    // Elimina CNPJs invalidos conhecidos
    if (
      cpfCnpj == "00000000000000" ||
      cpfCnpj == "11111111111111" ||
      cpfCnpj == "22222222222222" ||
      cpfCnpj == "33333333333333" ||
      cpfCnpj == "44444444444444" ||
      cpfCnpj == "55555555555555" ||
      cpfCnpj == "66666666666666" ||
      cpfCnpj == "77777777777777" ||
      cpfCnpj == "88888888888888" ||
      cpfCnpj == "99999999999999"
    )
      return false;

    // Valida DVs
    let tamanho = cpfCnpj.length - 2;
    let numeros = cpfCnpj.substring(0, tamanho);
    const digitos = cpfCnpj.substring(tamanho);
    let soma = 0;
    let pos = tamanho - 7;
    for (let i = tamanho; i >= 1; i--) {
      soma += parseInt(numeros.charAt(tamanho - i)) * pos--;
      if (pos < 2) pos = 9;
    }
    let resultado = soma % 11 < 2 ? 0 : 11 - (soma % 11);
    if (resultado != parseInt(digitos.charAt(0))) return false;

    tamanho = tamanho + 1;
    numeros = cpfCnpj.substring(0, tamanho);
    soma = 0;
    pos = tamanho - 7;
    for (let i = tamanho; i >= 1; i--) {
      soma += parseInt(numeros.charAt(tamanho - i)) * pos--;
      if (pos < 2) pos = 9;
    }
    resultado = soma % 11 < 2 ? 0 : 11 - (soma % 11);
    if (resultado != parseInt(digitos.charAt(1))) return false;

    return true;
  } else {
    return false;
  }
}
