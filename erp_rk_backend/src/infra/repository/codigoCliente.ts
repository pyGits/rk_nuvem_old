// Casamento do código de cliente entre `clientes` e `conta_receber`.
//
// O MESMO CLIENTE APARECE COM CÓDIGOS ESCRITOS DE FORMA DIFERENTE nas duas
// tabelas. Cliente cadastrado pela web recebe o código sem zeros à esquerda
// ("1", "2", "13" — ver menorCodigoLivre em UtilsController), enquanto o
// `cliente_codigo` gravado em conta_receber vem do PDV e chega preenchido
// ("000001"). Como as duas colunas são varchar, "1" e "000001" são valores
// diferentes para o banco.
//
// O estrago disso aparecia em dois lugares, e os dois pareciam defeitos
// separados:
//   - o nome do cliente vinha vazio na grade (o join com `clientes` não casava);
//   - filtrar por cliente não trazia nada, mas SÓ quando o código vinha da
//     busca de clientes; clicando na linha da posição consolidada funcionava,
//     porque ali o código sai do próprio conta_receber.
//
// A comparação passa a ser pelo código NORMALIZADO: sem espaços e sem os zeros
// à esquerda. Código não numérico (que existe em base migrada) continua
// comparado como texto, só sem espaços nas pontas.

// Normaliza um código para comparação. Usada para casar em memória o que veio
// de consultas separadas.
export function chaveCodigoCliente(codigo: any): string {
  const texto = String(codigo ?? "").trim();
  if (!/^[0-9]+$/.test(texto)) return texto.toUpperCase();

  // "000001" -> "1"; "0" e "000" -> "0" (nunca vazio, senao dois codigos
  // invalidos diferentes casariam entre si).
  const semZeros = texto.replace(/^0+/, "");
  return semZeros === "" ? "0" : semZeros;
}

// Todas as formas em que um código pode estar gravado, para usar com
// `coluna = ANY($n)`.
//
// Por que variantes em vez de normalizar a COLUNA no WHERE: normalizar a
// coluna descarta o índice (conta_receber_tenant_cliente_index) e faz a grade
// varrer o crediário inteiro. Comparar contra uma lista curta de valores
// literais continua usando o índice.
const LARGURA_MAXIMA = 15; // varchar(15) nas duas tabelas

export function variantesDeCodigoCliente(codigo: any): string[] {
  const texto = String(codigo ?? "").trim();
  if (texto === "") return [];

  // Nao numerico nao tem padding para desfazer.
  if (!/^[0-9]+$/.test(texto)) return [texto];

  const chave = chaveCodigoCliente(texto);
  const variantes = new Set<string>([texto, chave]);

  // "1" -> "01", "001", ... ate a largura da coluna. Cobre tanto o filtro vindo
  // sem zeros contra um titulo gravado com zeros quanto o contrario.
  for (let largura = chave.length + 1; largura <= LARGURA_MAXIMA; largura++) {
    variantes.add(chave.padStart(largura, "0"));
  }

  return Array.from(variantes);
}

// Mesma normalização da chaveCodigoCliente, em SQL, para os JOINs com
// `clientes` — ali não dá para resolver em memória porque a consulta agrupa e
// filtra por nome.
export function sqlCodigoClienteNormalizado(coluna: string): string {
  return `(case when btrim(${coluna}) ~ '^[0-9]+$'
                then coalesce(nullif(regexp_replace(btrim(${coluna}), '^0+', ''), ''), '0')
                else upper(btrim(${coluna})) end)`;
}
