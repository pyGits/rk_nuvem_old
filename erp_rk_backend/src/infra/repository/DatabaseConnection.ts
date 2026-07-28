import { Pool } from "pg";

type DBConfig = {
  user: string;
  host: string;
  database: string;
  password: string;
  port: number;
};

class DatabaseConnection {
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
      const result = await client.query(text, params);

      if (result.rowCount === 0) {
        return null;
      }

      if (result.rowCount === 1) {
        return result.rows[0];
      }

      return result.rows;
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

  public async close(): Promise<void> {
    await this.pool.end();
  }
}

export default new DatabaseConnection();
