import { Sequelize } from "sequelize";
import pg from "pg";

const connection = new Sequelize({
  dialect: "postgres",
  host: process.env.DB_HOST,
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  define: { timestamps: true, underscored: true },
  logging: false,
});
console.log(process.env.DB_NAME);

export default connection;
