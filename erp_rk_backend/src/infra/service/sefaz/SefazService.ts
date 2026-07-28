import forge from "node-forge";
import { getSpedNfe } from "./SpedNfeLoader";
import NFeSefazRepository, { NFeSefazRepository as NFeSefazRepositoryClass } from "../../repository/NFeSefazRepository";

export type LojaSefaz = {
  codigo?: string;
  cnpjcpf: string;
  certificado: string; // .pfx em base64
  senha: string;
  uf: string;
  ultimo_nsu?: string;
  tenant_id?: number;
};

export type CertificadoInfo = {
  titular: string;
  documento: string; // CNPJ ou CPF do titular
  validade: Date;
  valido: boolean;
};

const NSU_INICIAL = "000000000000000";

/**
 * Serviço de integração com a SEFAZ (Distribuição de DFe), 100% dentro do
 * backend — sem a pasta `nfe` e sem o banco `erp_nfe`. Usa `node-sped-nfe`
 * (carregado dinamicamente por ser ESM) para falar com a SEFAZ e persiste os
 * documentos no banco principal via NFeSefazRepository.
 */
export class SefazService {
  constructor(private readonly repository: NFeSefazRepositoryClass = NFeSefazRepository) {}

  /**
   * Valida o certificado A1 (.pfx) e sua senha usando node-forge (puro JS, não
   * depende do openssl). Extrai titular, documento e validade.
   */
  validarCertificado(pfxBase64: string, senha: string): CertificadoInfo {
    let p12: any;
    try {
      const der = forge.util.decode64(pfxBase64);
      const asn1 = forge.asn1.fromDer(der);
      p12 = forge.pkcs12.pkcs12FromAsn1(asn1, senha);
    } catch (e: any) {
      throw new Error("Certificado ou senha inválidos. Verifique o arquivo .pfx e a senha informada.");
    }

    const certBags = p12.getBags({ bagType: forge.pki.oids.certBag });
    const bag = (certBags[forge.pki.oids.certBag] || [])[0];
    if (!bag || !bag.cert) throw new Error("Não foi possível ler o certificado do arquivo .pfx.");

    const cert = bag.cert;
    const cnField = cert.subject.getField("CN");
    const cn = cnField ? String(cnField.value) : "";
    // e-CNPJ/e-CPF: o CN vem como "RAZAO SOCIAL:DOCUMENTO".
    const [titular, docRaw] = cn.split(":");
    const documento = (docRaw || "").replace(/\D/g, "");
    const validade = cert.validity.notAfter;
    const valido = validade.getTime() > Date.now();

    if (!valido) throw new Error(`Certificado vencido em ${validade.toLocaleDateString("pt-BR")}.`);

    return { titular: (titular || cn).trim(), documento, validade, valido };
  }

  private async criarTools(loja: LojaSefaz) {
    const { Tools } = await getSpedNfe();
    const doc = String(loja.cnpjcpf || "").replace(/\D/g, "");
    const pfxBuffer = Buffer.from(loja.certificado, "base64");

    return new Tools(
      {
        mod: "55",
        tpAmb: Number(process.env.SEFAZ_TP_AMB || 1), // 1=Produção, 2=Homologação
        UF: loja.uf,
        versao: "4.00",
        ...(doc.length === 11 ? { CPF: doc } : { CNPJ: doc }),
        CSC: process.env.SEFAZ_CSC || "",
        CSCid: process.env.SEFAZ_CSC_ID || "",
        xmllint: process.env.XMLLINT_PATH || "/usr/bin/xmllint",
        openssl: process.env.OPENSSL_PATH || null,
        timeout: Number(process.env.SEFAZ_TIMEOUT || 60000),
      },
      { pfx: pfxBuffer, senha: loja.senha }
    );
  }

  private extrairRet(json: any): any {
    return json?.nfeDistDFeInteresseResult?.retDistDFeInt ?? json?.retDistDFeInt ?? json ?? {};
  }

  /**
   * Percorre a Distribuição de DFe a partir do último NSU da loja, gravando as
   * notas de entrada (loja como destinatária) na tabela `nfe`. Retorna o novo
   * último NSU para ser persistido em `lojas`.
   */
  async sincronizarDistribuicao(loja: LojaSefaz): Promise<{ ultimoNsu: string; novos: number }> {
    const { docZip, xml2json } = await getSpedNfe();
    const tools = await this.criarTools(loja);
    const tenant_id = Number(loja.tenant_id);
    const docLoja = String(loja.cnpjcpf || "").replace(/\D/g, "");

    let ultNSU = loja.ultimo_nsu && loja.ultimo_nsu.trim() !== "" ? loja.ultimo_nsu : NSU_INICIAL;
    let novos = 0;

    // A SEFAZ entrega até 50 documentos por consulta; iteramos até esgotar (maxNSU).
    for (let i = 0; i < 50; i++) {
      const retorno = await tools.sefazDistDFe({ ultNSU });
      const ret = this.extrairRet(await xml2json(retorno));
      const cStat = String(ret.cStat || "");

      // 137 = nenhum documento localizado; 656 = consumo indevido (rate limit).
      if (cStat === "137") break;
      if (cStat === "656") throw new Error("SEFAZ: consumo indevido (aguarde antes de consultar novamente).");

      let documentos: Array<{ xml: string; NSU: string; schema: string }> = [];
      try {
        documentos = await docZip(retorno);
      } catch {
        documentos = [];
      }

      for (const doc of documentos) {
        novos += (await this.processarDocumento(doc, tenant_id, docLoja, xml2json)) ? 1 : 0;
      }

      const maxNSU = String(ret.maxNSU || "0");
      const retUltNSU = String(ret.ultNSU || ultNSU);
      ultNSU = retUltNSU;

      // Encerra quando alcançamos o último NSU disponível ou não há mais documentos.
      if (documentos.length === 0 || Number(ultNSU) >= Number(maxNSU)) break;
    }

    return { ultimoNsu: ultNSU, novos };
  }

