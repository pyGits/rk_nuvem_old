import db from "../database/config";
import Pessoa from "./abstract/Pessoa";
import Endereco from "./abstract/Endereco";
import { DataTypes } from "sequelize";
const Cliente = db.define(
  "Cliente",
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
    limiteCredito: {
      type: DataTypes.FLOAT(15, 2),
    },
    perc_desconto: {
      type: DataTypes.FLOAT(15, 2),
    },
    utiliza_preco2: {
      type: DataTypes.BOOLEAN,
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

export default Cliente;
