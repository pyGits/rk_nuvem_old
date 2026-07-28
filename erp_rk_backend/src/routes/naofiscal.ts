import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import NaoFiscalController from "../controller/NaoFiscalController";

const router = Router();

router.post("/naoFiscal", verifyJWT, NaoFiscalController.InserirNaoFiscal);
router.get("/reforcos", verifyJWT, NaoFiscalController.getReforcos);
router.get("/sangrias", verifyJWT, NaoFiscalController.getSangrias);

export default router;
