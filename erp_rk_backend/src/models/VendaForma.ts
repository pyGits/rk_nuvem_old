import db from "../database/config";
import { DataTypes } from "sequelize";
const VendaForma = db.define(
  "VendaForma",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(50), primaryKey: true },
    data: { type: DataTypes.DATEONLY, primaryKey: true },
    caixa: { type: DataTypes.STRING(3), primaryKey: true },
    codigo_cupom: { type: DataTypes.STRING(50), primaryKey: true },
    loja: { type: DataTypes.INTEGER, primaryKey: true },

    prestacao: { type: DataTypes.INTEGER },
    valor: { type: DataTypes.FLOAT(15, 2) },
    finalizadora: { type: DataTypes.STRING(3) },
    tipo: { type: DataTypes.INTEGER },
    valor_troco: { type: DataTypes.FLOAT(15, 2) },
    cancelado: { type: DataTypes.INTEGER },

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
        fields: ["tenant_id", "codigo", "data", "caixa"],
      },
    ],
  }
);

export default VendaForma;
