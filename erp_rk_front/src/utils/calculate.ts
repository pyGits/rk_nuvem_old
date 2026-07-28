export function calculateMarkup(custo: number, markup: number) {
  const vlrMargem = (markup * custo) / 100;
  const vlrVenda = vlrMargem + custo;
  return vlrVenda;
}

export function calculateMargemPraticada(preco: any) {
  if (preco.custo === 0) {
    return 0;
  }
  if (preco.oferta > 0) {
    const margemPraticada = ((preco.oferta - preco.custo) / preco.custo) * 100;
    return Number(margemPraticada.toFixed(2)) || 0;
  } else {
    const margemPraticada = ((preco.preco - preco.custo) / preco.custo) * 100;
    return Number(margemPraticada.toFixed(2)) || 0;
  }
}
export function calculateMarkDown(preco: any) {
  if (preco.oferta > 0) {
    const margemPraticada = ((preco.oferta - preco.custo) / preco.oferta) * 100;
    return Number(margemPraticada.toFixed(2)) || 0;
  } else if (preco.preco > 0) {
    const margemPraticada = ((preco.preco - preco.custo) / preco.preco) * 100;
    return Number(margemPraticada.toFixed(2)) || 0;
  } else {
    return 0;
  }
}
