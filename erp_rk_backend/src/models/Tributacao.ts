import db from "../database/config";
import { DataTypes } from "sequelize";
const Tributacao = db.define(
  "Tributacao",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(3), primaryKey: true },
    nome: { type: DataTypes.STRING(80) },
    cst: { type: DataTypes.STRING(3) },
    cfop: { type: DataTypes.STRING(4) },
    csosn: { type: DataTypes.STRING(3) },
    icms: { type: DataTypes.FLOAT(15, 2) },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
    carga_pendente: { type: DataTypes.BOOLEAN },
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

export default Tributacao;
