import db from "../database/config";
import { DataTypes } from "sequelize";

const Finalizadora = db.define(
  "Finalizadora",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: {
      type: DataTypes.STRING(3),
      primaryKey: true,
      allowNull: false,
    },
    nome: { type: DataTypes.STRING(50) },
    especie: { type: DataTypes.STRING(2) },
    tipo: { type: DataTypes.STRING(1) },
    utiliza99: { type: DataTypes.STRING(1) },
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

export default Finalizadora;
