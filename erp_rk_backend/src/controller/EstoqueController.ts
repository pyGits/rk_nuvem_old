import moment from "moment";
import { Sequelize } from "sequelize";
import Estoque from "../models/Estoque";
import EstoqueMovimentacao from "../models/EstoqueMovimentacao";
import Loja from "../models/Loja";

export default {
  async getEstoques(req: any, res: any) {
    const { tenant_id } = req;
    const alterados = req.query.alterados;
    const loja = req.query.loja;

    const where = {
      tenant_id,
      ...(alterados && { carga_pendente: true }),
      ...(loja && { loja }),
    };

    try {
      const estoques = await Estoque.findAll({
        where,
      });
      res.status(200).json(estoques);
    } catch (error) {
      res.status(400).json({ message: "Erro ao retornar estoque" });
    }
  },
  async updateOrInsertBatchEstoque(req: any, res: any) {
    const { tenant_id } = req;
    const estoques = req.body;
    try {
      estoques.map(async (estoque: any) => {
        const isEstoqueExists = await Estoque.findOne({
          where: {
            loja: estoque.codigo,
            codigo_produto: estoque.codigo_produto,
            tenant_id,
          },
        });
        if (isEstoqueExists) {
          await Estoque.update(
            {
              estoque: estoque.estoque,
              estoque_minimo: estoque.estoque_minimo,
              estoque_maximo: estoque.estoque_maximo,
              carga_pendente: true,
            },
            {
              where: {
                tenant_id,
                codigo_produto: estoque.codigo_produto,
                loja: estoque.codigo,
              },
            }
          );
        } else {
          await Estoque.create({
            estoque: estoque.estoque,
            estoque_minimo: estoque.estoque_minimo,
            estoque_maximo: estoque.estoque_maximo,
            tenant_id,
            codigo_produto: estoque.codigo_produto,
            loja: estoque.codigo,
            carga_pendente: true,
          });
        }
      });

      res.status(201).json({ message: "Estoque inserido com sucesso !" });
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },

  async getEstoque(req: any, res: any) {
    const { tenant_id } = req;
    const codigo_produto = req.params.codigo;
    const lojas = await Loja.findAll({ where: { tenant_id } });

    const lojasComEstoque = await Promise.all(
      lojas.map(async (loja) => {
        const estoque = await Estoque.findOne({
          where: {
            loja: loja.dataValues.codigo,
            codigo_produto: codigo_produto,
            tenant_id,
          },
        });

        return {
          codigo: loja.dataValues.codigo,
          loja: loja.dataValues.nome,
          codigo_produto: estoque ? estoque.dataValues.codigo_produto : codigo_produto,
          estoque: estoque ? estoque.dataValues.estoque : 0,
          estoque_minimo: estoque ? estoque.dataValues.estoque_minimo : 0,
          estoque_maximo: estoque ? estoque.dataValues.estoque_maximo : 0,
          ultima_saida: estoque ? estoque.dataValues.ultima_saida : 0,
        };
      })
    );
    res?.status(200).json(lojasComEstoque);
    return lojasComEstoque;
  },

  async insertEstoqueMovimentacao(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo_produto, loja, qtde, data, hora, codigo_cupom, item, codigo_funcionario, origem } = req.body;
    try {
      await EstoqueMovimentacao.findOrCreate({
        where: {
          codigo_produto,
          loja,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          codigo_cupom,
          item,
          tenant_id,
        },
        defaults: {
          codigo_produto,
          qtde,
          loja,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          hora: moment(hora, "DD/MM/YYYY HH:mm:ss").format("HH:mm:ss"),
          codigo_cupom,
          item,
          codigo_funcionario,
          origem,
          tenant_id,
        },
      });
      await Estoque.update(
        {
          estoque: Sequelize.literal(`estoque + ${qtde}`),
          ultima_saida: moment(data + hora, "DD/MM/YYYY HH:mm:ss").format("YYYY-MM-DD HH:mm:ss"),
        },
        {
          where: {
            codigo_produto: codigo_produto,
            loja: loja,
            tenant_id,
          },
        }
      );

      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      console.log(error);
      res.status(400).json(error);
    }
  },
};
