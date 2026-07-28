import db from "../database/config";
import Pessoa from "./abstract/Pessoa";
import Endereco from "./abstract/Endereco";
import { DataTypes } from "sequelize";
import NaoFiscal from "./NaoFiscal";
const Funcionario = db.define(
  "Funcionario",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: {
      type: DataTypes.STRING(15),
      defaultValue: "",
      primaryKey: true,
    },
    ...Pessoa,
    ...Endereco,
    comissao: { type: DataTypes.FLOAT(15, 2) },
    cargo: { type: DataTypes.STRING(2) },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: { notEmpty: true },
    },
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
        fields: ["tenant_id", "codigo"],
      },
      {
        unique: true,
        fields: ["tenant_id", "cnpjcpf"],
      },
    ],
  }
);

export default Funcionario;
