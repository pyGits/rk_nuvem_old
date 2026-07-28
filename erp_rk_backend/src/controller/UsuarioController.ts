import { msgComercial } from "./messages";
import Tenant from "../models/Tenant";
import Usuario from "../models/Usuario";
import { getNextSequencial } from "./UtilsController";

export default {
  async getUsuario(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial(
        "usuarios",
        "codigo",
        tenant_id
      );
      return res.status(200).json({ codigo: sequencial });
    } else {
      const usuario = await Usuario.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
        attributes: { exclude: ["password"] },
      });

      if (!usuario) {
        return res.status(404).json({ message: "Usuario não encontrado !" });
      } else {
        return res.status(200).json(usuario);
      }
    }
  },
  async getUsuarios(req: any, res: any) {
    const { tenant_id } = req;
    const usuarios = await Usuario.findAll({
      where: { tenant_id: tenant_id },
      attributes: { exclude: ["password"] },
    });

    res.status(200).json(usuarios);
  },
  async insertUsuario(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, user, password } = req.body;

    const { celular, cnpjcpf, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, cnpjcpf, email, fantasia, ierg, nome };

    const isUserExists = await Usuario.findOne({ where: { user: user } });
    const isTenantExists = await Tenant.findOne({ where: { user: user } });

    if (isUserExists || isTenantExists) {
      return res.status(400).json({ message: "Usuário já cadastrado !" });
    }
    const isTenantUserQtd = await Tenant.findOne({ where: { id: tenant_id } });
    const qtdUsersRegistred = await Usuario.findAndCountAll({
      where: { tenant_id },
    });

    if (qtdUsersRegistred.count >= isTenantUserQtd?.dataValues.qtdUsuarios) {
      return res.status(400).json({
        message: "Quantidade máxima de usuários registrados, " + msgComercial,
      });
    }

    try {
      await Usuario.create({
        codigo,
        user,
        password,
        ...endereco,
        ...pessoa,
        ativo: "S",
        tenant_id,
      });
      res.status(201).json({ message: "Usuario inserido com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
  async updateUsuario(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, user, password } = req.body;
    const { celular, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, email, fantasia, ierg, nome };

    const isTenantExists = await Tenant.findOne({ where: { user } });
    const isUserExists = await Usuario.findOne({ where: { user } });
    if (isTenantExists) {
      return res
        .status(400)
        .json({ message: "Usuário ja cadastrado no sistema, escolha outro" });
    }

    if (isUserExists) {
      return res
        .status(400)
        .json({ message: "Usuário ja cadastrado no sistema, escolha outro" });
    }

    try {
      await Usuario.update(
        { codigo, user, password, ...endereco, ...pessoa, tenant_id },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
          individualHooks: true,
        }
      );
      res.status(200).json({ message: "Usuario atualizado com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: "Erro au atualizar usuário" });
    }
  },

  async verifyUser(req: any, res: any) {
    const { user } = req.body;

    const isUserExists = await Usuario.findOne({ where: { user: user } });
    const isTenantExists = await Tenant.findOne({ where: { user: user } });

    if (isUserExists || isTenantExists) {
      return res.status(400).json({ message: "Usuário já cadastrado !" });
    }

    return res.status(200).json({ message: "Usuário valido " });
  },
};
