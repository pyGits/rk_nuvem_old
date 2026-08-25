import multer, { Multer } from "multer";
import path from "path";
import fs from "fs";
import crypto from "crypto";
import jwt from "jsonwebtoken";
import { Request, Response } from "express";
import Download from "../models/Download";

// Fica dentro de uploads/, que ja e um volume nomeado no docker-compose — os
// arquivos publicados sobrevivem ao deploy.
const DIRETORIO = path.resolve(process.cwd(), "uploads/downloads");

const EXTENSOES_PERMITIDAS = [".zip", ".rar", ".7z", ".exe", ".msi"];
const TAMANHO_MAXIMO = 1024 * 1024 * 1024; // 1 GB

// Secret proprio para os links de download: o token do usuario nao pode
// trafegar na URL, senao vaza nos logs de acesso e daria acesso a API inteira.
const SECRET_LINK = "dWn!7Kq2#Lz";
const VALIDADE_LINK = "5m";

function garanteDiretorio() {
  if (!fs.existsSync(DIRETORIO)) {
    fs.mkdirSync(DIRETORIO, { recursive: true });
  }
}

const storage: Multer = multer({
  storage: multer.diskStorage({
    destination: (req, file, cb) => {
      garanteDiretorio();
      cb(null, DIRETORIO);
    },
    filename: (req, file, cb) => {
      // Nome de disco proprio: o nome enviado pelo navegador nao e confiavel e
      // ainda pode colidir com um arquivo ja publicado.
      const ext = path.extname(file.originalname).toLowerCase();
      cb(null, `${Date.now()}-${crypto.randomBytes(6).toString("hex")}${ext}`);
    },
  }),
  limits: { fileSize: TAMANHO_MAXIMO },
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();

    if (EXTENSOES_PERMITIDAS.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error(`Formato inválido. Envie um arquivo ${EXTENSOES_PERMITIDAS.join(", ")}.`));
    }
  },
});

function apagaArquivo(nome: string) {
  if (!nome) return;

  // basename corta qualquer "../" que tenha entrado no banco por outro caminho.
  const caminho = path.join(DIRETORIO, path.basename(nome));
  fs.unlink(caminho, () => undefined);
}

// Uma hora sem estar no banco e arquivo abandonado; abaixo disso pode ser um
// upload em andamento (o multer grava antes de o registro existir).
const IDADE_MINIMA_ORFAO = 60 * 60 * 1000;

// O disco fica so com os arquivos que estao publicados: cada item guarda uma
// unica versao, e upload interrompido ou falha na gravacao nao deixa zip
// ocupando espaco no volume.
async function limpaOrfaos() {
  try {
    if (!fs.existsSync(DIRETORIO)) return;

    const registros: any[] = await Download.findAll({ attributes: ["arquivo"] });
    const publicados = new Set(registros.map((r) => r.arquivo));

    for (const nome of fs.readdirSync(DIRETORIO)) {
      if (publicados.has(nome)) continue;

      const caminho = path.join(DIRETORIO, nome);
      const idade = Date.now() - fs.statSync(caminho).mtimeMs;
      if (idade > IDADE_MINIMA_ORFAO) {
        fs.unlinkSync(caminho);
      }
    }
  } catch (error) {
    // Faxina nao pode derrubar a publicacao que acabou de dar certo.
    console.error(error);
  }
}

