// Regras de montagem do cupom sintético do Painel de Vendas.
//
// Ficam fora do componente por terem caso de borda que só se confere com
// teste: cupom sem forma de pagamento, cupom com uma, cupom com várias, e a
// ordenação da tabela, que não pode soltar a linha da forma do cupom dela.

export interface FormaPagamento {
  codigo_finalizadora?: string;
  descricao?: string;
  valor?: number | string;
  valor_troco?: number | string;
  prestacao?: number | string;
}

export interface CupomComFormas {
  finalizadoras?: FormaPagamento[];
  [campo: string]: any;
}

export interface LinhaSintetica {
  ehLinhaFinalizadora?: boolean;
  chavePai?: string;
  cupomPai?: CupomComFormas;
  indiceForma?: number;
  finalizadora_descricao: string;
  finalizadora_valor: string;
  finalizadora_troco: string;
  [campo: string]: any;
}

function nomeDaForma(forma: FormaPagamento): string {
  return forma.descricao || forma.codigo_finalizadora || "";
}

// Troco zerado polui a coluna: a imensa maioria dos pagamentos não tem troco.
function trocoVisivel(forma: FormaPagamento, formatar: (valor: any) => string): string {
  return Number(forma.valor_troco || 0) !== 0 ? formatar(forma.valor_troco) : "";
}

/**
 * A linha do cupom e, quando ele foi pago em MAIS DE UMA forma, uma linha por
 * forma logo abaixo dela.
 *
 * Com uma forma só não há linha extra: os dados cabem na própria linha do
 * cupom, e criar uma filha para cada cupom dobraria a altura da tabela sem
 * informação nova.
 */
export function montarLinhasSinteticas(
  cupons: CupomComFormas[],
  chaveCupom: (cupom: CupomComFormas) => string,
  formatarValor: (valor: any) => string
): LinhaSintetica[] {
  const linhas: LinhaSintetica[] = [];

  cupons.forEach((cupom) => {
    const formas = cupom.finalizadoras || [];

    if (formas.length <= 1) {
      const forma = formas[0];

      linhas.push({
        ...cupom,
        finalizadora_descricao: forma ? nomeDaForma(forma) : "",
        finalizadora_valor: forma ? formatarValor(forma.valor) : "",
        finalizadora_troco: forma ? trocoVisivel(forma, formatarValor) : "",
      });
      return;
    }

    linhas.push({
      ...cupom,
      finalizadora_descricao: `${formas.length} formas`,
      finalizadora_valor: "",
      finalizadora_troco: "",
    });

    formas.forEach((forma, indice) => {
      linhas.push({
        ehLinhaFinalizadora: true,
        // A chave do pai é o que mantém a filha junto dele na ordenação, e o
        // cupom inteiro vai junto para o clique abrir o detalhe certo.
        chavePai: chaveCupom(cupom),
        cupomPai: cupom,
        indiceForma: indice,
        cancelado: cupom.cancelado,
        numero: "",
        data: "",
        hora: "",
        caixa: "",
        valor_total_original: "",
        cpf_consumidor: "",
        cliente_nome: "",
        qtde_item_original: "",
        xml_venda: "",
        prestacao: forma.prestacao,
        finalizadora_descricao: nomeDaForma(forma),
        finalizadora_valor: formatarValor(forma.valor),
        finalizadora_troco: trocoVisivel(forma, formatarValor),
      });
    });
  });

  return linhas;
}

/**
 * Ordena SÓ as linhas de cupom e reinsere as formas de pagamento logo abaixo
 * da sua. Sem isto, ordenar por Valor Total espalharia as linhas de forma pela
 * tabela, longe do cupom a que pertencem.
 */
export function ordenarMantendoFilhas(
  linhas: LinhaSintetica[],
  campo: string | null,
  desc: boolean,
  chaveCupom: (cupom: CupomComFormas) => string
): LinhaSintetica[] {
  const pais = linhas.filter((linha) => !linha.ehLinhaFinalizadora);
  const filhasPorPai: Record<string, LinhaSintetica[]> = {};

  linhas
    .filter((linha) => linha.ehLinhaFinalizadora)
    .forEach((filha) => {
      const chave = String(filha.chavePai);
      if (!filhasPorPai[chave]) filhasPorPai[chave] = [];
      filhasPorPai[chave].push(filha);
    });

  if (campo) {
    pais.sort((a, b) => {
      const va = a[campo];
      const vb = b[campo];

      const ambosNumeros = typeof va === "number" && typeof vb === "number";
      const comparacao = ambosNumeros
        ? va - vb
        : String(va === null || va === undefined ? "" : va).localeCompare(
            String(vb === null || vb === undefined ? "" : vb),
            "pt-BR",
            { numeric: true }
          );

      return desc ? -comparacao : comparacao;
    });
  }

  const ordenadas: LinhaSintetica[] = [];
  pais.forEach((pai) => {
    ordenadas.push(pai);
    (filhasPorPai[chaveCupom(pai)] || []).forEach((filha) => ordenadas.push(filha));
  });

  return ordenadas;
}
