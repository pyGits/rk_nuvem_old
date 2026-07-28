import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import FechamentoController from "../controller/FechamentoController";

const router = Router();
router.post("/fechamento", verifyJWT, FechamentoController.InserirFechamento);
router.post(
  "/fechamentoForma",
  verifyJWT,
  FechamentoController.InserirFechamentoForma
);

router.get("/fechamento", verifyJWT, FechamentoController.getFechamentos);
router.get(
  "/fechamento-formas",
  verifyJWT,
  FechamentoController.getFechamentoFormas
);
export default router;
