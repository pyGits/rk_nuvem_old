import "./src/database/loadEnv";
import type { Knex } from "knex";

// Configuração do knex apontando SEMPRE para o banco principal (erp).
// Usado apenas para rodar as migrations:  npx knex migrate:latest
const config: { [key: string]: Knex.Config } = {
  development: {
    client: "pg",
    connection: {
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: Number(process.env.DB_PORT || 5432),
    },
    pool: { min: 2, max: 10 },
    migrations: {
      directory: "./migrations",
      extension: "ts",
      tableName: "knex_migrations",
    },
  },
};

config.homolog = config.development;
config.production = config.development;

export default config;
