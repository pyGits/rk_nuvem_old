import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import TributacaoController from "../controller/TributacaoController";

const router = Router();

router.get(
  "/tributacao/:codigo",
  verifyJWT,
  TributacaoController.getTributacao
);
router.get("/tributacao", verifyJWT, TributacaoController.getTributacoes);
router.post("/tributacao", verifyJWT, TributacaoController.insertTributacao);
router.put(
  "/tributacao/:codigo",
  verifyJWT,
  TributacaoController.updateTributacao
);

export default router;
