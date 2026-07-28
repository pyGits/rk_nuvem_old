import db from "../database/config";
import { DataTypes } from "sequelize";
const EstoqueMovimentacao = db.define(
  "EstoqueMovimentacao",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    loja: { type: DataTypes.INTEGER, primaryKey: true },
    codigo_produto: { type: DataTypes.STRING(6), primaryKey: true },
    caixa: { type: DataTypes.STRING(3) },

    qtde: { type: DataTypes.FLOAT(15, 2), primaryKey: true },
    data: { type: DataTypes.DATEONLY },
    hora: { type: DataTypes.TIME },
    codigo_cupom: { type: DataTypes.STRING(50) },
    item: { type: DataTypes.INTEGER },
    codigo_funcionario: { type: DataTypes.STRING(6) },
    origem: { type: DataTypes.STRING(50) },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
  },
  {
    defaultScope: {
      attributes: {
        exclude: ["tenant_id"],
      },
    },
  }
);

export default EstoqueMovimentacao;
