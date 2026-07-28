import db from "../database/config";
import { DATE, DataTypes } from "sequelize";
const Estoque = db.define(
  "Estoque",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo_produto: { type: DataTypes.STRING(14), primaryKey: true },
    loja: { type: DataTypes.INTEGER, primaryKey: true },
    estoque: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    estoque_minimo: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    estoque_maximo: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    ultima_saida: { type: DATE },
    ultima_entrada: { type: DATE },
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

export default Estoque;
