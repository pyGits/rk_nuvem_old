import Finalizadora from "../models/Finalizadora";
import Funcionario from "../models/Funcionario";
import Loja from "../models/Loja";
import Preco from "../models/Preco";
import Produto from "../models/Produto";
import Tenant from "../models/Tenant";
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

// Mesma leitura de estado que o front do cliente ja faz, so que montada aqui
// porque o painel administrativo lista lojas de varios tenants de uma vez.
function estadoDaCarga(carga: Carga | undefined) {
  return {
    cargaStatus: carga ? carga.status : "CONCLUIDA",
    cargaTipo: carga ? carga.carga : null,
    cargaEtapa: carga ? carga.etapa : null,
    cargaIndice: carga ? carga.indice : null,
    cargaTotal: carga ? carga.total : null,
    cargaPercentual: carga ? percentualDaCarga(carga) : null,
  };
}

// A consulta de carga do sync bate de poucos em poucos segundos, por loja, de
// todos os tenants. Registrar a mesma resposta a cada tique produzia dezenas de
// linhas por minuto sem informacao nova, e um erro de verdade ficava enterrado
// nelas - foi o que atrapalhou o diagnostico de um incidente em producao.
//
// Mesma solucao que o agente Delphi ja usa do outro lado (FUltimaRespostaCarga
// em uAPIRequest.pas): guarda a ultima resposta de cada loja e so registra
// quando ela muda. A informacao que motivou este log continua toda ali - o que
// some e a repeticao.
const ultimaRespostaCarga = new Map<string, string>();

function logCargaSeMudou(tenant_id: number, loja: string, mensagem: string) {
  const chave = `${tenant_id}:${loja}`;
  if (ultimaRespostaCarga.get(chave) === mensagem) return;
  ultimaRespostaCarga.set(chave, mensagem);
  console.log(mensagem);
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
      logCargaSeMudou(
        tenant_id,
        loja,
        `[CARGA] consulta tenant=${tenant_id} loja="${loja}" -> CARGA_NADA ` +
          (pendente
            ? `(existe ${pendente.carga}/${pendente.status})`
            : `(nenhuma pedida; na lista: ${JSON.stringify(
                cargaList.map((c) => ({ tenant: c.tenant_id, loja: c.codigo, status: c.status }))
              )})`)
      );
      return res.status(200).json({ message: "CARGA_NADA" });
    }

    logCargaSeMudou(tenant_id, loja, `[CARGA] consulta tenant=${tenant_id} loja="${loja}" -> ${pendente.carga}`);

    // A entrada so sai da lista quando o sync avisa que terminou
    // (finalizaCarga), para o front conseguir mostrar a carga em andamento.
    pendente.status = "EM_ANDAMENTO";
    pendente.iniciadaEm = Date.now();

    res.status(200).json({
      message: pendente.carga === "ALTERADOS" ? "CARGA_ALTERADOS" : "CARGA_COMPLETA",
    });
  },

  // --- Painel administrativo -------------------------------------------------
  // O suporte enxerga as lojas de todos os clientes. Tudo abaixo reaproveita a
  // mesma cargaList e o mesmo solicitaCarga do fluxo do cliente: o sync continua
  // perguntando por /carga/:loja com o token da propria loja e nao sabe (nem
  // precisa saber) quem pediu a carga. Nada aqui altera o fluxo existente.

  async listaLojasAdmin(req: any, res: any) {
    const [lojas, tenants]: any[] = await Promise.all([
      Loja.findAll({
        attributes: ["tenant_id", "codigo", "nome", "fantasia"],
        order: [
          ["tenant_id", "ASC"],
          ["codigo", "ASC"],
        ],
      }),
      Tenant.findAll({ attributes: ["id", "name", "user", "ativo"] }),
    ]);

    const clientePorId = new Map<number, any>();
    tenants.forEach((tenant: any) => clientePorId.set(tenant.id, tenant));

    res.status(200).json(
      lojas.map((loja: any) => {
        const tenant = clientePorId.get(loja.tenant_id);

        return {
          // O par cliente+codigo e o que identifica a loja: o codigo sozinho se
          // repete entre clientes e nao serve de chave na tabela do front.
          chave: `${loja.tenant_id}-${loja.codigo}`,
          tenantId: loja.tenant_id,
          cliente: tenant?.name || tenant?.user || `Cliente ${loja.tenant_id}`,
          clienteAtivo: tenant ? tenant.ativo === "S" : false,
          codigo: String(loja.codigo),
          nome: loja.nome,
          fantasia: loja.fantasia,
          ...estadoDaCarga(achaCarga(loja.tenant_id, String(loja.codigo))),
        };
      })
    );
  },

  // Consulta so a lista em memoria, para o polling da tela nao bater no banco a
  // cada 2 segundos.
  async statusAdmin(req: any, res: any) {
    res.status(200).json(
      cargaList.map((c) => ({
        chave: `${c.tenant_id}-${c.codigo}`,
        tenantId: c.tenant_id,
        codigo: c.codigo,
        ...estadoDaCarga(c),
      }))
    );
  },

  async enviaCargaAdmin(req: any, res: any) {
    const tipo = req.body?.carga === "ALTERADOS" ? "ALTERADOS" : "COMPLETA";
    // "todas" e explicito de proposito: uma lista vazia por engano nao pode
    // virar carga para o parque inteiro.
    const todas = req.body?.todas === true;
    const selecionadas = Array.isArray(req.body?.lojas) ? req.body.lojas : [];

    // solicitaCarga e por tenant; o admin e o unico que alcanca mais de um de
    // uma vez, entao o agrupamento fica aqui. Set porque a mesma loja repetida
    // na requisicao nao pode contar duas vezes.
    const porCliente = new Map<number, Set<string>>();
    const acumula = (tenantId: number, codigo: string) => {
      if (!tenantId || !codigo) return;
      if (!porCliente.has(tenantId)) porCliente.set(tenantId, new Set());
      porCliente.get(tenantId)!.add(codigo);
    };

    if (todas) {
      // Cliente desativado nao tem sync rodando: a carga so ficaria presa na
      // lista ate expirar por TEMPO_MAX_EM_ANDAMENTO.
      const ativos: any[] = await Tenant.findAll({ where: { ativo: "S" }, attributes: ["id"] });
      const ids = ativos.map((tenant: any) => tenant.id);

      if (ids.length) {
        const lojas: any[] = await Loja.findAll({
          where: { tenant_id: ids },
          attributes: ["tenant_id", "codigo"],
        });
        lojas.forEach((loja: any) => acumula(loja.tenant_id, String(loja.codigo)));
      }
    } else {
      selecionadas.forEach((loja: any) =>
        acumula(Number(loja?.tenantId ?? loja?.tenant_id), String(loja?.codigo ?? "").trim())
      );
    }

    if (!porCliente.size) {
      return res.status(400).json({ message: "Nenhuma loja para enviar carga." });
    }

    let lojasSolicitadas = 0;
    porCliente.forEach((codigos, tenantId) => {
      solicitaCarga(
        tenantId,
        Array.from(codigos).map((codigo) => ({ codigo })),
        tipo
      );
      lojasSolicitadas += codigos.size;
    });

    console.log(
      `[CARGA][ADMIN] ${tipo} pedida para ${lojasSolicitadas} loja(s) de ` +
        `${porCliente.size} cliente(s) por "${req.userAdmin}"`
    );

    res.status(200).json({
      message: "Carga Solicitada !",
      carga: tipo,
      lojas: lojasSolicitadas,
      clientes: porCliente.size,
    });
  },
};
