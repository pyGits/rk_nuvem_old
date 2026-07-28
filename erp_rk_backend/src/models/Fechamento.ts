import db from "../database/config";
import { DataTypes } from "sequelize";
import Finalizadora from "./Finalizadora";

const Fechamento = db.define("Fechamento", {
  id: { type: DataTypes.INTEGER, autoIncrement: true },
  loja: { type: DataTypes.INTEGER, primaryKey: true },
  codCaixa: { type: DataTypes.STRING(3), primaryKey: true },
  codigo: { type: DataTypes.STRING(50), primaryKey: true },
  tenant_id: { type: DataTypes.INTEGER, primaryKey: true },

  operador: { type: DataTypes.STRING(50) },
  dataAbertura: { type: DataTypes.DATEONLY },
  dataFechamento: { type: DataTypes.DATEONLY },
  horaAbertura: { type: DataTypes.TIME },
  horaFechamento: { type: DataTypes.TIME },
  codOperador: { type: DataTypes.INTEGER },

  vendaBruta: { type: DataTypes.REAL },
  cancelamentoCupom: { type: DataTypes.REAL },
  cancelamentoItem: { type: DataTypes.REAL },
  descontoItem: { type: DataTypes.REAL },
  descontoCupom: { type: DataTypes.REAL },
  acrescimoCupom: { type: DataTypes.REAL },
  vendaLiquida: { type: DataTypes.REAL },
  fundoCaixa: { type: DataTypes.REAL },
  sangria: { type: DataTypes.REAL },
  totais: { type: DataTypes.REAL },
});

const FechamentoForma = db.define("FechamentoForma", {
  id: { type: DataTypes.INTEGER, autoIncrement: true },
  loja: { type: DataTypes.INTEGER, primaryKey: true },
  codCaixa: { type: DataTypes.STRING(3), primaryKey: true },
  idFechamento: { type: DataTypes.STRING(50), primaryKey: true },
  tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
  Finalizadora: { type: DataTypes.STRING(3), primaryKey: true },

  valorLiquido: { type: DataTypes.REAL },
  valorEntrada: { type: DataTypes.REAL },
  valorTroco: { type: DataTypes.REAL },
  valorReforco: { type: DataTypes.REAL },
  valorSangria: { type: DataTypes.REAL },
  valorConferencia: { type: DataTypes.REAL },
  valorTotal: { type: DataTypes.REAL },
});

export { Fechamento, FechamentoForma };
