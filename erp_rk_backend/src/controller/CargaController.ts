import Finalizadora from "../models/Finalizadora";
import Funcionario from "../models/Funcionario";
import Preco from "../models/Preco";
import Produto from "../models/Produto";
import Tributacao from "../models/Tributacao";

type Carga = {
  tenant_id: number;
  codigo: string;
  carga: "COMPLETA" | "ALTERADOS";
  status: "PENDENTE" | "EM_ANDAMENTO";
  iniciadaEm: number | null;
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
const TEMPO_MAX_EM_ANDAMENTO = 30 * 60 * 1000;

let cargaList: Carga[] = [];

function achaCarga(tenant_id: number, codigo: string) {
  return cargaList.find((c) => c.tenant_id === tenant_id && c.codigo === codigo);
}

function removeCarga(tenant_id: number, codigo: string) {
  const index = cargaList.findIndex((c) => c.tenant_id === tenant_id && c.codigo === codigo);
  if (index !== -1) {
    cargaList.splice(index, 1);
  }
}

function solicitaCarga(tenant_id: number, lojas: any[], carga: "COMPLETA" | "ALTERADOS") {
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
function percentualDaCarga(carga: Carga) {
  if (!carga.indice || !carga.total) return null;

  const percentual = Math.round(((carga.indice - 0.5) / carga.total) * 100);
  return Math.min(99, Math.max(1, percentual));
}

export default {
  async verificaCargaStatus(req: any, res: any) {
    const { tenant_id } = req;
    const cargas = cargaList
      .filter((c) => c.tenant_id === tenant_id)
      .map((c) => ({
        codigo: c.codigo,
        carga: c.carga,
        status: c.status,
        etapa: c.etapa,
        indice: c.indice,
        total: c.total,
        percentual: percentualDaCarga(c),
      }));

    res.status(200).json(cargas);
  },

  // Rota nova e opcional: quem estiver com a versao antiga do sync simplesmente
  // nunca chama, e a carga continua funcionando igual.
  async atualizaProgressoCarga(req: any, res: any) {
    const { tenant_id } = req;
    const { loja, etapa } = req.query;
    const indice = Number(req.query.indice);
    const total = Number(req.query.total);

    const pendente = achaCarga(tenant_id, String(loja));
    if (!pendente) {
      return res.status(200).json({ message: "CARGA_NADA" });
    }

    if (etapa) pendente.etapa = String(etapa);
    if (indice > 0 && total > 0) {
      pendente.indice = indice;
      pendente.total = total;
    }
    // Cada etapa reportada tambem serve de heartbeat: uma carga demorada que
    // continua dando sinal de vida nao pode expirar por TEMPO_MAX_EM_ANDAMENTO.
    pendente.status = "EM_ANDAMENTO";
    pendente.iniciadaEm = Date.now();

    res.status(200).json({ message: "PROGRESSO_ATUALIZADO" });
  },

  async finalizaCarga(req: any, res: any) {
    const { tenant_id } = req;
    const loja = req.query.loja;
    try {
      await Promise.all([
        Produto.update({ carga_pendente: false }, { where: { tenant_id }, silent: true }),
        Preco.update({ carga_pendente: false }, { where: { tenant_id, loja: loja }, silent: true }),
        Finalizadora.update({ carga_pendente: false }, { where: { tenant_id } }),
        Funcionario.update({ carga_pendente: false }, { where: { tenant_id } }),
        Tributacao.update({ carga_pendente: false }, { where: { tenant_id } }),
      ]);

      removeCarga(tenant_id, String(loja));
      res.status(200).json({ message: "Carga finalizada" });
    } catch (error) {
      res.status(400).json({ message: "Erro ao finalizar carga" });
    }
  },

  async enviaCargaCompleta(req: any, res: any) {
    const { tenant_id } = req;
    solicitaCarga(tenant_id, req.body, "COMPLETA");
    res.status(200).json({ message: "Carga Solicitada !" });
  },
  async enviaCargaAlterados(req: any, res: any) {
    const { tenant_id } = req;
    solicitaCarga(tenant_id, req.body, "ALTERADOS");
    res.status(200).json({ message: "Carga Solicitada !" });
  },

  async verificaCarga(req: any, res: any) {
    const { tenant_id } = req;
    const loja = String(req.params.loja);
    const pendente = achaCarga(tenant_id, loja);

    const podeEnviar =
      pendente &&
      (pendente.status === "PENDENTE" ||
        Date.now() - (pendente.iniciadaEm ?? 0) > TEMPO_MAX_EM_ANDAMENTO);

    if (!pendente || !podeEnviar) {
      // Sem isto, "o sync nunca recebe a carga" e indistinguivel de "ninguem
      // pediu carga" e de "o codigo de loja que o sync pergunta nao e o mesmo
      // que o front gravou na lista".
      console.log(
        `[CARGA] consulta tenant=${tenant_id} loja="${loja}" -> CARGA_NADA ` +
          (pendente
            ? `(existe ${pendente.carga}/${pendente.status})`
            : `(nenhuma pedida; na lista: ${JSON.stringify(
                cargaList.map((c) => ({ tenant: c.tenant_id, loja: c.codigo, status: c.status }))
              )})`)
      );
      return res.status(200).json({ message: "CARGA_NADA" });
    }

    console.log(`[CARGA] consulta tenant=${tenant_id} loja="${loja}" -> ${pendente.carga}`);

    // A entrada so sai da lista quando o sync avisa que terminou
    // (finalizaCarga), para o front conseguir mostrar a carga em andamento.
    pendente.status = "EM_ANDAMENTO";
    pendente.iniciadaEm = Date.now();

    res.status(200).json({
      message: pendente.carga === "ALTERADOS" ? "CARGA_ALTERADOS" : "CARGA_COMPLETA",
    });
  },
};
