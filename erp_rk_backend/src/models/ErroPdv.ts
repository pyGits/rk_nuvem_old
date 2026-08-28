import db from "../database/config";
import { DataTypes } from "sequelize";

// Erro ocorrido em um PDV, subido pelo Sync_NUVEM.
const ErroPdv = db.define(
  "ErroPdv",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    tenant_id: { type: DataTypes.INTEGER, allowNull: false },
    loja: { type: DataTypes.INTEGER, defaultValue: 0 },
    caixa: { type: DataTypes.INTEGER, defaultValue: 0 },
    operador: { type: DataTypes.INTEGER, defaultValue: 0 },
    // Id da linha na tabela ERROS do PDV de origem.
    codigo: { type: DataTypes.INTEGER, defaultValue: 0 },
    data: { type: DataTypes.DATEONLY },
    hora: { type: DataTypes.STRING(8) },
    erro: { type: DataTypes.TEXT, defaultValue: "" },
    origem: { type: DataTypes.STRING(60), defaultValue: "" },
  },
  {
    tableName: "erro_pdv",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default ErroPdv;
