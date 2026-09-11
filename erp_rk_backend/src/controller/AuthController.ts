import jwt from "jsonwebtoken";
import { md5WithSalt } from "../utils/utils";
import Tenant from "../models/Tenant";
import Usuario from "../models/Usuario";
import seeder from "../../seeders/InitialSeeder";
import { msgComercial } from "./messages";

export default {
  async getTenant(req: any, res: any) {
    const { tenant_id } = req;
    const tenant = await Tenant.findOne({
      where: { id: tenant_id },
      attributes: { exclude: ["tenant_id"] },
    });

    res.status(200).json(tenant);
  },
  // O login principal (o inquilino criado pelo painel administrativo) nao tinha
  // como trocar a propria senha - dependia de alguem mexer no banco.
  //
  // O token nao separa o login principal dos usuarios web filhos: os dois
  // carregam so o tenant_id. Por isso a troca exige a senha atual; quem nao a
  // conhece nao troca, mesmo estando logado no mesmo tenant.
  async updateTenantPassword(req: any, res: any) {
    const { tenant_id } = req;
    const { senhaAtual, novaSenha, confirmacaoSenha } = req.body;

    if (!senhaAtual || !novaSenha || !confirmacaoSenha) {
      return res.status(400).json({
        message: "Informe a senha atual, a nova senha e a confirmacao !",
      });
    }

    if (novaSenha !== confirmacaoSenha) {
      return res
        .status(400)
        .json({ message: "Senha nao confere com confirmacao" });
    }

    if (novaSenha.length < 4) {
      return res
        .status(400)
        .json({ message: "A nova senha precisa ter ao menos 4 caracteres !" });
    }

    const tenant: any = await Tenant.findOne({ where: { id: tenant_id } });

    if (!tenant) {
      return res.status(404).json({ message: "Cliente nao encontrado !" });
    }

    if (md5WithSalt(senhaAtual) !== tenant.password) {
      return res.status(400).json({ message: "Senha atual incorreta !" });
    }

    if (md5WithSalt(novaSenha) === tenant.password) {
      return res
        .status(400)
        .json({ message: "A nova senha precisa ser diferente da atual !" });
    }

    try {
      await Tenant.update(
        { password: md5WithSalt(novaSenha) },
        { where: { id: tenant_id } }
      );
      return res
        .status(200)
        .json({ message: "Senha do login principal alterada com sucesso !" });
    } catch (error) {
      console.log(error);
      return res
        .status(400)
        .json({ message: "Erro ao alterar a senha do login principal" });
    }
  },
  async login(req: any, res: any) {
    try {
      const { user, password } = req.body;
      let isPasswordMatch: any;
      let token: string;
      let id: string;
      id = "";
      const tenantUser: any = await Tenant.findOne({ where: { user } });
      const userFind: any = await Usuario.findOne({ where: { user } });

      if (!tenantUser && !userFind) {
        return res.status(400).json({ message: "Usuário ou senha incorreto !" });
      }
      const cryptPass = md5WithSalt(password);

      if (tenantUser) {
        if (tenantUser.ativo === "N") {
          return res.status(400).json({ message: "Bloqueado, " + msgComercial });
        }
        isPasswordMatch = cryptPass === tenantUser.password;
        id = tenantUser.id;
      }
      if (userFind) {
        if (userFind.ativo === "N") {
          return res.status(400).json({ message: "Bloqueado, " + msgComercial });
        }
        isPasswordMatch = cryptPass === userFind.password;
        id = userFind.tenant_id;
      }

      if (!isPasswordMatch) {
        return res.status(400).json({ message: "Usuário ou senha incorreto !" });
      }
      token = jwt.sign({ tenant_id: id }, "B0RG55!", {
        // 24 horas. O comentario anterior dizia "50 minutos", que era o valor
        // antigo - a validade real e um dia.
        expiresIn: "24h",
      });
      return res.status(200).json({ token: token });
    } catch (error) {
      console.log(error);
      return res.status(400).json(error);
    }
  },

  async loginCarga(req: any, res: any) {
    const { user, password } = req.body;
    const userFind: any = await Tenant.findOne({
      where: { user, ativo: "S" },
    });

    if (!userFind) {
      return res.status(400).json({ message: "Usuário ou senha incorreto !" });
    }
    const cryptPass = md5WithSalt(password);
    const isPasswordMatch = cryptPass === userFind.password;

    if (!isPasswordMatch) {
      return res.status(400).json({ message: "Usuário ou senha incorreto !" });
    }

    const tokenInfinity = jwt.sign({ tenant_id: userFind.id }, "B0RG55!", {
      expiresIn: "30y",
    });
    return res.status(200).json({ tokenInfinity });
  },

  async register(req: any, res: any) {
    const { userAdmin } = req;
    const { name, email, user, password, confirmpassword, cnpjcpf, qtdUsuarios, qtdLojas } = req.body;
    if (password != confirmpassword) {
      return res.status(400).json({ message: "Senha não confere com confirmação" });
    }

    const isEmailExists = await Tenant.findOne({ where: { email: email } });
    if (isEmailExists) {
      return res.status(400).json({ message: "Email já cadastrado !" });
    }
    const isTenantExists = await Tenant.findOne({ where: { user: user } });
    const isUserExists = await Usuario.findOne({ where: { user: user } });

    if (isTenantExists || isUserExists) {
      return res.status(400).json({ message: "Usuário já cadastrado !" });
    }

    const isCnpjExists = await Tenant.findOne({ where: { cnpjcpf: cnpjcpf } });
    if (isCnpjExists) {
      return res.status(400).json({ message: "CNPJ Já cadastrado !" });
    }

    const hashPassword = md5WithSalt(password);

    try {
      const tenant = await Tenant.create({
        name,
        email,
        user,
        cnpjcpf,
        password: hashPassword,
        qtdUsuarios,
        qtdLojas,
        ativo: "S",
        userAdmin,
      });

      seeder(tenant);
      return res.status(201).json({ message: "Usuário criado com sucesso !" });
    } catch (error) {
      return res.status(400).json({
        message: "Erro ao criar usuário verifique com o administrador",
      });
    }
  },
};
