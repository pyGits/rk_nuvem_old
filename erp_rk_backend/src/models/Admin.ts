import db from "../database/config";
import { DataTypes } from "sequelize";
import { md5WithSalt } from "../utils/utils";

const Admin = db.define(
  "Admin",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    user: {
      type: DataTypes.STRING(20),
      unique: true,
      allowNull: false,
      validate: {
        notEmpty: true,
      },
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false,
      validate: {
        notEmpty: true,
      },
    },
  },
  {
    defaultScope: {
      attributes: {
        exclude: ["password"],
      },
    },
  }
);

Admin.beforeCreate(async (admin: any) => {
  const hashedPassword = md5WithSalt(admin.password);
  admin.password = hashedPassword;
});

export default Admin;
