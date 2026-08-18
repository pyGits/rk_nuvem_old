import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import NotificacaoController from "../controller/NotificacaoController";

const router = Router();

router.get("/notificacoes", verifyJWT, NotificacaoController.listar);

export default router;
