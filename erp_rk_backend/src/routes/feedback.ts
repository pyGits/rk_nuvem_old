import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import FeedbackController from "../controller/FeedbackController";

const router = Router();

// Cliente logado
router.post("/feedback", verifyJWT, FeedbackController.enviar);

// Painel administrativo
router.get("/admin/feedbacks", verifyJWTADMIN, FeedbackController.listar);
router.put("/admin/feedbacks/:id/lido", verifyJWTADMIN, FeedbackController.marcarLido);

export default router;
