import db from "../database/config";
import { DataTypes } from "sequelize";
const Preco = db.define(
  "Preco",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo_produto: { type: DataTypes.STRING(14), primaryKey: true },
    loja: { type: DataTypes.INTEGER, primaryKey: true },
    preco: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    custo: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    oferta: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    markup: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    preco2: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    preco2_qtd: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    carga_pendente: { type: DataTypes.BOOLEAN },
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
        fields: ["tenant_id", "codigo_produto", "loja"],
      },
    ],
  }
);

export default Preco;
