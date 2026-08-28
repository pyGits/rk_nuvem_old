import axios from "axios";

// Sugestao de NCM por IA.
//
// Regra central: nada entra no cadastro sem existir na tabela do IBPT. Quem
// chama confere o codigo devolvido contra a tabela e descarta o que nao achar.
//
// A IA responde LIVREMENTE, com os candidatos da busca textual apenas como
// pista. A primeira versao a obrigava a escolher entre os candidatos, e numa
// joalheria o resultado foi "nao soube dizer" em 100% dos produtos: para "ANEL
// DE OURO" a busca textual so acha po de ouro e sulfeto de ouro, porque a linha
// certa (71131900) diz "Artefatos de joalharia" e nao menciona anel nem ouro.
// Presa a esses candidatos, a IA nao tinha como acertar - e acertava ao recusar.
// Solta, ela responde 71131900 de primeira.
//
// A validacao contra a tabela sozinha ja impede codigo inventado, que era o
// motivo da restricao.
//
// O ganho sobre a busca textual esta onde ela falha: marca no comeco da
// descricao (FANDANGOS, YOPRO) e palavra generica (DOCE BRIGADEIRO virava peixe
// ornamental de agua doce). O modelo entende o produto, nao so a palavra.

// Sobrecarga do modelo e indisponibilidade momentanea sao comuns e passam
// sozinhas; nao faz sentido devolver erro ao operador na primeira recusa.
const TENTATIVAS = 3;
const ESPERA_BASE_MS = 4000;
const STATUS_TEMPORARIOS = [429, 500, 502, 503, 504];

