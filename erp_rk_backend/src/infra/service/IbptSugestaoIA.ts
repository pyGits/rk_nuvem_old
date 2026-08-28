import axios from "axios";

// Sugestao de NCM por IA.
//
// Regra central: a IA NAO inventa codigo. Ela recebe os candidatos que saíram
// da propria tabela do IBPT e so escolhe entre eles. Quem chama ainda confere a
// resposta contra a tabela antes de gravar - codigo que nao existe vira "sem
// sugestao", nunca um NCM inventado no cadastro fiscal do cliente.
//
// O ganho sobre a busca textual esta onde ela falha: marca no comeco da
// descricao (FANDANGOS, YOPRO) e palavra generica (DOCE BRIGADEIRO virava peixe
// ornamental de agua doce). O modelo entende o produto, nao so a palavra.

const URL_BASE = "https://generativelanguage.googleapis.com/v1beta/models";

export type CandidatoNCM = { codigo: string; descricao: string };
export type PerguntaIA = { descricao: string; candidatos: CandidatoNCM[] };
export type RespostaIA = { descricao: string; ncm: string | null };

export function modeloConfigurado(): string {
  return process.env.GEMINI_MODEL || "gemini-2.0-flash";
}

export function iaDisponivel(): boolean {
  return !!process.env.GEMINI_API_KEY;
}

function montarPrompt(perguntas: PerguntaIA[]): string {
  const itens = perguntas
    .map((pergunta, i) => {
      const opcoes = pergunta.candidatos.map((c) => `    - ${c.codigo}: ${c.descricao}`).join("\n");
      return `${i + 1}. Produto: "${pergunta.descricao}"\n  Opcoes:\n${opcoes || "    (nenhuma)"}`;
    })
    .join("\n\n");

  return [
    "Voce classifica produtos de supermercado brasileiro em codigos NCM.",
    "",
    "Para cada produto abaixo, escolha o NCM mais adequado ENTRE AS OPCOES listadas.",
    "Se nenhuma opcao servir, responda null - nao invente codigo e nao use codigo fora das opcoes.",
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

export async function escolherNCM(perguntas: PerguntaIA[]): Promise<RespostaIA[]> {
  if (perguntas.length === 0) return [];
  if (!iaDisponivel()) throw new Error("Configure GEMINI_API_KEY no servidor para usar a busca por IA.");

  const resposta = await axios.post(
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

    // So aceita o que estava entre as opcoes: fecha a porta para o modelo
    // devolver um codigo parecido mas inexistente.
    const valido = pergunta.candidatos.some((c) => c.codigo === ncm);

    return { descricao: pergunta.descricao, ncm: valido ? ncm : null };
  });
}
