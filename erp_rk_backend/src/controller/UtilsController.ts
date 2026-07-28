import { QueryTypes } from "sequelize";
import conn from "../database/config";

/**
 * Menor inteiro positivo que não está na lista.
 * [1,2,3,5] -> 4 ; [2,3] -> 1 ; [] -> 1 ; [1,2,3] -> 4
 */
export function menorCodigoLivre(usados: number[]): string {
  const ocupados = new Set(usados.filter((n) => Number.isInteger(n) && n > 0));
  let candidato = 1;
  while (ocupados.has(candidato)) candidato++;
  return String(candidato);
}

/**
 * Lê os valores já usados de uma coluna numérica.
 * Ignora linhas não numéricas (um EAN alfanumérico quebraria o cast).
 */
async function valoresUsados(table: string, column: string, tenant_id: string, condicaoExtra = ""): Promise<number[]> {
  const linhas: any[] = await conn.query(
    `select cast(${column} as bigint) as valor
       from ${table}
      where tenant_id = ${tenant_id}
        and ${column} ~ '^[0-9]+$'
        ${condicaoExtra}`,
    { type: QueryTypes.SELECT }
  );
  return linhas.map((l) => Number(l.valor));
}

/**
 * Próximo código de uma entidade, preenchendo lacunas em vez de somar 1 ao maior.
 */
export async function getNextSequencial(
  table: string,
  column: string,
  tenant_id: string,
  column2?: string,
  value2?: string
): Promise<string> {
  const optionalCondition = column2 ? `AND ${column2} = '${value2}'` : "";
  const usados = await valoresUsados(table, column, tenant_id, optionalCondition);
  return menorCodigoLivre(usados);
}

/**
 * Próximo código para um produto novo.
 *
 * O número precisa estar livre em três lugares ao mesmo tempo, senão o cadastro
 * seria recusado depois por encontrarConflitoCodigos: o código do produto, o
 * código de barras principal e os códigos de barras auxiliares. Devolver um
 * único número livre nos três mantém codigo e codigo_barras iguais, como o
 * sistema sempre fez.
 */
export async function getNextCodigoProduto(tenant_id: string): Promise<string> {
  const [codigos, barras, auxiliares] = await Promise.all([
    valoresUsados("produtos", "codigo", tenant_id),
    valoresUsados("produtos", "codigo_barras", tenant_id),
    valoresUsados("produto_codigos_barras", "codigo_barras", tenant_id),
  ]);

  return menorCodigoLivre([...codigos, ...barras, ...auxiliares]);
}
