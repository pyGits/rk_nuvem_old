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
    // cargo e comissao nunca podem ficar nulos: a carga do PDV converte os dois
    // para numero e quebra com null. "0" = Operador, o mesmo default do cadastro.
    comissao: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    cargo: { type: DataTypes.STRING(2), defaultValue: "0" },
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
