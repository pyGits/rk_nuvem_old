import Grupo from "./../models/Grupo";
import { getNextSequencial } from "./UtilsController";

export default {
  async deleteGrupo(req: any, res: any) {
    const { tenant_id } = req;
    const codigoGrupo = req.params.codigogrupo;
    const codigoSecao = req.params.codigosecao;
    await Grupo.destroy({
      where: { codigo_secao: codigoSecao, codigo: codigoGrupo, tenant_id },
    });
    res.status(200).json({ message: "Grupo deletado com sucesso !" });
  },
  async getGrupos(req: any, res: any) {
    const { tenant_id } = req;
    const codigo_secao = req.params.codigosecao;
    const grupos = await Grupo.findAll({
      where: { tenant_id: tenant_id, codigo_secao: codigo_secao },
      order: [["codigo", "ASC"]],
    });

    res.status(200).json(grupos);
  },
  async getGrupo(req: any, res: any) {
    const { tenant_id } = req;
    const { codigosecao, codigogrupo } = req.params;
    if (codigogrupo === "novo") {
      const sequencial = await getNextSequencial(
        "grupos",
        "codigo",
        tenant_id,
        "codigo_secao",
        codigosecao
      );
      return res.status(200).json({ codigo: sequencial });
    } else {
      const grupo = await Grupo.findOne({
        where: {
          codigo_secao: codigosecao,
          codigo: codigogrupo,
          tenant_id: tenant_id,
        },
      });
      return res.status(200).json(grupo);
    }
  },
  async insertGrupo(req: any, res: any) {
    const { tenant_id } = req;
    const { codigosecao } = req.params;
    const { codigo, nome, margem } = req.body;

    const isGrupoExists = await Grupo.findOne({
      where: {
        codigo_secao: codigosecao,
        codigo: codigo,
        tenant_id: tenant_id,
      },
    });

    if (isGrupoExists) {
      return res.status(400).json({ message: "Grupo já existe" });
    }

    try {
      await Grupo.create({
        codigo_secao: codigosecao,
        codigo: codigo,
        margem: margem,
        nome: nome,
        tenant_id: tenant_id,
      });
      res.status(201).json({ message: "Grupo criado com sucesso" });
    } catch (error: any) {
      return res.status(400).json({ message: error.message });
    }
  },

  async updateGrupo(req: any, res: any) {
    const { tenant_id } = req;
    const { codigosecao, codigo } = req.params;
    const { nome, margem } = req.body;
    try {
      await Grupo.update(
        { nome: nome, margem: margem },
        {
          where: {
            codigo_secao: codigosecao,
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res.status(200).json({ message: "Grupo atualizado com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: "Erro ao atualizar grupo: " + error });
    }
  },
};
