import PermissaoRepository from "./PermissaoRepository";
import { TELA_ACESSO_TOTAL } from "./CatalogoTelas";

// Quem decide se uma requisicao pode abrir uma tela.
//
// A permissao e lida do BANCO, nunca do token. Dentro do token ela ficaria
// congelada pelas 24h de validade: o dono tiraria o acesso de alguem e o
// acesso continuaria valendo ate a pessoa deslogar - que e exatamente o caso em
// que tirar o acesso costuma ser urgente.
//
// Para nao transformar isso em uma consulta por requisicao, o resultado fica em
// cache por 30 segundos. Esse e o atraso maximo entre o dono gravar e o efeito
// valer; quando a gravacao passa por este processo o cache e invalidado na
// hora, entao os 30s so aparecem se o backend rodar em mais de uma instancia.

export interface PermissoesUsuario {
  acessoTotal: boolean;
  telas: Set<string>;
}

const TTL_MS = 30_000;

const cache = new Map<string, { valor: PermissoesUsuario; expiraEm: number }>();

function chave(tenant_id: number, usuario_codigo: string): string {
  return `${tenant_id}:${usuario_codigo}`;
}

export function invalidarCache(tenant_id: number, usuario_codigo: string): void {
  cache.delete(chave(tenant_id, usuario_codigo));
}

export async function carregarPermissoes(
  tenant_id: number,
  usuario_codigo: string
): Promise<PermissoesUsuario> {
  const k = chave(tenant_id, usuario_codigo);
  const emCache = cache.get(k);

  if (emCache && emCache.expiraEm > Date.now()) return emCache.valor;

  const telas = await PermissaoRepository.listarTelas(tenant_id, usuario_codigo);
  const valor: PermissoesUsuario = {
    acessoTotal: telas.includes(TELA_ACESSO_TOTAL),
    telas: new Set(telas),
  };

  cache.set(k, { valor, expiraEm: Date.now() + TTL_MS });
  return valor;
}

// `req` tem que ter passado pelo verifyJWT: e ele quem preenche principal,
// tenant_id e usuario_codigo.
//
// Requisicao sem usuario_codigo e principal (ver auth.middleware.ts) e passa
// direto - isso cobre o dono do inquilino, os tokens de 24h emitidos antes
// desta feature e o token de 30 anos do agente das lojas.
export async function podeAcessar(req: any, tela: string): Promise<boolean> {
  if (req.principal) return true;
  if (!req.usuario_codigo) return true;

  const permissoes = await carregarPermissoes(req.tenant_id, req.usuario_codigo);

  if (permissoes.acessoTotal) return true;
  return permissoes.telas.has(tela);
}

// Lista para o front montar o menu. O '*' nao vai junto: quem tem acesso total
// e informado por `acessoTotal` no GET /me, e o front usa isso como atalho.
export async function telasLiberadas(tenant_id: number, usuario_codigo: string): Promise<string[]> {
  const permissoes = await carregarPermissoes(tenant_id, usuario_codigo);
  return Array.from(permissoes.telas).filter((tela) => tela !== TELA_ACESSO_TOTAL);
}
