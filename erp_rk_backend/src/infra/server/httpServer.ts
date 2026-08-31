import "../../database/loadEnv";
import express, { Request, Response } from "express";
import router from "../../../routes";
import cors from "cors";
import path from "path";
import { verifyJWT } from "../../routes/auth.middleware";
import upload from "../middleware/uploadMiddleware";
import fs from "fs";
import https from "https";
import http from "http";
import dotenv from "dotenv";

// Carrega o .env correto
dotenv.config({
  path: path.resolve(__dirname, "..", "..", "..", `.env.${process.env.NODE_ENV || "development"}`),
});

// Acima disto a requisição entra no log mesmo tendo dado certo.
const LIMITE_REQUISICAO_LENTA_MS = 1000;

export interface HttpServer {
  register(method: string, url: string, callback: Function): void;
  registerFile(method: string, url: string, callback: Function): void;
  registerFiles(method: string, url: string, callback: Function): void;
  listen(port: number): void;
}

export class ExpressAdapter implements HttpServer {
  app: any;

  constructor() {
    this.app = express();
  }

  listen(): void {
    // Mesmo diretório onde o multer grava (images/logo/<tenant_id>), que é
    // relativo ao diretório de trabalho do processo.
    const logoDirectory = path.resolve(process.cwd(), "images/logo");

    this.app.use("/api/logo", express.static(logoDirectory));
    this.app.use(cors({ origin: "*" }));
    this.app.use(express.json({ limit: "50mb" }));
    this.app.use(express.urlencoded({ limit: "50mb", extended: true }));

    // Log de requisição enxuto: só o que pede atenção — erro ou lentidão.
    // Registrar toda requisição bem-sucedida traria de volta o ruído que faz o
    // log deixar de servir para diagnóstico, que é o problema que este trecho
    // existe para resolver.
    this.app.use((req: Request, res: Response, next: any) => {
      const inicio = Date.now();
      res.on("finish", () => {
        const ms = Date.now() - inicio;
        if (res.statusCode < 400 && ms < LIMITE_REQUISICAO_LENTA_MS) return;
        console.log(`[http] ${res.statusCode} ${ms}ms ${req.method} ${req.originalUrl}`);
      });
      next();
    });

    this.app.use("/api", router);

    this.app.get("/", (req, res) => {
      res.json({ message: "Hello World !" });
    });

    const port = process.env.SERVER_PORT || 3000;
    const env = process.env.NODE_ENV || "development";

    // Em produção o TLS é terminado pelo nginx, que faz proxy de /api para cá em
    // HTTP na rede interna do Docker. O modo HTTPS direto continua disponível
    // para quem rodar o backend sem proxy: basta definir SSL_KEY_PATH/SSL_CERT_PATH.
    const sslKeyPath = process.env.SSL_KEY_PATH;
    const sslCertPath = process.env.SSL_CERT_PATH;

    if (sslKeyPath && sslCertPath) {
      const options = {
        key: fs.readFileSync(sslKeyPath),
        cert: fs.readFileSync(sslCertPath),
      };

      https.createServer(options, this.app).listen(port, () => {
        console.log(`🔐 HTTPS Server rodando em https://localhost:${port} [${env}]`);
      });
    } else {
      http.createServer(this.app).listen(port, () => {
        console.log(`🌐 HTTP Server rodando em http://localhost:${port} [${env}]`);
      });
    }
  }

  register(method: string, url: string, callback: Function): void {
    this.app[method]("/api" + url, verifyJWT, async (req: Request, res: Response) => {
      try {
        const output = await callback(req.params, req.body, req.query);
        res.json(output);
      } catch (error: any) {
        res.status(422).json({ message: error.message });
      }
    });
  }
  registerNotAUTH(method: string, url: string, callback: Function): void {
    this.app[method]("/api" + url, async (req: Request, res: Response) => {
      try {
        const output = await callback(req.params, req.body, req.query);
        res.json(output);
      } catch (error: any) {
        res.status(422).json({ message: error.message });
      }
    });
  }
  registerHomolog(method: string, url: string, callback: Function): void {
    this.app[method]("/api/homolog" + url, async (req: Request, res: Response) => {
      try {
        const output = await callback(req.params, req.body, req.query);
        res.json(output);
      } catch (error: any) {
        res.status(422).json({ message: error.message });
      }
    });
  }

  registerFile(method: string, url: string, callback: Function): void {
    this.app[method]("/api" + url, verifyJWT, upload.single("arquivo"), async (req: Request, res: Response) => {
      try {
        const output = await callback(req, req.body);
        res.json(output);
      } catch (error: any) {
        res.status(422).json({ message: error.message });
      }
    });
  }

  registerFiles(method: string, url: string, callback: Function): void {
    this.app[method]("/api" + url, verifyJWT, upload.array("arquivo"), async (req: Request, res: Response) => {
      try {
        const output = await callback(req, req.body);
        res.json(output);
      } catch (error: any) {
        res.status(422).json({ message: error.message });
      }
    });
  }
}

export default new ExpressAdapter();
