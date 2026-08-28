import https from "https";
import axios from "axios";
import { parseStringPromise } from "xml2js";
import { stripPrefix } from "xml2js/lib/processors";
import db from "../../../database/config";
import { QueryTypes } from "sequelize";

// Consulta GTIN no Cadastro Centralizado (CCG) da SEFAZ - NT 2022.001.
//
// Por que isto existe: perguntar o NCM pela DESCRICAO e adivinhacao, mesmo com
// IA. O codigo de barras identifica o produto de forma exata, e o CCG devolve o
// NCM que o proprio dono da marca registrou. E consulta, nao palpite.
//
// Limites do servico, que definem a cobertura real:
//  - so GTIN da GS1 Brasil (prefixo 789/790). Importado nao responde.
//  - se o dono da marca nao autorizou a publicacao, o GTIN nao volta mesmo
//    existindo no cadastro.
//  - exige TLS 1.2 com autenticacao MUTUA: certificado A1 (.pfx) de emitente de
//    NF-e/NFC-e. Usamos o certificado ja cadastrado em `lojas`.

const URL_CCG = process.env.SEFAZ_GTIN_URL || "https://dfe-servico.svrs.rs.gov.br/ws/ccgConsGTIN/ccgConsGTIN.asmx";

// Namespace do wsdl. Sobreponivel por .env pelo mesmo motivo do GEMINI_MODEL:
// se a SEFAZ publicar outro, corrigir nao pode depender de deploy. O WSDL nao e
// baixavel sem certificado (responde 403), entao este valor segue o padrao dos
// demais servicos da NF-e e deve ser confirmado no primeiro uso real.
const NS_WSDL = process.env.SEFAZ_GTIN_NS || "http://www.portalfiscal.inf.br/nfe/wsdl/CCGConsGTIN";
const NS_NFE = "http://www.portalfiscal.inf.br/nfe";

const CSTAT_SUCESSO = "9490";
// 656 = consumo indevido: a SEFAZ bloqueia o CNPJ por cerca de uma hora. Nao e
// falha passageira - insistir prolonga o bloqueio.
const CSTAT_CONSUMO_INDEVIDO = "656";

export type RespostaGTIN = {
  gtin: string;
  cStat: string;
  xMotivo: string;
  ncm: string | null;
  cest: string | null;
  xProd: string | null;
  bloqueado: boolean;
};

export type CertificadoLoja = {
  codigo: string;
  tenant_id: number;
  cnpjcpf: string;
  uf: string;
  certificado: string;
  senha: string;
};

// Aceita GTIN-8/12/13/14 e recusa o resto. Codigo interno de loja (prefixo 2)
// nao existe fora dela, entao consultar seria gasto certo sem resposta.
export function gtinConsultavel(valor: string): boolean {
  const digitos = String(valor || "").replace(/[^0-9]/g, "");
  if (![8, 12, 13, 14].includes(digitos.length)) return false;

  const treze = digitos.padStart(13, "0");
  return treze.startsWith("789") || treze.startsWith("790");
}

// Qualquer certificado valido serve para consultar qualquer GTIN - o servico
// autentica quem pergunta, nao restringe sobre o que se pergunta. Pega o de
// validade mais longa para nao trocar de certificado no meio do mutirao.
export async function certificadoDisponivel(): Promise<CertificadoLoja | null> {
  const linhas: any[] = await db.query(
    `select codigo, tenant_id, cnpjcpf, uf, certificado, senha
       from lojas
      where coalesce(certificado, '') <> ''
        and coalesce(senha, '') <> ''
        and (certificado_validade is null or certificado_validade > now())
      order by certificado_validade desc nulls last
      limit 1`,
    { type: QueryTypes.SELECT }
  );

  return linhas.length > 0 ? (linhas[0] as CertificadoLoja) : null;
}

function envelope(gtin: string): string {
  return (
    '<?xml version="1.0" encoding="utf-8"?>' +
    '<soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">' +
    "<soap12:Body>" +
    `<nfeDadosMsg xmlns="${NS_WSDL}">` +
    `<consGTIN xmlns="${NS_NFE}" versao="1.00"><GTIN>${gtin}</GTIN></consGTIN>` +
    "</nfeDadosMsg>" +
    "</soap12:Body>" +
    "</soap12:Envelope>"
  );
}

// A resposta vem embrulhada em Envelope/Body/...Result. Em vez de adivinhar a
// profundidade, procura o retConsGTIN em qualquer nivel - o prefixo de
// namespace ja foi removido no parse.
function acharRetorno(no: any): any {
  if (!no || typeof no !== "object") return null;
  if (no.retConsGTIN) return no.retConsGTIN;

  for (const chave of Object.keys(no)) {
    const achado = acharRetorno(no[chave]);
    if (achado) return achado;
  }

  return null;
}

function texto(valor: any): string {
  if (valor === null || valor === undefined) return "";
  if (typeof valor === "object") return String(valor._ ?? "");
  return String(valor);
}

export async function consultarGTIN(gtin: string, loja: CertificadoLoja): Promise<RespostaGTIN> {
  const agent = new https.Agent({
    pfx: Buffer.from(loja.certificado, "base64"),
    passphrase: loja.senha,
    // A cadeia da ICP-Brasil nem sempre esta no truststore do container, e o
    // servidor e endereco fixo e conhecido. Mesma postura do resto da
    // integracao SEFAZ ja em producao.
    rejectUnauthorized: false,
    minVersion: "TLSv1.2",
  });

  const resposta = await axios.post(URL_CCG, envelope(gtin), {
    httpsAgent: agent,
    headers: { "Content-Type": "application/soap+xml; charset=utf-8" },
    timeout: Number(process.env.SEFAZ_TIMEOUT || 60000),
  });

  const json = await parseStringPromise(resposta.data, {
    explicitArray: false,
    tagNameProcessors: [stripPrefix],
  });

  const ret = acharRetorno(json);
  if (!ret) throw new Error("Resposta da SEFAZ sem retConsGTIN. Verifique SEFAZ_GTIN_NS no .env.");

  const cStat = texto(ret.cStat).trim();
  const ncm = texto(ret.NCM).replace(/[^0-9]/g, "");
  // CEST pode vir repetido (ate 3); guardamos o primeiro so como referencia.
  const cest = (Array.isArray(ret.CEST) ? texto(ret.CEST[0]) : texto(ret.CEST)).replace(/[^0-9]/g, "");

  return {
    gtin,
    cStat,
    xMotivo: texto(ret.xMotivo).trim(),
    ncm: cStat === CSTAT_SUCESSO && ncm.length === 8 ? ncm : null,
    cest: cest.length > 0 ? cest.substring(0, 7) : null,
    xProd: texto(ret.xProd).trim() || null,
    bloqueado: cStat === CSTAT_CONSUMO_INDEVIDO,
  };
}
