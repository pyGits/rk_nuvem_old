import cidades from "./Cidades.json";

export default class Cidade {
  private static cidades = cidades.data;

  static getCidadesPorUF(uf: string): string[] {
    return this.cidades.filter((cidade) => cidade.Uf === uf).map((cidade) => cidade.Nome);
  }
  static getCidadePorCodigoIbge(codigo: number): any {
    const cidade = this.cidades.find((cidade) => cidade.Codigo === codigo);
    return cidade ? { cidade: cidade.Nome, uf: cidade.Uf } : {};
  }

  static getUFS(): string[] {
    // Obtem todas as UFs únicas a partir dos dados
    const ufsSet = new Set(this.cidades.map((cidade) => cidade.Uf));
    return Array.from(ufsSet).sort();
  }
}
