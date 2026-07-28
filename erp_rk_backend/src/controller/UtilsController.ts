import { QueryTypes } from "sequelize";
import conn from "../database/config";

export async function getNextSequencial(
  table: string,
  column: string,
  tenant_id: string,
  column2?: string,
  value2?: string
): Promise<string> {
  const optionalCondition = column2 ? `AND ${column2} = '${value2}'` : "";
  console.log(optionalCondition);
  const sequencia = await conn.query(
    `select cast(${column} as float) from ${table} where tenant_id=${tenant_id} ${optionalCondition} order by ${column}`,
    { type: QueryTypes.SELECT }
  );

  const gap = findGapInObjects(sequencia, "codigo");
  return gap;
}

function findGapInObjects(array: any[], key: string): string {
  if (array.length === 0) {
    return "1"; // Retorna 1 quando o array está vazio
  }

  // Ordena o array em ordem crescente pela chave
  array.sort((a, b) => a[key] - b[key]);

  // Inicializa com o valor do primeiro elemento
  let maxVal = array[0][key];

  // Percorre a lista de objetos procurando pela primeira lacuna
  for (let i = 0; i < array.length; i++) {
    const currentVal = array[i][key];
    if (currentVal - maxVal > 1) {
      // Encontrou a primeira lacuna
      return maxVal + 1;
    }
    maxVal = currentVal;
  }

  // Não há lacunas na lista, retorna o próximo número inteiro após o maior valor
  return String(maxVal + 1);
}
