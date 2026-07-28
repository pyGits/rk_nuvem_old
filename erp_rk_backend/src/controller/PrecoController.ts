import Loja from "../models/Loja";
import Preco from "../models/Preco";
import Produto from "../models/Produto";

function normalizarCusto(valor: any): number {
  const numero = Number(valor);
  if (isNaN(numero) || numero < 0) return 0;
  return numero;
}

export default {
  async getPreco(req: any, res: any) {
    const { tenant_id } = req;
    const codigo_produto = req.params.codigo;
    const lojas = await Loja.findAll({ where: { tenant_id } });

    const lojasComPreco = await Promise.all(
      lojas.map(async (loja) => {
        const preco = await Preco.findOne({
          where: {
            loja: loja.dataValues.codigo,
            codigo_produto: codigo_produto,
            tenant_id,
          },
        });

        return {
          codigo: loja.dataValues.codigo,
          loja: loja.dataValues.nome,
          codigo_produto: preco ? preco.dataValues.codigo_produto : codigo_produto,
          preco: preco ? preco.dataValues.preco : 0,
          markup: preco ? preco.dataValues.markup : 0,
          custo: preco ? normalizarCusto(preco.dataValues.custo) : 0,
          oferta: preco ? preco.dataValues.oferta : 0,
          preco2: preco ? preco.dataValues.preco2 : 0,
          preco2_qtd: preco ? preco.dataValues.preco2_qtd : 0,
        };
      }),
    );
    res?.status(200).json(lojasComPreco);
    return lojasComPreco;
  },

  async getPrecos(req: any, res: any) {
    const { tenant_id } = req;
    const alterados = req.query.alterados;
    const loja = req.query.loja;

    const where = {
      tenant_id,
      ...(alterados && { carga_pendente: true }),
      ...(loja && { loja }),
    };

    try {
      const precos = await Preco.findAll({
        where,
        attributes: { exclude: ["tenant_id"] },
      });
      res.status(200).json(precos);
    } catch (error) {
      res.status(400).json({ message: "Erro ao retornar preços" });
    }
  },

  async updateBatchPreco(req: any, res?: any) {
    const { tenant_id } = req;
    const { precos, codigo } = req.body;

    precos.map(async (preco: any) => {
      await Preco.update(
        {
          preco: preco.preco,
          custo: normalizarCusto(preco.custo),
          markup: preco.markup,
          oferta: preco.oferta,
          preco2: preco.preco2,
          preco2_qtd: preco.preco2_qtd,
        },
        {
          where: {
            loja: preco.codigo,
            tenant_id: tenant_id,
            codigo_produto: codigo,
          },
        },
      );
    });

    res.status(200).json({ message: "Lote de preços atualizado com sucesso" });
  },

  async updateOrInsertBatchPreco(req: any, res: any) {
    const { tenant_id } = req;
    const precos = req.body;
    try {
      let cod_produto = precos.codigo_produto;

      precos.map(async (preco: any) => {
        const isPrecoExists = await Preco.findOne({
          where: {
            loja: preco.codigo,
            codigo_produto: preco.codigo_produto,
            tenant_id,
          },
        });

        if (isPrecoExists) {
          await Preco.update(
            {
              preco2: preco.preco2,
              preco2_qtd: preco.preco2_qtd,
              oferta: preco.oferta,
              preco: preco.preco,
              custo: normalizarCusto(preco.custo),
              markup: preco.markup,
              carga_pendente: true,
            },
            {
              where: {
                tenant_id,
                codigo_produto: preco.codigo_produto,
                loja: preco.codigo,
              },
            },
          );
        } else {
          await Preco.create({
            preco2: preco.preco2,
            preco2_qtd: preco.preco2_qtd,
            oferta: preco.oferta,
            preco: preco.preco,
            custo: normalizarCusto(preco.custo),
            markup: preco.markup,
            tenant_id,
            codigo_produto: preco.codigo_produto,
            loja: preco.codigo,
            carga_pendente: true,
          });
        }
      });

      await Produto.update({ updated_at: new Date() }, { where: { tenant_id, codigo: cod_produto } });

      res.status(201).json({ message: "Preços inseridos com sucesso !" });
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
};
