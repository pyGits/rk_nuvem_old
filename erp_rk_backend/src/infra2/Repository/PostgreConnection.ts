import knex, { Knex } from "knex";
import dotenv from "dotenv";

dotenv.config();

export default class PostgreConnection {
  private static instance: Knex;

  static getConnection(): Knex {
    if (!PostgreConnection.instance) {
      PostgreConnection.instance = knex({
        client: "pg",
        connection: {
          host: process.env.DB_HOST || "localhost",
          port: Number(process.env.DB_PORT) || 5432,
          user: process.env.DB_USER || "postgres",
          password: process.env.DB_PASSWORD || "masterkey",
          database: process.env.DB_NAME || "erp",
        },
        pool: {
          min: 2,
          max: 10,
        },
        migrations: {
          tableName: "knex_migrations",
        },
        // debug: process.env.NODE_ENV === "development",
      });
    }

    return PostgreConnection.instance;
  }

  static async destroy(): Promise<void> {
    if (PostgreConnection.instance) {
      await PostgreConnection.instance.destroy();
      // @ts-ignore
      PostgreConnection.instance = null;
    }
  }
}
