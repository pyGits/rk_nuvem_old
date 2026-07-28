import { DataTypes } from "sequelize";

// Definir a classe abstrata
const Endereco = {
  logradouro: { type: DataTypes.STRING(80) },
  cidade: { type: DataTypes.STRING(40) },
  uf: { type: DataTypes.STRING(2) },
  cep: { type: DataTypes.STRING(10) },
  bairro: { type: DataTypes.STRING(40) },
  complemento: { type: DataTypes.STRING(30) },
};
export default Endereco;
