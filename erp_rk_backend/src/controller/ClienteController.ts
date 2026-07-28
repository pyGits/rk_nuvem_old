import Cliente from "../models/Cliente";
import { getNextSequencial } from "./UtilsController";

export default {
  async getCliente(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial("clientes", "codigo", tenant_id);
      return res.status(200).json({ codigo: sequencial });
    } else {
      const cliente = await Cliente.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });

      if (!cliente) {
        return res.status(404).json({ message: "Cliente não encontrado !" });
      } else {
        return res.status(200).json(cliente);
      }
    }
  },
  async getClientes(req: any, res: any) {
    const { tenant_id } = req;
    const clientes = await Cliente.findAll({ where: { tenant_id: tenant_id } });

    res.status(200).json(clientes);
  },
  async insertCliente(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, observacao, limiteCredito, percDesconto, utilizaPreco2 } = req.body;

    const { telefone, telefone2, celular, cnpjcpf, email, fantasia, ierg, nome } = req.body.pessoa;

    const { logradouro, cep, uf, cidade, bairro, complemento } = req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = {
      telefone,
      telefone2,
      celular,
      cnpjcpf,
      email,
      fantasia,
      ierg,
      nome,
    };
    try {
      await Cliente.create({
        codigo,
        observacao,
        limiteCredito,
        utiliza_preco2: utilizaPreco2,
        perc_desconto: percDesconto,
        ...endereco,
        ...pessoa,
        tenant_id,
      });
      res.status(201).json({ message: "Cliente inserido com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
  async updateCliente(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, observacao, limiteCredito, percDesconto, utilizaPreco2 } = req.body;

    const { celular, email, fantasia, ierg, nome, telefone, telefone2 } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } = req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = {
      celular,
      email,
      fantasia,
      ierg,
      nome,
      telefone,
      telefone2,
    };
    try {
      await Cliente.update(
        {
          codigo,
          observacao,
          limiteCredito,
          perc_desconto: percDesconto,
          utiliza_preco2: utilizaPreco2,
          ...endereco,
          ...pessoa,
          tenant_id,
        },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res.status(200).json({ message: "Cliente atualizado com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
};
