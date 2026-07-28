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
        expiresIn: "24h", // ✅ 50 minutos (string com unidade)
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
