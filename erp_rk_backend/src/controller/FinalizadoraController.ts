import Finalizadora from "../models/Finalizadora";
import { getNextSequencial } from "./UtilsController";

export default {
  async getFinalizadora(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial(
        "finalizadoras",
        "codigo",
        tenant_id
      );
      return res.status(200).json({ codigo: sequencial });
    } else {
      const finalizadora = await Finalizadora.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });

      if (!finalizadora) {
        return res
          .status(404)
          .json({ message: "Finalizadora não encontrada !" });
      } else {
        return res.status(200).json(finalizadora);
      }
    }
  },

  async getFinalizadoras(req: any, res: any) {
    const { tenant_id } = req;
    const alterados = req.query.alterados;
    try {
      let finalizadoras = [];
      if (!alterados) {
        finalizadoras = await Finalizadora.findAll({
          where: { tenant_id: tenant_id },
        });
      } else {
        finalizadoras = await Finalizadora.findAll({
          where: { tenant_id: tenant_id, carga_pendente: true },
        });
      }
      res.status(200).json(finalizadoras);
    } catch (error) {
      res
        .status(400)
        .json({ message: "Erro ao buscar finalizadoras: " + error });
    }
  },

  async insertFinalizadora(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, nome, especie, tipo, utiliza99 } = req.body;
    try {
      await Finalizadora.create({
        codigo: codigo.padStart(3, "0"),
        nome,
        especie,
        tipo,
        utiliza99,
        carga_pendente: true,
        tenant_id,
      });
      res.status(200).json({ message: "Finalizadora inserida com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },

  async updateFinalizadora(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, nome, especie, tipo, utiliza99 } = req.body;
    try {
      await Finalizadora.update(
        { codigo, nome, especie, tipo, utiliza99, carga_pendente: true },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res
        .status(200)
        .json({ message: "Finalizadora atualizada com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
};
