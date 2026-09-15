import db from "../database/config";
import { DataTypes } from "sequelize";

// Uma linha por cliente (tenant). Ver migrations/20260915000000_create_configuracoes.ts
// para o porquê de não ser coluna em `tenants`.
const Configuracao = db.define(
  "Configuracao",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    tenant_id: { type: DataTypes.INTEGER, unique: true },
    carga_automatica: { type: DataTypes.BOOLEAN, defaultValue: false },
    carga_automatica_segundos: { type: DataTypes.INTEGER, defaultValue: 60 },
  },
  {
    // Sem isto o Sequelize pluralizaria "Configuracao" como "configuracaos".
    tableName: "configuracoes",
  }
);

export default Configuracao;
