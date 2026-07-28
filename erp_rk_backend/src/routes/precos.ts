import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import PrecoController from "../controller/PrecoController";

const router = Router();

router.get("/precos", verifyJWT, PrecoController.getPrecos);
router.get("/precos/:codigo", verifyJWT, PrecoController.getPreco);
router.post("/precos", verifyJWT, PrecoController.updateOrInsertBatchPreco);

export default router;