function esperar(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const URL_BASE = "https://generativelanguage.googleapis.com/v1beta/models";

export type CandidatoNCM = { codigo: string; descricao: string };
export type PerguntaIA = { descricao: string; candidatos: CandidatoNCM[] };
export type RespostaIA = { descricao: string; ncm: string | null };

export function modeloConfigurado(): string {
  // O Google aposenta nome de modelo com frequencia, e o endpoint de listagem
  // continua mostrando modelo que ja nao aceita chave nova - foi assim com o
  // gemini-2.5-flash. Por isso o .env sobrepoe: trocar o modelo nao pode
  // depender de deploy.
  return (process.env.GEMINI_MODEL || "gemini-3.6-flash").trim();
}

export function iaDisponivel(): boolean {
  return !!process.env.GEMINI_API_KEY;
}

// O axios engole a resposta do Google e devolve so "status code 404". A causa
// real vem no corpo ("models/X is not found for API version v1beta"), e e ela
// que precisa chegar na tela.
async function chamar(url: string, corpo: any, config: any): Promise<any> {
  for (let tentativa = 1; ; tentativa++) {
    try {
      return await axios.post(url, corpo, config);
    } catch (erro: any) {
      const detalhe = erro?.response?.data?.error?.message;
      const status = erro?.response?.status;

      // Espera crescente: 4s, 8s. O modelo sobrecarregado costuma voltar nesse
      // intervalo, e insistir de imediato so piora a fila.
      if (STATUS_TEMPORARIOS.includes(status) && tentativa < TENTATIVAS) {
        await esperar(ESPERA_BASE_MS * tentativa);
        continue;
      }

      return tratarErro(detalhe, status, erro);
    }
  }
}

async function tratarErro(detalhe: string, status: number, erro: any): Promise<never> {

    // A mensagem do Google e mais precisa que qualquer deducao a partir do
    // status: no 404 do gemini-2.5-flash ela dizia "no longer available to new
    // users" e ja indicava o substituto, enquanto o texto que eu montava
    // afirmava que o modelo nao existia - e listava ele mesmo como disponivel.
    if (detalhe) throw new Error(`Gemini (${modeloConfigurado()}): ${detalhe}`);

    if (status === 404) {
      const modelos = await modelosDisponiveis().catch(() => [] as string[]);
      const sugestao = modelos.length ? ` Modelos listados para esta chave: ${modelos.slice(0, 8).join(", ")}.` : "";
      throw new Error(`Falha 404 no modelo "${modeloConfigurado()}". Ajuste GEMINI_MODEL no .env.${sugestao}`);
    }

  throw new Error(erro?.message || "Falha ao consultar a IA.");
}

function montarPrompt(perguntas: PerguntaIA[]): string {
  const itens = perguntas
    .map((pergunta, i) => {
      const opcoes = pergunta.candidatos.map((c) => `    - ${c.codigo}: ${c.descricao}`).join("\n");
      return `${i + 1}. Produto: "${pergunta.descricao}"\n  Sugestoes da busca:\n${opcoes || "    (nenhuma)"}`;
    })
    .join("\n\n");

  return [
    "Voce classifica produtos de varejo brasileiro em codigos NCM.",
    "",
    "Para cada produto abaixo, indique o NCM de 8 digitos mais adequado.",
    "As opcoes listadas vem de uma busca por palavra e podem nao conter a resposta certa:",
    "use uma delas se servir, ou informe outro NCM que voce considere correto.",
    "Responda null so quando nao souber - null e melhor que um codigo no chute.",
    "",
    "Responda SOMENTE um array JSON, sem texto ao redor, no formato:",
    '[{"i": 1, "ncm": "19059090"}, {"i": 2, "ncm": null}]',
    "",
    itens,
  ].join("\n");
}

// O modelo costuma devolver o JSON cercado de ``` ou de texto; pega o array.
function extrairJSON(texto: string): any[] {
  const inicio = texto.indexOf("[");
  const fim = texto.lastIndexOf("]");
  if (inicio < 0 || fim <= inicio) return [];

  try {
    const dados = JSON.parse(texto.substring(inicio, fim + 1));
    return Array.isArray(dados) ? dados : [];
  } catch {
    return [];
  }
}

// Lista os modelos que a chave enxerga. Serve para o painel dizer qual nome
// usar quando o configurado nao existe - "404" sozinho nao ajuda ninguem.
export async function modelosDisponiveis(): Promise<string[]> {
  if (!iaDisponivel()) throw new Error("Configure GEMINI_API_KEY no servidor para usar a busca por IA.");

  const resposta = await axios.get(`${URL_BASE}?key=${process.env.GEMINI_API_KEY}`, { timeout: 30000 });

  return (resposta.data?.models || [])
    .filter((modelo: any) => (modelo.supportedGenerationMethods || []).includes("generateContent"))
    .map((modelo: any) => String(modelo.name || "").replace("models/", ""));
}

export async function escolherNCM(perguntas: PerguntaIA[]): Promise<RespostaIA[]> {
  if (perguntas.length === 0) return [];
  if (!iaDisponivel()) throw new Error("Configure GEMINI_API_KEY no servidor para usar a busca por IA.");

  const resposta = await chamar(
    `${URL_BASE}/${modeloConfigurado()}:generateContent?key=${process.env.GEMINI_API_KEY}`,
    {
      contents: [{ parts: [{ text: montarPrompt(perguntas) }] }],
      // Temperatura zero: classificacao fiscal nao pode variar entre execucoes.
      generationConfig: { temperature: 0, responseMimeType: "application/json" },
    },
    { timeout: 60000 }
  );

  const texto = resposta.data?.candidates?.[0]?.content?.parts?.[0]?.text || "";
  const escolhas = extrairJSON(texto);

  return perguntas.map((pergunta, i) => {
    const escolha = escolhas.find((e: any) => Number(e?.i) === i + 1);
    const ncm = String(escolha?.ncm || "").replace(/[^0-9]/g, "");

    // Aceita qualquer codigo de 8 digitos; quem chama confere na tabela antes
    // de gravar, e e essa conferencia que barra codigo inventado.
    return { descricao: pergunta.descricao, ncm: ncm.length === 8 ? ncm : null };
  });
}
