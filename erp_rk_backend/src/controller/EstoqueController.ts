import moment from "moment";
import { Sequelize } from "sequelize";
import Estoque from "../models/Estoque";
import EstoqueMovimentacao from "../models/EstoqueMovimentacao";
import Loja from "../models/Loja";
import { sincronizarLote, validaCorpoLote } from "./sincronizarLote";

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

  // Versao em lote do insertEstoqueMovimentacao. Mesma chave de movimentacao
  // (produto, loja, data, cupom, item) e mesmo efeito no saldo.
  //
  // Uma diferenca proposital em relacao ao handler unitario: la o saldo do
  // Estoque e somado mesmo quando o findOrCreate nao insere nada, o que faz o
  // reenvio de uma movimentacao ja gravada somar duas vezes. Aqui o saldo so
  // recebe as movimentacoes efetivamente inseridas. O handler unitario acima
  // fica como esta, para nao mudar o que ja roda em campo.
  async insertEstoqueMovimentacaoLote(req: any, res: any) {
    const { tenant_id } = req;
    const registros = req.body;

    const invalido = validaCorpoLote(registros);
    if (invalido) return res.status(400).json({ error: invalido });

    try {
      const resultado = await sincronizarLote({
        model: EstoqueMovimentacao,
        tenant_id,
        registros,
        chave: (registro: any) => ({
          codigo_produto: registro.codigo_produto,
          loja: registro.loja,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          codigo_cupom: registro.codigo_cupom,
          item: registro.item,
        }),
        mapear: (registro: any) => ({
          codigo_produto: registro.codigo_produto,
          qtde: registro.qtde,
          loja: registro.loja,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          hora: moment(registro.hora, "DD/MM/YYYY HH:mm:ss").format("HH:mm:ss"),
          codigo_cupom: registro.codigo_cupom,
          item: registro.item,
          codigo_funcionario: registro.codigo_funcionario,
          origem: registro.origem,
          tenant_id,
        }),
      });

      // um UPDATE por produto/loja, com a soma das movimentacoes novas, em vez
      // de um UPDATE por movimentacao
      const saldos = new Map<string, { codigo_produto: string; loja: any; qtde: number; ultimaSaida: any }>();

      for (const indice of resultado.inseridos) {
        const registro = registros[indice];
        const qtde = Number(registro.qtde);
        if (!Number.isFinite(qtde)) continue;

        const grupo = `${registro.loja}|${registro.codigo_produto}`;
        const ultimaSaida = moment(registro.data + registro.hora, "DD/MM/YYYY HH:mm:ss");

        const acumulado = saldos.get(grupo);
        if (!acumulado) {
          saldos.set(grupo, {
            codigo_produto: registro.codigo_produto,
            loja: registro.loja,
            qtde,
            ultimaSaida,
          });
        } else {
          acumulado.qtde += qtde;
          if (ultimaSaida.isValid() && ultimaSaida.isAfter(acumulado.ultimaSaida)) acumulado.ultimaSaida = ultimaSaida;
        }
      }

      for (const saldo of saldos.values()) {
        try {
          await Estoque.update(
            {
              estoque: Sequelize.literal(`estoque + ${saldo.qtde}`),
              ultima_saida: saldo.ultimaSaida.format("YYYY-MM-DD HH:mm:ss"),
            },
            { where: { codigo_produto: saldo.codigo_produto, loja: saldo.loja, tenant_id } }
          );
        } catch (error) {
          // a movimentacao ja esta gravada; falhar o saldo aqui nao pode fazer
          // o agente reenviar o lote inteiro
          console.log(error);
        }
      }

      res.status(201).json(resultado);
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
};
