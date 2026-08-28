import Connection from "../repository/Connection";

// O NCM vinha de um JSON de 4 MB embutido no bundle, atualizado só com deploy
// novo. Agora vem da tabela do IBPT que o administrador sobe pelo painel.
//
// O formato de saída (Codigo/Descricao) é o mesmo do JSON antigo de propósito:
// as telas que consomem continuam funcionando sem alteração.
type ItemNCM = {
  Codigo: string;
  Descricao: string;
  // Alíquotas da Lei da Transparência, que o JSON antigo não tinha.
  NacionalFederal: number;
  ImportadoFederal: number;
  Estadual: number;
  Municipal: number;
};

function converter(registro: any): ItemNCM {
  return {
    Codigo: registro.codigo,
    Descricao: registro.descricao,
    NacionalFederal: Number(registro.nacionalFederal || 0),
    ImportadoFederal: Number(registro.importadoFederal || 0),
    Estadual: Number(registro.estadual || 0),
    Municipal: Number(registro.municipal || 0),
  };
}

export default class NCM {
  // Busca no servidor: são 12 mil NCM, não faz sentido trazer todos para
  // filtrar no navegador. Abaixo de 2 caracteres não consulta — devolveria
  // praticamente a tabela inteira.
  static async filter(search: string): Promise<ItemNCM[]> {
    const termo = String(search || "").trim();
    if (termo.length < 2) return [];

    const res = await Connection.get("/ibpt/ncm", { params: { q: termo } });
    return (res.data || []).map(converter);
  }

  static async findByNCM(ncm: string): Promise<ItemNCM | null> {
    const codigo = String(ncm || "").replace(/\D/g, "");
    if (!codigo) return null;

    const res = await Connection.get(`/ibpt/ncm/${codigo}`);
    return res.data ? converter(res.data) : null;
  }
}
