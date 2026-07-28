import dotenv from "dotenv";
import path from "path";

const env = process.env.NODE_ENV || "development";

const envFile = {
  development: ".env",
  homolog: ".env.homolog",
  production: ".env.production",
}[env];

dotenv.config({
  path: path.resolve(__dirname, "..", "..", envFile),
});

console.log(`🌎 Ambiente: ${env}`);
