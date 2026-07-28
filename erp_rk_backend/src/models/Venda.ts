import db from "../database/config";
import { DataTypes } from "sequelize";
const Venda = db.define(
  "Venda",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(50), primaryKey: true },
    numero: { type: DataTypes.STRING(12), primaryKey: true },
    data: {
      type: DataTypes.DATEONLY,
      primaryKey: true,
    },
    loja: { type: DataTypes.INTEGER, primaryKey: true },
    hora: { type: DataTypes.TIME, primaryKey: true },
    caixa: { type: DataTypes.STRING(3), primaryKey: true },
    qtde_item: { type: DataTypes.INTEGER },
    valor_desconto: { type: DataTypes.FLOAT(15, 2) },
    valor_acrescimo: { type: DataTypes.FLOAT(15, 2) },
    valor_total: { type: DataTypes.FLOAT(15, 2) },
    valor_custo: { type: DataTypes.FLOAT(15, 2) },
    codigo_cliente: { type: DataTypes.STRING(15) },
    cancelado: { type: DataTypes.INTEGER },
    cpf_consumidor: { type: DataTypes.STRING(18) },
    nome_consumidor: { type: DataTypes.STRING(50) },
    vendedor: { type: DataTypes.STRING(15) },
    xml_venda: { type: DataTypes.STRING(50) },
    xml_cancelamento: { type: DataTypes.STRING(50) },
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
        fields: ["tenant_id", "codigo", "numero", "data", "caixa"],
      },
    ],
  }
);

export default Venda;
