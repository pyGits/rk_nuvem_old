import db from "../database/config";
import { DataTypes } from "sequelize";
const ImpFederais = db.define(
  "ImpFederais",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(3), primaryKey: true },
    nome: { type: DataTypes.STRING(50) },
    cstEntrada: { type: DataTypes.STRING(3) },
    cstSaida: { type: DataTypes.STRING(3) },
    pis: { type: DataTypes.FLOAT(15, 2) },
    cofins: { type: DataTypes.FLOAT(15, 2) },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
  },
  {
    defaultScope: {
      attributes: {
        exclude: ["tenant_id"],
      },
    },
    indexes: [
      {
        unique: true,
        fields: ["tenant_id", "codigo"],
      },
    ],
  }
);

export default ImpFederais;
