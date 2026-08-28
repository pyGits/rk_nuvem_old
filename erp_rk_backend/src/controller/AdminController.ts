import multer, { Multer } from "multer";
import path from "path";
import { Request, Response } from "express";
import Admin from "../models/Admin";
import Tenant from "../models/Tenant";
import Usuario from "../models/Usuario";
import { md5WithSalt } from "../utils/utils";
import jwt from "jsonwebtoken";
import fs from "fs";

const SECRET = "9#4pG5*XbE";

// Validade do token do painel administrativo.
//
// Era `3000`, um NUMERO - e numero no jsonwebtoken sao SEGUNDOS, ou seja 50
// minutos. Quem opera o painel fica horas numa tarefa so (mutirao de NCM,
// varredura da SEFAZ, carga do IBPT) e o token vencia no meio: o 401 derrubava
// para a tela de login sem aviso, no meio do trabalho.
//
// Mesma validade do tokenInfinity que ja existe para o PDV, por consistencia.
//
// Contrapartida, que e real: um token vazado vale por muito tempo e nao ha
// revogacao - a unica saida seria trocar o SECRET, o que desloga todo mundo.
const VALIDADE_TOKEN_ADMIN = "30y";

const storage: Multer = multer({
  storage: multer.diskStorage({
    destination: (req: any, file, cb) => {
      cb(null, `images/logo/${req.tenant_id}/`);
    },
    filename: (req, file, cb) => {
      const ext = path.extname(file.originalname);
      const filename = `${file.fieldname}-${Date.now()}${ext}`;
      cb(null, filename);
    },
  }),
  fileFilter: (req, file, cb) => {
    const allowedExtensions = [".jpg", ".jpeg", ".png"];
    const ext = path.extname(file.originalname).toLowerCase();

    if (allowedExtensions.includes(ext)) {
      cb(null, true);
    } else {
      cb(
        new Error("Formato de arquivo inválido. Apenas imagens são permitidas.")
      );
    }
  },
});

export default {
  async uploadTenantLogo(req: any, res: Response) {
    const { tenant_id } = req;
    const logoPath = `images/logo/${tenant_id}/`;
    try {
      if (!fs.existsSync(logoPath)) {
        fs.mkdirSync(logoPath, { recursive: true });
      }
      storage.single("logo")(req, res, async (err: any) => {
        if (err) {
          console.error(err);
          return res
            .status(500)
            .json({ message: "Erro ao fazer upload do logo" });
        }

        const file = req.file;
        const previousLogo: any = await Tenant.findOne({
          where: { id: tenant_id },
        });

        // Exclui o arquivo anterior, se existir
        if (previousLogo && previousLogo.logo) {
          const filePath = path.join(logoPath, previousLogo.logo);
          fs.unlink(filePath, (err: any) => {
            if (err) {
              console.error(err);
            }
          });
        }

        await Tenant.update(
          { logo: file.filename },
          { where: { id: tenant_id } }
        );
        // Aqui você pode processar o arquivo, salvar o caminho no banco de dados, etc.

        res.json({ message: "Upload do logo concluído com sucesso" });
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao fazer upload do logo" });
    }
  },

  async getTenantList(req: Request, res: Response) {
    try {
      const tenantList = await Tenant.findAll();
      res.status(200).json(tenantList);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao obter a lista de clientes" });
    }
  },

  async getTenant(req: Request, res: Response) {
    try {
      const { codigo } = req.params;
      const tenant = await Tenant.findOne({ where: { codigo } });
      res.status(200).json(tenant);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao obter o cliente" });
    }
  },

  async updateTenant(req: Request, res: Response) {
    try {
      const { id, cnpjcpf, name, qtdLojas, qtdUsuarios, user, ativo } =
        req.body;
      const isUserExists = await Usuario.findOne({ where: { user } });
      if (isUserExists) {
        return res
          .status(400)
          .json({ message: "Já existe usuário cadastrado, escolha outro" });
      }

      await Tenant.update(
        {
          cnpjcpf,
          name,
          qtdLojas,
          qtdUsuarios,
          user,
          ativo,
        },
        { where: { id, cnpjcpf } }
      );

      await Usuario.update({ ativo }, { where: { tenant_id: id } });

      res.status(201).json({ message: "Cliente atualizado com sucesso" });
    } catch (error) {
      console.error(error);
      res.status(400).json({ message: "Erro ao atualizar o cliente" });
    }
  },

  async login(req: Request, res: Response) {
    try {
      const { user, password } = req.body;
      const criptPass = md5WithSalt(password);

      const isUserExists = await Admin.findOne({
        where: { user, password: criptPass },
      });

      if (isUserExists) {
        const token = jwt.sign({ userAdmin: user }, SECRET, {
          expiresIn: VALIDADE_TOKEN_ADMIN,
        });
        res.status(200).json({ token });
      } else {
        res.status(400).json({ message: "Usuário ou senha não confere" });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao efetuar o login" });
    }
  },
};
