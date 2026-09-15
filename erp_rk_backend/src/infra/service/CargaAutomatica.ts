import Configuracao from "../../models/Configuracao";
import Loja from "../../models/Loja";
import { achaCarga, solicitaCarga } from "./FilaCarga";

// Carga automática: quando o cliente liga o parâmetro em Configurações, gravar
// um cadastro que vai para o PDV (produto, preço, estoque, tributação,
// finalizadora, funcionário, cliente) enfileira sozinho uma carga de ALTERADOS
// para as lojas dele.
//
// Antes disto a gravação só marcava `carga_pendente = true` e o dado ficava
// parado até alguém abrir a tela de carga e clicar em "Enviar alterados".
//
// QUEM CHAMA: o middleware em src/infra/middleware/cargaAutomatica.middleware.ts,
// depois que a requisição de gravação responde 2xx. Nenhum controller precisa
// saber que isto existe.
//
// POR PADRÃO A CARGA É PEDIDA NA HORA (janela 0): gravou, a loja entra na fila
// e o sync pega no tique seguinte, em até 5 segundos. É o que o usuário espera
// de "carga automática" — e um lote de gravações seguidas NÃO vira um lote de
// cargas, porque a segunda gravação encontra a loja já na fila e não enfileira
// nada (ver solicitaCarga); ela apenas entra na mesma carga que ainda não saiu.
//
// O que a gravação durante uma carga JÁ EM ANDAMENTO poderia causar — ser dada
// como enviada sem ter saído — está resolvido do outro lado, no finalizaCarga
// (CargaController), que só tira a marca de quem já estava gravado quando a
// carga começou. Sem aquilo, disparo imediato perderia alteração em silêncio.
//
// A janela configurável continua existindo para quem importa milhares de itens
// de uma vez e prefere uma carga só no fim: com ela, cada aviso reinicia um
// contador e a carga só é enfileirada quando o cliente para de gravar por esse
// tempo.
//
// SE O PROCESSO REINICIAR com o contador armado, aquela carga não sai — o
// timer é de memória, como a própria fila. Nada se perde: `carga_pendente`
// continua true no banco, então a próxima gravação (ou um envio manual) leva
// tudo o que ficou para trás.

// Zero é o imediato e o padrão. Acima de zero a janela agrupa, e aí o mínimo
// existe para que ela agrupe algo de fato: 1 ou 2 segundos não seguram lote
// nenhum e só atrasariam a carga sem nenhum ganho.
const JANELA_MINIMA_SEGUNDOS = 10;
const JANELA_MAXIMA_SEGUNDOS = 3600;
const JANELA_PADRAO_SEGUNDOS = 0;

// Quando alguma loja está com carga EM_ANDAMENTO na hora de enfileirar, o
// pedido novo seria engolido pela fila (ver solicitaCarga). Em vez de perder a
// alteração, reagenda para logo depois e tenta de novo.
const ESPERA_LOJA_OCUPADA_MS = 30 * 1000;

// A configuração é lida a cada disparo do contador, não a cada gravação — mas
// um cliente com vários usuários cadastrando gera disparo com frequência, e o
// parâmetro quase nunca muda. Cache curto, invalidado na gravação da tela de
// Configurações (esqueceConfiguracao).
const CACHE_CONFIG_MS = 30 * 1000;

type ConfigCarga = { ligada: boolean; janelaMs: number };

const cacheConfig = new Map<number, { config: ConfigCarga; lidaEm: number }>();
const contadores = new Map<number, NodeJS.Timeout>();
const ultimoAviso = new Map<number, number>();

// No modo imediato o disparo acontece a cada gravação, e a lista de lojas de um
// cliente muda uma vez por ano. Sem este cache, cadastrar 200 produtos seriam
// 200 consultas de loja. Loja recém-cadastrada entra na conta no próximo TTL.
const CACHE_LOJAS_MS = 60 * 1000;
const cacheLojas = new Map<number, { codigos: string[]; lidaEm: number }>();

async function lojasDoCliente(tenant_id: number): Promise<string[]> {
  const emCache = cacheLojas.get(tenant_id);
  if (emCache && Date.now() - emCache.lidaEm < CACHE_LOJAS_MS) {
    return emCache.codigos;
  }

  const lojas: any[] = await Loja.findAll({ where: { tenant_id }, attributes: ["codigo"] });
  const codigos = lojas.map((loja: any) => String(loja.getDataValue("codigo")));

  cacheLojas.set(tenant_id, { codigos, lidaEm: Date.now() });
  return codigos;
}

function normalizaSegundos(valor: any): number {
  const segundos = Number(valor);
  // Vazio, texto ou negativo caem no imediato — nunca num atraso que o cliente
  // não pediu.
  if (!Number.isFinite(segundos) || segundos <= 0) return 0;
  return Math.min(JANELA_MAXIMA_SEGUNDOS, Math.max(JANELA_MINIMA_SEGUNDOS, Math.round(segundos)));
}

// Exportada porque a tela de Configurações valida o valor com a mesma regra
// antes de gravar: o que o usuário vê salvo é o que vai valer aqui.
export function normalizaJanelaSegundos(valor: any): number {
  return normalizaSegundos(valor);
}

