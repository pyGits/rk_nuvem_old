import db from "../database/config";
import { DataTypes } from "sequelize";

const ProdutoCodigoBarras = db.define(
  "ProdutoCodigoBarras",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo_produto: { type: DataTypes.STRING(6), allowNull: false },
    codigo_barras: { type: DataTypes.STRING(14), allowNull: false },
    tenant_id: { type: DataTypes.INTEGER, allowNull: false },
  },
  {
    tableName: "produto_codigos_barras",
    defaultScope: {
      attributes: {
        exclude: ["tenant_id"],
      },
    },
    indexes: [
      {
        unique: true,
        fields: ["tenant_id", "codigo_barras"],
      },
      {
        fields: ["tenant_id", "codigo_produto"],
      },
    ],
  }
);

export default ProdutoCodigoBarras;
