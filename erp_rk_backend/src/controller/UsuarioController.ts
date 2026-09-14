import { msgComercial } from "./messages";
import Tenant from "../models/Tenant";
import Usuario from "../models/Usuario";
import { getNextSequencial } from "./UtilsController";
import PermissaoRepository from "../permissao/PermissaoRepository";
import { invalidarCache } from "../permissao/PermissaoService";
import { apenasTelasConhecidas, TELA_ACESSO_TOTAL } from "../permissao/CatalogoTelas";

export default {
  // As telas que este usuario pode abrir. Fica fora do getUsuario de proposito:
  // o cadastro grava pelo model Sequelize, cujo hook beforeSave re-hasheia a
  // senha, e o GET nao devolve `password` - juntar as duas coisas faria mexer
  // num acesso exigir redigitar a senha do sujeito.
  async getAcessos(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = String(req.params.codigo);

    const usuario = await Usuario.findOne({ where: { codigo, tenant_id } });
    if (!usuario) {
      return res.status(404).json({ message: "Usuario não encontrado !" });
    }

    const telas = await PermissaoRepository.listarTelas(tenant_id, codigo);

    return res.status(200).json({
      acessoTotal: telas.includes(TELA_ACESSO_TOTAL),
      telas: telas.filter((tela) => tela !== TELA_ACESSO_TOTAL),
    });
  },

  // Troca o conjunto de telas de uma vez. Body:
  //   { acessoTotal: false, telas: ["cadastro.produto", ...] }
  //
  // Com acessoTotal, grava so a marca '*' - que vale inclusive para as telas
  // que ainda nao existem. E o estado em que ficaram os usuarios que ja
  // existiam quando esta feature subiu.
  async updateAcessos(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = String(req.params.codigo);
    const { acessoTotal } = req.body;
    const telasRecebidas: string[] = Array.isArray(req.body.telas) ? req.body.telas : [];

    const usuario = await Usuario.findOne({ where: { codigo, tenant_id } });
    if (!usuario) {
      return res.status(404).json({ message: "Usuario não encontrado !" });
    }

    // Id fora do catalogo viraria permissao fantasma: gravada no banco, sem
    // checkbox na tela para alguem enxergar ou tirar depois.
    const telas = acessoTotal ? [TELA_ACESSO_TOTAL] : apenasTelasConhecidas(telasRecebidas);

    try {
      await PermissaoRepository.substituirTelas(tenant_id, codigo, telas);
      invalidarCache(tenant_id, codigo);

      return res.status(200).json({ message: "Acessos gravados com sucesso !" });
    } catch (error) {
      console.log("[permissao] falha ao gravar acessos", error);
      return res.status(400).json({ message: "Erro ao gravar os acessos do usuário" });
    }
  },
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
    // O código vem da rota - é ele que identifica o registro em edição. Na
    // tela o campo fica desabilitado nesse modo, então não muda.
    const codigo = req.params.codigo;
    const { user, password } = req.body;
    const { celular, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, email, fantasia, ierg, nome };

    const isTenantExists = await Tenant.findOne({ where: { user } });
    if (isTenantExists) {
      return res
        .status(400)
        .json({ message: "Usuário ja cadastrado no sistema, escolha outro" });
    }

    // Esta busca era feita só pelo login e acabava encontrando o próprio
    // usuário que estava sendo editado: qualquer gravação voltava "já
    // cadastrado", mesmo sem ter mexido no login. Só há conflito quando o
    // login pertence a OUTRO registro.
    const usuarioComMesmoLogin: any = await Usuario.findOne({
      where: { user },
    });
    const loginEhDeOutroUsuario =
      !!usuarioComMesmoLogin &&
      (String(usuarioComMesmoLogin.codigo) !== String(codigo) ||
        String(usuarioComMesmoLogin.tenant_id) !== String(tenant_id));

    if (loginEhDeOutroUsuario) {
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
