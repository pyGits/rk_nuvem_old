import fs from "fs";
import path from "path";
import { CATALOGO_TELAS, telaExiste } from "./CatalogoTelas";

// Um id digitado errado numa rota nao quebra nada na hora: a rota simplesmente
// passa a exigir uma tela que nao existe em lugar nenhum. O defeito aparece
// como "o dono marcou o acesso e o usuario continua tomando 403", sem nada no
// log apontando para o erro de digitacao. Este teste pega isso.

const RAIZ_ROTAS = path.resolve(__dirname, "..", "routes");

function arquivosDeRota(diretorio: string): string[] {
  return fs.readdirSync(diretorio, { withFileTypes: true }).flatMap((item) => {
    const completo = path.join(diretorio, item.name);
    if (item.isDirectory()) return arquivosDeRota(completo);
    if (!item.name.endsWith(".ts") || item.name.endsWith(".test.ts")) return [];
    return [completo];
  });
}

function telasUsadas(): { arquivo: string; tela: string }[] {
  const usos: { arquivo: string; tela: string }[] = [];

  for (const arquivo of arquivosDeRota(RAIZ_ROTAS)) {
    const conteudo = fs.readFileSync(arquivo, "utf-8");

    // exigeAcesso("a", "b") nas rotas legadas e o 4o argumento em diante do
    // httpServer.register nas v2/v3.
    const chamadas = conteudo.match(/exigeAcesso\(([^)]*)\)/g) || [];
    const registros = conteudo.match(/\}, ("[^"]+"(?:, "[^"]+")*)\);/g) || [];

    for (const trecho of [...chamadas, ...registros]) {
      const ids = trecho.match(/"([^"]+)"/g) || [];
      ids.forEach((id) => usos.push({ arquivo: path.basename(arquivo), tela: id.replace(/"/g, "") }));
    }
  }

  return usos;
}

describe("catálogo de telas", () => {
  it("não tem id repetido", () => {
    const ids = CATALOGO_TELAS.map((tela) => tela.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it("toda tela exigida por uma rota existe no catálogo", () => {
    const desconhecidas = telasUsadas().filter((uso) => !telaExiste(uso.tela));

    expect(desconhecidas).toEqual([]);
  });

  it("encontrou as anotações das rotas (o teste acima não passou por vazio)", () => {
    expect(telasUsadas().length).toBeGreaterThan(40);
  });
});
