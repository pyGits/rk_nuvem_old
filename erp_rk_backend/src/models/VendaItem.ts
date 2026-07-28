import db from "../database/config";
import { DataTypes } from "sequelize";

const VendaItem = db.define(
  "VendaItem",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(50), primaryKey: true },
    data: { type: DataTypes.DATEONLY, primaryKey: true },
    caixa: { type: DataTypes.STRING(3), primaryKey: true },
    codigo_cupom: { type: DataTypes.STRING(50), primaryKey: true },
    loja: { type: DataTypes.INTEGER, primaryKey: true },

    codigo_produto: { type: DataTypes.STRING(14) },
    item: { type: DataTypes.INTEGER },
    unidade: { type: DataTypes.STRING(3) },
    qtde: { type: DataTypes.FLOAT(15, 2) },
    valor_unitario: { type: DataTypes.FLOAT(15, 2) },
    valor_desconto: { type: DataTypes.FLOAT(15, 2) },
    valor_acrescimo: { type: DataTypes.FLOAT(15, 2) },
    valor_total: { type: DataTypes.FLOAT(15, 2) },
    cancelado: { type: DataTypes.INTEGER },
    valor_custo: { type: DataTypes.FLOAT(15, 2) },
    valor_custo_total: { type: DataTypes.FLOAT(15, 2) },

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

export default VendaItem;
