// Apresentacao do status da carga para as lojas. Mora aqui porque duas telas
// mostram o mesmo estado: a do cliente (Carga/Loja.vue) e a do painel
// administrativo, que enxerga as lojas de todos os clientes.
//
// Sync que reporta etapa manda o percentual junto; o antigo nao manda nada e
// cai na barra indeterminada. Por isso os dois caminhos convivem aqui.
const ETAPAS: Record<string, string> = {
  PDV: "Enviando para o PDV",
  PRODUTOS: "Enviando produtos",
  PRECOS: "Enviando preços",
  TRIBUTACOES: "Enviando tributações",
  FINALIZADORAS: "Enviando finalizadoras",
  CLIENTES: "Enviando clientes",
  FUNCIONARIOS: "Enviando funcionários",
};

const ESTADOS: Record<string, any> = {
  CONCLUIDA: {
    texto: "Concluída",
    icone: "mdi-check-circle-outline",
    cor: "success",
    valor: 100,
  },
  EM_ANDAMENTO: {
    texto: "Enviando...",
    icone: "mdi-progress-upload",
    cor: "primary",
    valor: 0,
    indeterminado: true,
  },
  PENDENTE: {
    texto: "Aguardando sync",
    icone: "mdi-clock-outline",
    cor: "warning",
    valor: 0,
    aguardando: true,
  },
};

const ESTADO_DESCONHECIDO = {
  texto: "Verificando...",
  icone: "mdi-help-circle-outline",
  cor: "grey",
  valor: 0,
};

// `item` e a loja com os campos cargaStatus / cargaEtapa / cargaIndice /
// cargaTotal / cargaPercentual, como as duas telas ja montam.
export function estadoDaCarga(item: any): any {
  const base = ESTADOS[item.cargaStatus] || ESTADO_DESCONHECIDO;

  if (item.cargaStatus !== "EM_ANDAMENTO" || item.cargaPercentual == null) {
    return base;
  }

  return {
    ...base,
    texto: ETAPAS[item.cargaEtapa] || item.cargaEtapa || base.texto,
    valor: item.cargaPercentual,
    indeterminado: false,
    mostraPercentual: true,
    detalhe:
      item.cargaIndice && item.cargaTotal
        ? `Etapa ${item.cargaIndice} de ${item.cargaTotal}`
        : "",
  };
}
