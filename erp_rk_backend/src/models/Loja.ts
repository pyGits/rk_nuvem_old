import db from "../database/config";
import Pessoa from "./abstract/Pessoa";
import Endereco from "./abstract/Endereco";
import { DataTypes } from "sequelize";
// TERMINAR CNPJ
const Loja = db.define(
  "Loja",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(3), primaryKey: true },
    ...Pessoa,
    ...Endereco,
    status: { type: DataTypes.STRING(30) },
    token: { type: DataTypes.STRING, unique: true },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
  },
  {
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

export default Loja;