  private async processarDocumento(doc: { xml: string; NSU: string; schema: string }, tenant_id: number, docLoja: string, xml2json: (xml: string) => Promise<any>): Promise<boolean> {
    const schema = String(doc.schema || "");
    const conteudo = String(doc.xml || "");
    const json = await xml2json(conteudo).catch(() => null);
    if (!json) return false;

    // Nota completa autorizada.
    if (json.nfeProc || schema.startsWith("procNFe")) {
      const infNFe = json.nfeProc?.NFe?.infNFe;
      const chave = json.nfeProc?.protNFe?.infProt?.chNFe || this.chaveDeInfNFe(infNFe);
      const emit = infNFe?.emit || {};
      const dest = infNFe?.dest || {};
      const cnpjcpfDest = String(dest.CNPJ || dest.CPF || "").replace(/\D/g, "");

      // Só interessa quando a loja é a destinatária (nota de entrada).
      if (docLoja && cnpjcpfDest && cnpjcpfDest !== docLoja) return false;

      await this.repository.upsertDocumento({
        tenant_id,
        chave,
        xml: conteudo,
        cnpjcpf: cnpjcpfDest || docLoja,
        cnpjcpf_fornecedor: String(emit.CNPJ || emit.CPF || "").replace(/\D/g, ""),
        nome_fornecedor: emit.xNome || null,
        nsu: doc.NSU,
        resumo: false,
      });
      return true;
    }

    // Apenas o resumo (resNFe): a SEFAZ só envia à parte interessada (destinatária),
    // então já é uma nota de entrada. Falta manifestar para obter o XML completo.
    if (json.resNFe || schema.startsWith("resNFe")) {
      const res = json.resNFe || {};
      const chave = String(res.chNFe || "").replace(/\D/g, "");
      if (!chave) return false;

      await this.repository.upsertDocumento({
        tenant_id,
        chave,
        xml: null,
        cnpjcpf: docLoja,
        cnpjcpf_fornecedor: String(res.CNPJ || res.CPF || "").replace(/\D/g, ""),
        nome_fornecedor: res.xNome || null,
        nsu: doc.NSU,
        resumo: true,
      });
      return true;
    }

    return false;
  }

  private chaveDeInfNFe(infNFe: any): string {
    const id = infNFe?.["@Id"] || infNFe?.Id || infNFe?.$?.Id || "";
    return String(id).replace(/\D/g, "");
  }

  /**
   * Baixa o XML completo de uma nota específica pela chave. Manifesta Ciência da
   * Operação (210210) — sem isso a SEFAZ entrega apenas o resumo — e então baixa
   * o documento completo pela Distribuição de DFe.
   */
  async capturarPorChave(loja: LojaSefaz, chave: string): Promise<{ sucesso: boolean; xml?: string; msg?: string }> {
    const { docZip } = await getSpedNfe();
    const tools = await this.criarTools(loja);
    const tenant_id = Number(loja.tenant_id);
    const docLoja = String(loja.cnpjcpf || "").replace(/\D/g, "");

    // 1) Manifestação de Ciência da Operação. Se já manifestada, a SEFAZ rejeita — seguimos.
    try {
      await tools.sefazEvento({ chNFe: chave, tpEvento: "210210", nSeqEvento: 1 });
    } catch (e: any) {
      // ignora: manifestação prévia ou nota que não exige manifestação.
    }

    // 2) Baixa o documento completo pela chave.
    const retorno = await tools.sefazDistDFe({ chNFe: chave });
    let documentos: Array<{ xml: string; NSU: string; schema: string }> = [];
    try {
      documentos = await docZip(retorno);
    } catch {
      documentos = [];
    }

    let xml: string | null = null;
    for (const doc of documentos) {
      const conteudo = String(doc.xml || "");
      if (conteudo.includes("<nfeProc") || conteudo.includes("<NFe")) {
        xml = conteudo;
        break;
      }
    }

    if (!xml) {
      return {
        sucesso: false,
        msg: "A SEFAZ não retornou o XML completo. Verifique se a loja é a destinatária da nota e se a manifestação foi aceita.",
      };
    }

    await this.repository.upsertDocumento({
      tenant_id,
      chave,
      xml,
      cnpjcpf: docLoja,
      resumo: false,
    });

    return { sucesso: true, xml };
  }
}

export default new SefazService();
