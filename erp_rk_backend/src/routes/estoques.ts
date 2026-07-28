import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import EstoqueController from "../controller/EstoqueController";

const router = Router();

router.get("/estoques", verifyJWT, EstoqueController.getEstoques);
router.get("/estoques/:codigo", verifyJWT, EstoqueController.getEstoque);
router.post(
  "/estoques",
  verifyJWT,
  EstoqueController.updateOrInsertBatchEstoque
);
router.post(
  "/estoqueMovimentacao",
  verifyJWT,
  EstoqueController.insertEstoqueMovimentacao
);

export default router;
