import db from "../database/config";
import Pessoa from "./abstract/Pessoa";
import Endereco from "./abstract/Endereco";
import { DataTypes } from "sequelize";
const Fornecedor = db.define(
  "Fornecedor",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: {
      type: DataTypes.STRING(15),
      defaultValue: "",
      primaryKey: true,
    },
    observacao: {
      type: DataTypes.STRING(80),
      defaultValue: "",
    },
    transportadora: {
      type: DataTypes.STRING(2),
      defaultValue: "",
    },
    im: {
      type: DataTypes.STRING(10),
      defaultValue: "",
    },
    ...Pessoa,
    ...Endereco,
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
      {
        unique: true,
        fields: ["tenant_id", "cnpjcpf"],
      },
    ],
  }
);

export default Fornecedor;
