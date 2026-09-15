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
// A SOLICITAÇÃO NÃO SAI NA HORA, de propósito. Salvar 40 produtos seguidos, ou
// importar uma nota fiscal inteira, são dezenas de gravações em poucos
// segundos; uma carga por gravação colocaria o sync para correr atrás do rabo.
// Cada aviso reinicia um contador por cliente e a carga só é enfileirada
// quando ele para de gravar pela janela configurada (padrão 60s).
//
// SE O PROCESSO REINICIAR com o contador armado, aquela carga não sai — o
// timer é de memória, como a própria fila. Nada se perde: `carga_pendente`
// continua true no banco, então a próxima gravação (ou um envio manual) leva
// tudo o que ficou para trás.

// Limites da janela. O mínimo existe para que a janela continue agrupando algo
// — 1 segundo seria uma carga por gravação, que é justamente o que ela evita.
const JANELA_MINIMA_SEGUNDOS = 10;
const JANELA_MAXIMA_SEGUNDOS = 3600;
const JANELA_PADRAO_SEGUNDOS = 60;

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

function normalizaSegundos(valor: any): number {
  const segundos = Number(valor);
  if (!Number.isFinite(segundos) || segundos <= 0) return JANELA_PADRAO_SEGUNDOS;
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
    // usuário já recebeu o "salvo com sucesso"). Fica desligado nesta rodada.
    console.log("[CARGA][AUTO] falha ao ler a configuracao", error?.message || error);
    return { ligada: false, janelaMs: JANELA_PADRAO_SEGUNDOS * 1000 };
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

  const lojas: any[] = await Loja.findAll({ where: { tenant_id }, attributes: ["codigo"] });
  if (!lojas.length) return;

  const livres: { codigo: string }[] = [];
  let ocupadas = 0;

  lojas.forEach((loja: any) => {
    const codigo = String(loja.getDataValue("codigo"));
    const naFila = achaCarga(tenant_id, codigo);

    // Já PENDENTE: o sync ainda nem começou e vai levar tudo o que estiver
    // marcado, inclusive esta alteração. Nada a fazer.
    if (naFila && naFila.status === "PENDENTE") return;

    // EM_ANDAMENTO: o sync está no meio de uma carga montada ANTES desta
    // alteração. Enfileirar agora não adiantaria (solicitaCarga ignora), e
    // pior: o finalizaCarga da carga atual vai limpar `carga_pendente` de
    // todo mundo, inclusive do que acabou de ser alterado. Por isso tenta de
    // novo daqui a pouco, quando a loja estiver livre.
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
    solicitaCarga(tenant_id, livres, "ALTERADOS");
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
