// Fila de cargas pendentes para as lojas, em memória.
//
// Este código morava dentro do CargaController. Saiu de lá porque agora tem
// dois donos: as rotas de carga (pedido manual, painel administrativo) e o
// disparo automático (CargaAutomatica.ts), que precisa enfileirar carga sem
// passar por rota nenhuma. Controller importando controller para isso daria
// import circular; com a fila num módulo próprio, os dois lados importam daqui
// e nenhum importa o outro.
//
// Nada do comportamento mudou na mudança de arquivo: mesma lista, mesmas
// regras de promoção e de expiração.

export type Carga = {
  tenant_id: number;
  codigo: string;
  carga: "COMPLETA" | "ALTERADOS";
  status: "PENDENTE" | "EM_ANDAMENTO";
  // Ultimo sinal de vida do sync. Serve para expirar carga presa, e por isso
  // o /carga/progresso o empurra para a frente a cada etapa.
  iniciadaEm: number | null;
  // Momento em que o sync PEGOU esta carga, que o heartbeat acima nao mexe.
  // E o corte usado pelo finalizaCarga para nao dar como enviado o que foi
  // gravado depois que a carga ja tinha comecado. Ver o comentario la.
  comecouEm: number | null;
  // Quem pediu: a carga automatica, ou alguem clicando (tela do cliente ou
  // painel administrativo). O finalizaCarga so aplica o corte acima nas
  // automaticas - as manuais, que sao as que rodam no parque hoje, continuam
  // terminando exatamente como sempre terminaram.
  automatica: boolean;
  // Preenchidos so pelos syncs que reportam progresso. Versao antiga do sync
  // nunca chama /carga/progresso e esses campos ficam nulos — o front entao
  // mostra a barra indeterminada, como antes.
  etapa: string | null;
  indice: number | null;
  total: number | null;
};

// Se o sync cair no meio da carga a entrada ficaria presa em EM_ANDAMENTO para
// sempre (ninguem chamaria finalizaCarga). Passado esse tempo ela volta a ser
// servida para o sync.
export const TEMPO_MAX_EM_ANDAMENTO = 30 * 60 * 1000;

export const cargaList: Carga[] = [];

export function achaCarga(tenant_id: number, codigo: string) {
  return cargaList.find((c) => c.tenant_id === tenant_id && c.codigo === codigo);
}

export function removeCarga(tenant_id: number, codigo: string) {
  const index = cargaList.findIndex((c) => c.tenant_id === tenant_id && c.codigo === codigo);
  if (index !== -1) {
    cargaList.splice(index, 1);
  }
}

export function solicitaCarga(
  tenant_id: number,
  lojas: any[],
  carga: "COMPLETA" | "ALTERADOS",
  automatica = false
) {
  lojas.map((l: any) => {
    const codigo = String(l.codigo);
    const pendente = achaCarga(tenant_id, codigo);

    if (!pendente) {
      console.log(`[CARGA] pedida ${carga} tenant=${tenant_id} loja="${codigo}"`);
      cargaList.push({
        tenant_id,
        codigo,
        carga,
        status: "PENDENTE",
        iniciadaEm: null,
        comecouEm: null,
        automatica,
        etapa: null,
        indice: null,
        total: null,
      });
      return;
    }

    // Ja existe pedido para essa loja: so promove para completa se o sync ainda
    // nao comecou, senao a carga em andamento seria trocada no meio.
    if (pendente.status === "PENDENTE" && carga === "COMPLETA") {
      pendente.carga = "COMPLETA";
      // Carga completa leva o cadastro inteiro, nao so os alterados: nada fica
      // de fora por ter sido gravado no meio, entao ela termina como as
      // manuais sempre terminaram.
      pendente.automatica = false;
      console.log(`[CARGA] promovida para COMPLETA tenant=${tenant_id} loja="${codigo}"`);
      return;
    }

    // Entrada presa em EM_ANDAMENTO (sync caiu sem chamar finalizaCarga)
    // engole o pedido novo sem nenhum sinal, e o usuario fica clicando em
    // "carga completa" sem efeito ate os 30 min do TEMPO_MAX_EM_ANDAMENTO.
    const espera = Math.max(0, TEMPO_MAX_EM_ANDAMENTO - (Date.now() - (pendente.iniciadaEm ?? 0)));
    console.log(
      `[CARGA] pedido IGNORADO tenant=${tenant_id} loja="${codigo}" ` +
        `ja existe ${pendente.carga}/${pendente.status}, liberada em ${Math.round(espera / 1000)}s`
    );
  });
}

// O sync avisa qual etapa esta comecando, nao quanto dela ja rodou. A etapa em
// curso entra como metade concluida para a barra andar desde a primeira e nunca
// encostar em 100% antes do finalizaCarga.
export function percentualDaCarga(carga: Carga) {
  if (!carga.indice || !carga.total) return null;

  const percentual = Math.round(((carga.indice - 0.5) / carga.total) * 100);
  return Math.min(99, Math.max(1, percentual));
}

// Mesma leitura de estado que o front do cliente ja faz, so que montada aqui
// porque o painel administrativo lista lojas de varios tenants de uma vez.
export function estadoDaCarga(carga: Carga | undefined) {
  return {
    cargaStatus: carga ? carga.status : "CONCLUIDA",
    cargaTipo: carga ? carga.carga : null,
    cargaEtapa: carga ? carga.etapa : null,
    cargaIndice: carga ? carga.indice : null,
    cargaTotal: carga ? carga.total : null,
    cargaPercentual: carga ? percentualDaCarga(carga) : null,
  };
}
