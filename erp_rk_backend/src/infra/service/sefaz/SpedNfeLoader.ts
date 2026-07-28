/**
 * `node-sped-nfe` é um pacote ESM ("type": "module") e este backend é compilado
 * para CommonJS. Um `import()` normal seria rebaixado pelo TypeScript para
 * `require()`, que falha ao carregar um módulo ESM (ERR_REQUIRE_ESM).
 *
 * Para preservar um import dinâmico REAL, usamos o construtor `Function`, que o
 * compilador não reescreve. Assim conseguimos usar a lib sem precisar da pasta
 * `nfe` nem migrar todo o projeto para ESM.
 */
type SpedNfe = {
  Tools: any;
  docZip: (retorno: string) => Promise<Array<{ xml: string; NSU: string; schema: string }>>;
  xml2json: (xml: string) => Promise<any>;
  certInfo: (pfxBase64: string, senha: string) => Promise<any>;
};

const dynamicImport = new Function("specifier", "return import(specifier)") as (specifier: string) => Promise<any>;

let cached: SpedNfe | null = null;

export async function getSpedNfe(): Promise<SpedNfe> {
  if (cached) return cached;
  const mod = await dynamicImport("node-sped-nfe");
  cached = {
    Tools: mod.Tools,
    docZip: mod.docZip,
    xml2json: mod.xml2json,
    certInfo: mod.certInfo,
  };
  return cached;
}