export default {
  // Lista mostrada aos clientes: so o que esta publicado.
  async listarPublicados(req: Request, res: Response) {
    try {
      const downloads = await Download.findAll({
        where: { ativo: true },
        attributes: ["id", "titulo", "descricao", "versao", "tamanho", "arquivo_original", "updated_at"],
        order: [["updated_at", "DESC"]],
      });
      res.status(200).json(downloads);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao listar os downloads" });
    }
  },

  async listar(req: Request, res: Response) {
    try {
      const downloads = await Download.findAll({ order: [["titulo", "ASC"]] });
      res.status(200).json(downloads);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao listar os downloads" });
    }
  },

  async publicar(req: any, res: Response) {
    garanteDiretorio();

    storage.single("arquivo")(req, res, async (err: any) => {
      if (err) {
        return res.status(400).json({ message: err.message || "Erro ao enviar o arquivo" });
      }

      const arquivo = req.file;
      if (!arquivo) {
        return res.status(400).json({ message: "Selecione o arquivo que será publicado" });
      }

      const { titulo, descricao, versao, id } = req.body;
      if (!titulo) {
        apagaArquivo(arquivo.filename);
        return res.status(400).json({ message: "Informe o título do download" });
      }

      try {
        const dados = {
          titulo,
          descricao: descricao || "",
          versao: versao || "",
          arquivo: arquivo.filename,
          arquivo_original: arquivo.originalname,
          tamanho: arquivo.size,
        };

        if (id) {
          const atual: any = await Download.findByPk(id);
          if (!atual) {
            apagaArquivo(arquivo.filename);
            return res.status(404).json({ message: "Download não encontrado" });
          }

          await Download.update(dados, { where: { id } });
          // Só depois de gravar a nova versão, para não ficar sem arquivo se o
          // update falhar.
          apagaArquivo(atual.arquivo);
          await limpaOrfaos();

          return res.status(200).json({ message: "Nova versão publicada com sucesso" });
        }

        await Download.create({ ...dados, ativo: true });
        await limpaOrfaos();
        res.status(201).json({ message: "Download publicado com sucesso" });
      } catch (error) {
        console.error(error);
        apagaArquivo(arquivo.filename);
        res.status(500).json({ message: "Erro ao publicar o download" });
      }
    });
  },

  // Edita titulo/descricao/versao/ativo sem trocar o arquivo.
  async atualizar(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { titulo, descricao, versao, ativo } = req.body;

      const download = await Download.findByPk(id);
      if (!download) {
        return res.status(404).json({ message: "Download não encontrado" });
      }

      await Download.update({ titulo, descricao, versao, ativo }, { where: { id } });
      res.status(200).json({ message: "Download atualizado com sucesso" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao atualizar o download" });
    }
  },

  async remover(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const download: any = await Download.findByPk(id);
      if (!download) {
        return res.status(404).json({ message: "Download não encontrado" });
      }

      await Download.destroy({ where: { id } });
      apagaArquivo(download.arquivo);
      await limpaOrfaos();

      res.status(200).json({ message: "Download removido com sucesso" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao remover o download" });
    }
  },

  // O navegador precisa baixar o arquivo direto (streaming, retomada, barra de
  // progresso nativa) e nao tem como mandar o header de autenticacao nesse
  // caso. Entao o cliente autenticado pede um link curto e usa ele.
  async gerarLink(req: any, res: Response) {
    try {
      const { id } = req.params;
      const download: any = await Download.findByPk(id);

      if (!download || !download.ativo) {
        return res.status(404).json({ message: "Download não encontrado" });
      }

      const token = jwt.sign({ download_id: download.id, tenant_id: req.tenant_id }, SECRET_LINK, {
        expiresIn: VALIDADE_LINK,
      });

      // Só o token: quem monta a URL é o front, que sabe a baseURL da API.
      res.status(200).json({ token });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao gerar o link de download" });
    }
  },

  async baixar(req: Request, res: Response) {
    let conteudo: any;
    try {
      conteudo = jwt.verify(req.params.token, SECRET_LINK);
    } catch (error) {
      return res.status(401).json({ message: "Link expirado, tente novamente" });
    }

    try {
      const download: any = await Download.findByPk(conteudo.download_id);
      if (!download || !download.ativo) {
        return res.status(404).json({ message: "Download não encontrado" });
      }

      const caminho = path.join(DIRETORIO, path.basename(download.arquivo));
      if (!fs.existsSync(caminho)) {
        return res.status(404).json({ message: "Arquivo não encontrado no servidor" });
      }

      res.download(caminho, download.arquivo_original);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao baixar o arquivo" });
    }
  },
};
