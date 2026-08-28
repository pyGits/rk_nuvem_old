import db from "../database/config";
import { DataTypes } from "sequelize";

// Cache das consultas ao Cadastro Centralizado de GTIN da SEFAZ, com o codigo
// de barras como chave: o mesmo GTIN vale para todos os clientes.
const GtinSefaz = db.define(
  "GtinSefaz",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    gtin: { type: DataTypes.STRING(14), allowNull: false },
    // null = consultado e a SEFAZ nao tem NCM para este GTIN.
    ncm: { type: DataTypes.STRING(8) },
    cest: { type: DataTypes.STRING(7) },
    xprod: { type: DataTypes.TEXT },
    cstat: { type: DataTypes.STRING(4), defaultValue: "" },
    xmotivo: { type: DataTypes.TEXT },
  },
  {
    tableName: "gtin_sefaz",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default GtinSefaz;
