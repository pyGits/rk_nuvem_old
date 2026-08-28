import { Pool, PoolClient, QueryResult } from "pg";

type DBConfig = {
  user: string;
  host: string;
  database: string;
  password: string;
  port: number;
};

// O que um repositório precisa para falar com o banco. Existe para que o mesmo
// repositório sirva solto (uma conexão por consulta, como sempre foi) ou dentro
// de uma transação, sem duplicar código.
export interface Queryable {
  query(text: string, params?: any[]): Promise<any>;
  queryFirst(text: string, params?: any[]): Promise<any>;
  queryAll(text: string, params?: any[]): Promise<any[]>;
}

// O formato de retorno do query() é histórico e todos os repositórios dependem
// dele: nada -> null, uma linha -> o objeto, várias -> o array. Fica isolado
// aqui porque o caminho transacional precisa devolver exatamente o mesmo - um
// result cru do pg vazando para dentro de uma transação quebraria em silêncio
// todo repositório chamado lá dentro.
function moldarResultado(result: QueryResult): any {
  if (result.rowCount === 0) return null;
  if (result.rowCount === 1) return result.rows[0];
  return result.rows;
}

// Envolve um PoolClient já dentro de BEGIN. Não abre nem fecha nada: quem
// controla o ciclo de vida é o transaction() abaixo.
class TransacaoQueryable implements Queryable {
  constructor(private client: PoolClient) {}

  async query(text: string, params?: any[]): Promise<any> {
    return moldarResultado(await this.client.query(text, params));
  }
  async queryFirst(text: string, params?: any[]): Promise<any> {
    const result = await this.client.query(text, params);
    return result.rows[0];
  }
  async queryAll(text: string, params?: any[]): Promise<any[]> {
    const result = await this.client.query(text, params);
    return result.rows;
  }
}

class DatabaseConnection implements Queryable {
  private pool: Pool;

  constructor() {
    const config: DBConfig = {
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: 5432,
    };

    this.pool = new Pool(config);
  }

  public async query(text: string, params?: any[]): Promise<any> {
    const client = await this.pool.connect();
    try {
      return moldarResultado(await client.query(text, params));
    } finally {
      client.release();
    }
  }
  public async queryFirst(text: string, params?: any[]): Promise<any> {
    const client = await this.pool.connect();
    try {
      const result = await client.query(text, params);
      return result.rows[0]; // Retorna o primeiro registro ou undefined caso não haja resultados
    } finally {
      client.release();
    }
  }
  public async queryAll(text: string, params?: any[]): Promise<any[]> {
    const client = await this.pool.connect();
    try {
      const result = await client.query(text, params);
      return result.rows; // sempre será um array
    } finally {
      client.release();
    }
  }

  // Roda tudo o que estiver dentro de fn no mesmo client, entre BEGIN e COMMIT.
  //
  // Existe porque operações como o recebimento gravam em duas tabelas: sem isso
  // uma falha no meio deixava o recebimento gravado e o título ainda marcado
  // como ABERTO - dinheiro recebido que não aparece como recebido.
  //
  // Segura um client do pool durante toda a fn: use só onde há mais de uma
  // escrita, nunca em rota de alta frequência (o Pool tem max 10).
  public async transaction<T>(fn: (tx: Queryable) => Promise<T>): Promise<T> {
    const client = await this.pool.connect();
    try {
      await client.query("BEGIN");
      const retorno = await fn(new TransacaoQueryable(client));
      await client.query("COMMIT");
      return retorno;
    } catch (erro) {
      await client.query("ROLLBACK");
      throw erro;
    } finally {
      client.release();
    }
  }

  public async close(): Promise<void> {
    await this.pool.end();
  }
}

export default new DatabaseConnection();
