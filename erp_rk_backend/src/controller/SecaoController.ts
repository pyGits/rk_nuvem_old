import { getNextSequencial } from "./UtilsController";
import Secao from "../models/Secao";
import Grupo from "../models/Grupo";
import { Sequelize } from "sequelize";

export default {
  async insertSecao(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, nome, margem } = req.body;
    try {
      await Secao.create({
        codigo: codigo,
        nome: nome,
        margem: margem,
        tenant_id: tenant_id,
      });
      res.status(201).json({ message: "Seção criada com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: "Erro ao criar seção: " + error });
    }
  },
  async updateSecao(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, nome, margem } = req.body;

    await Secao.update(
      { nome: nome, margem: margem },
      { where: { codigo: codigo, tenant_id: tenant_id } }
    );

    res.status(200).json({ message: "Seção atualizada com sucesso !" });
  },

  async getSecao(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;
    if (codigo === "novo") {
      const sequencial = await getNextSequencial("secaos", "codigo", tenant_id);
      return res.status(200).json({ codigo: sequencial });
    } else {
      const secao = await Secao.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });
      return res.status(200).json(secao);
    }
  },

  async getSecoes(req: any, res: any) {
    const { tenant_id } = req;

    const secoes = await Secao.findAll({
      where: { tenant_id: tenant_id },
      order: [[Sequelize.cast(Sequelize.col("codigo"), "INTEGER"), "ASC"]],
    });

    res.status(200).json(secoes);
  },
  async deleteSecao(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;
    const isGrupoExists = await Grupo.findAll({
      where: { codigo_secao: codigo, tenant_id },
    });

    if (isGrupoExists.length != 0) {
      return res.status(400).json({
        message: "Existem grupos cadastrados, delete os grupos primeiro",
      });
    }

    await Secao.destroy({ where: { codigo: codigo, tenant_id } });
    res.status(200).json({ message: "Seção deletada com sucesso !" });
  },
};
