import Funcionario from "../models/Funcionario";
import { getNextSequencial } from "./UtilsController";
import { CriptRK } from "../utils/utils";

// Campos de texto que o agente de carga le direto do JSON. Em null ele grava a
// string literal "null" no PDV, entao saem sempre como string vazia.
const CAMPOS_TEXTO = ["codigo", "nome", "fantasia", "email", "cnpjcpf"];

// O agente converte cargo e comissao para numero sem tratar null, e um
// StrToInt('null') derruba a carga inteira do tenant - foi o que aconteceu com
// os funcionarios criados pelo seeder, que nasciam sem esses dois campos.
function normalizarFuncionario(funcionario: any) {
  const dados = typeof funcionario?.toJSON === "function" ? funcionario.toJSON() : { ...funcionario };

  for (const campo of CAMPOS_TEXTO) {
    if (dados[campo] === null || dados[campo] === undefined) dados[campo] = "";
  }

  dados.cargo = dados.cargo === null || dados.cargo === undefined || dados.cargo === "" ? "0" : String(dados.cargo);
  dados.comissao = Number(dados.comissao) || 0;

  return dados;
}

export default {
  async getFuncionario(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial(
        "funcionarios",
        "codigo",
        tenant_id
      );
      return res.status(200).json({ codigo: sequencial });
    } else {
      const funcionario = await Funcionario.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });

      if (!funcionario) {
        return res
          .status(404)
          .json({ message: "Funcionario não encontrado !" });
      } else {
        return res.status(200).json(normalizarFuncionario(funcionario));
      }
    }
  },
  async getFuncionarios(req: any, res: any) {
    const { tenant_id } = req;
    const alterados = req.query.alterados;
    try {
      let funcionarios = [];
      if (!alterados) {
        funcionarios = await Funcionario.findAll({
          where: { tenant_id: tenant_id },
        });
      } else {
        funcionarios = await Funcionario.findAll({
          where: { tenant_id: tenant_id, carga_pendente: true },
        });
      }

      res.status(200).json(funcionarios.map(normalizarFuncionario));
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
  async insertFuncionario(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, cargo, comissao, password } = req.body;

    const { celular, cnpjcpf, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, cnpjcpf, email, fantasia, ierg, nome };

    const hashPassword = CriptRK("C", password);

    try {
      await Funcionario.create({
        codigo,
        ...endereco,
        ...pessoa,
        cargo,
        comissao,
        password: hashPassword,
        carga_pendente: true,
        tenant_id,
      });
      res.status(201).json({ message: "Funcionario inserido com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
  async updateFuncionario(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, cargo, comissao, password } = req.body;
    const { celular, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, email, fantasia, ierg, nome };
    const hashPassword = CriptRK("C", password);

    try {
      await Funcionario.update(
        {
          codigo,
          ...endereco,
          ...pessoa,
          cargo,
          comissao,
          password: hashPassword,
          tenant_id,
          carga_pendente: true,
        },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res.status(200).json({ message: "Funcionario atualizado com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
};
