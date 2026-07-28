import db from "../database/config";
import { DataTypes } from "sequelize";
import Funcionario from "./Funcionario";
import Finalizadora from "./Finalizadora";
import Loja from "./Loja";

const NaoFiscal = db.define(
  "NaoFiscal",
  {
    id: { type: DataTypes.INTEGER, autoIncrement: true },
    loja: { type: DataTypes.STRING(3) },
    caixa: { type: DataTypes.STRING(3), primaryKey: true },
    codigo: { type: DataTypes.STRING, primaryKey: true },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },

    data: { type: DataTypes.DATEONLY },
    indice: { type: DataTypes.STRING },
    Descricao: { type: DataTypes.STRING },
    Valor: { type: DataTypes.FLOAT },
    Hora: { type: DataTypes.TIME },
    Vendedor: { type: DataTypes.STRING(15) },
    fzcod: { type: DataTypes.STRING(3) },
  },
  {
    // Defina aqui as configurações adicionais, se necessário
  }
);

NaoFiscal.belongsTo(Funcionario, {
  foreignKey: "Vendedor",
  targetKey: "codigo",
});
NaoFiscal.belongsTo(Finalizadora, {
  foreignKey: "fzcod",
  targetKey: "codigo",
});
NaoFiscal.belongsTo(Loja, {
  foreignKey: "loja",
  targetKey: "codigo",
});

export default NaoFiscal;