async function leConfiguracao(tenant_id: number): Promise<ConfigCarga> {
  const emCache = cacheConfig.get(tenant_id);
  if (emCache && Date.now() - emCache.lidaEm < CACHE_CONFIG_MS) {
    return emCache.config;
  }

  // Cliente sem linha na tabela é cliente que nunca abriu a tela: desligado.
  let config: ConfigCarga = { ligada: false, janelaMs: JANELA_PADRAO_SEGUNDOS * 1000 };
  try {
    const registro: any = await Configuracao.findOne({ where: { tenant_id } });
    if (registro) {
      config = {
        ligada: registro.getDataValue("carga_automatica") === true,
        janelaMs: normalizaSegundos(registro.getDataValue("carga_automatica_segundos")) * 1000,
      };
    }
  } catch (error: any) {
    // Falha de leitura não pode derrubar a gravação que disparou isto (o
    // usuário já recebeu o "salvo com sucesso"). Fica desligado.
    //
    // O caso real disto é o código subir antes de a migration rodar: a tabela
    // `configuracoes` não existe e TODA gravação cairia aqui. Por isso o
    // desligado também vai para o cache e o aviso sai uma vez a cada TTL, em
    // vez de uma linha por produto salvo enterrando o resto do log.
    const desligado = { ligada: false, janelaMs: JANELA_PADRAO_SEGUNDOS * 1000 };
    console.log("[CARGA][AUTO] falha ao ler a configuracao", error?.message || error);
    cacheConfig.set(tenant_id, { config: desligado, lidaEm: Date.now() });
    return desligado;
  }

  cacheConfig.set(tenant_id, { config, lidaEm: Date.now() });
  return config;
}

// Chamada quando o dono grava a tela de Configurações, para ligar/desligar
// valer na hora e não depois do TTL do cache.
export function esqueceConfiguracao(tenant_id: number) {
  cacheConfig.delete(tenant_id);
}

function agenda(tenant_id: number, ms: number) {
  const anterior = contadores.get(tenant_id);
  if (anterior) clearTimeout(anterior);

  const timer = setTimeout(() => {
    contadores.delete(tenant_id);
    disparaCarga(tenant_id).catch((error: any) =>
      console.log(`[CARGA][AUTO] falha ao enfileirar tenant=${tenant_id}`, error?.message || error)
    );
  }, ms);

  // Um contador armado não pode segurar o processo no ar sozinho.
  if (typeof timer.unref === "function") timer.unref();

  contadores.set(tenant_id, timer);
}

async function disparaCarga(tenant_id: number) {
  const config = await leConfiguracao(tenant_id);
  // Pode ter sido desligado entre o aviso e o disparo.
  if (!config.ligada) {
    ultimoAviso.delete(tenant_id);
    return;
  }

  // O contador foi armado sem saber a janela deste cliente (avisaAlteracao nao
  // vai ao banco). Agora que ela e conhecida, se ainda faltar tempo desde a
  // ultima gravacao, completa a espera em vez de mandar carga adiantada.
  const desdeUltimoAviso = Date.now() - (ultimoAviso.get(tenant_id) ?? 0);
  if (desdeUltimoAviso < config.janelaMs) {
    agenda(tenant_id, config.janelaMs - desdeUltimoAviso);
    return;
  }

  ultimoAviso.delete(tenant_id);

  const lojas = await lojasDoCliente(tenant_id);
  if (!lojas.length) return;

  const livres: { codigo: string }[] = [];
  let ocupadas = 0;

  lojas.forEach((codigo: string) => {
    const naFila = achaCarga(tenant_id, codigo);

    // Já PENDENTE: o sync ainda nem começou e vai levar tudo o que estiver
    // marcado, inclusive esta alteração. Nada a fazer.
    if (naFila && naFila.status === "PENDENTE") return;

    // EM_ANDAMENTO: o sync está no meio de uma carga que já passou (ou vai
    // passar) pelas etapas com a lista montada ANTES desta alteração.
    // Enfileirar agora não adiantaria — solicitaCarga ignora pedido para loja
    // ocupada. A alteração não se perde (o finalizaCarga preserva a marca de
    // quem chegou depois do começo da carga), mas ela só sairia na próxima vez
    // que alguém gravasse. Por isso tenta de novo daqui a pouco: assim ela sai
    // numa carga própria, sem depender de uma gravação futura.
    if (naFila) {
      ocupadas++;
      return;
    }

    livres.push({ codigo });
  });

  if (livres.length) {
    console.log(
      `[CARGA][AUTO] alteracao detectada, pedindo ALTERADOS para ${livres.length} loja(s) tenant=${tenant_id}`
    );
    // O `true` marca a carga como automatica: e o que autoriza o
    // finalizaCarga a preservar o que foi gravado durante ela.
    solicitaCarga(tenant_id, livres, "ALTERADOS", true);
  }

  if (ocupadas) {
    console.log(
      `[CARGA][AUTO] ${ocupadas} loja(s) recebendo carga agora tenant=${tenant_id}; ` +
        `nova tentativa em ${ESPERA_LOJA_OCUPADA_MS / 1000}s`
    );
    agenda(tenant_id, ESPERA_LOJA_OCUPADA_MS);
  }
}

// Ponto de entrada. Barato e síncrono de propósito: roda no caminho de toda
// gravação e não pode custar uma ida ao banco. Quem vai ao banco é o disparo,
// já fora da requisição.
export function avisaAlteracao(tenant_id: any) {
  const id = Number(tenant_id);
  if (!id) return;

  ultimoAviso.set(id, Date.now());

  // Reinicia a janela a cada aviso: é o que faz um lote de gravações virar uma
  // carga só. Com o cache frio a janela deste cliente ainda é desconhecida
  // (aqui não se vai ao banco), então arma com a padrão — e o disparo completa
  // a espera se a janela configurada for maior.
  const emCache = cacheConfig.get(id);
  const janelaMs = emCache ? emCache.config.janelaMs : JANELA_PADRAO_SEGUNDOS * 1000;

  agenda(id, janelaMs);
}
