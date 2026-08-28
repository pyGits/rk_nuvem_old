import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import IbptController from "../controller/IbptController";

const router = Router();

// Clientes logados: consulta do modal de NCM.
router.get("/ibpt/ncm", verifyJWT, IbptController.buscar);
router.get("/ibpt/ncm/:codigo", verifyJWT, IbptController.porCodigo);

// Painel administrativo: a tabela e global, entao quem sobe e o admin.
router.get("/admin/ibpt", verifyJWTADMIN, IbptController.situacao);
router.post("/admin/ibpt", verifyJWTADMIN, IbptController.publicar);
// Conferencia cruzada: produtos de todos os clientes com NCM fora da tabela.
router.get("/admin/ibpt/produtos-sem-ncm", verifyJWTADMIN, IbptController.produtosSemNcm);

export default router;
