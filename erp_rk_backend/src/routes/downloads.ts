import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import DownloadController from "../controller/DownloadController";

const router = Router();

// Precisa vir antes de qualquer rota com parametro: o token do link ja carrega
// a autorizacao, por isso essa e a unica sem middleware.
router.get("/downloads/arquivo/:token", DownloadController.baixar);

// Clientes logados
router.get("/downloads", verifyJWT, DownloadController.listarPublicados);
router.post("/downloads/:id/link", verifyJWT, DownloadController.gerarLink);

// Painel administrativo
router.get("/admin/downloads", verifyJWTADMIN, DownloadController.listar);
router.post("/admin/downloads", verifyJWTADMIN, DownloadController.publicar);
router.put("/admin/downloads/:id", verifyJWTADMIN, DownloadController.atualizar);
router.delete("/admin/downloads/:id", verifyJWTADMIN, DownloadController.remover);

export default router;
