import Funcionario from "../models/Funcionario";
import { getNextSequencial } from "./UtilsController";
import { CriptRK } from "../utils/utils";

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
        return res.status(200).json(funcionario);
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

      res.status(200).json(funcionarios);
    } catch (error) {}
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
