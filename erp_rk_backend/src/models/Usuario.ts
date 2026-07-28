import db from "../database/config";
import { DataTypes } from "sequelize";
import Pessoa from "./abstract/Pessoa";
import Endereco from "./abstract/Endereco";
import { md5WithSalt } from "../utils/utils";
const Usuario = db.define("Usuario", {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  codigo: {
    unique: true,
    type: DataTypes.STRING(3),
    defaultValue: "",
    primaryKey: true,
  },
  user: {
    type: DataTypes.STRING(20),
    unique: true,
    primaryKey: true,
    allowNull: false,
    validate: { notEmpty: true },
  },
  password: {
    type: DataTypes.STRING(255),
    allowNull: false,
    validate: { notEmpty: true },
  },
  ativo: { type: DataTypes.STRING(1) },
  ...Pessoa,
  ...Endereco,
  tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
});

Usuario.beforeSave((user: any, options: any) => {
  const hashedPassword = md5WithSalt(user.password); // criptografa a senha com o salt
  user.dataValues.password = hashedPassword; // atribui a senha criptografada ao campo 'password'
  return user;
});
export default Usuario;
