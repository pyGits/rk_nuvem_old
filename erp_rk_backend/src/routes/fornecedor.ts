import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import FornecedorController from "../controller/FornecedorController";

const router = Router();

router.get("/fornecedors", verifyJWT, FornecedorController.getFornecedors);
router.get("/fornecedors/:codigo", verifyJWT, FornecedorController.getFornecedor);
router.put("/fornecedors/:codigo", verifyJWT, FornecedorController.updateFornecedor);
router.post("/fornecedors", verifyJWT, FornecedorController.insertFornecedor);

export default router;
