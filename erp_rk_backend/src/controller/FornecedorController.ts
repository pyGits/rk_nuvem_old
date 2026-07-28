import Fornecedor from "../models/Fornecedor";
import { getNextSequencial } from "./UtilsController";

export default {
  async getFornecedor(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial("fornecedors", "codigo", tenant_id);
      return res.status(200).json({ codigo: sequencial });
    } else {
      const fornecedor = await Fornecedor.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });

      if (!fornecedor) {
        return res.status(404).json({ message: "Fornecedor não encontrado !" });
      } else {
        return res.status(200).json(fornecedor);
      }
    }
  },
  async getFornecedors(req: any, res: any) {
    const { tenant_id } = req;
    const fornecedors = await Fornecedor.findAll({
      where: { tenant_id: tenant_id },
    });

    res.status(200).json(fornecedors);
  },
  async insertFornecedor(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, im, observacao, transportadora } = req.body;

    const { celular, cnpjcpf, email, fantasia, ierg, nome, telefone, telefone2 } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } = req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = {
      celular,
      cnpjcpf,
      email,
      fantasia,
      ierg,
      nome,
      telefone,
      telefone2,
    };
    try {
      await Fornecedor.create({
        codigo,
        im,
        observacao,
        transportadora,
        ...endereco,
        ...pessoa,
        tenant_id,
      });
      res.status(201).json({ message: "Fornecedor inserido com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
  async updateFornecedor(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, im, observacao, transportadora } = req.body;
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
      await Fornecedor.update(
        { codigo, im, observacao, transportadora, ...endereco, ...pessoa, tenant_id },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res.status(200).json({ message: "Fornecedor atualizado com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
};
