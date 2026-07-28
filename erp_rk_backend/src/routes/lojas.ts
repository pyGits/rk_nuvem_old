import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import LojaController from "../controller/LojaController";

const router = Router();

router.get("/lojas", verifyJWT, LojaController.getLojas);
router.get("/lojas/:codigo", verifyJWT, LojaController.getLoja);
router.put("/lojas/:codigo", verifyJWT, LojaController.updateLoja);
router.post("/lojas", verifyJWT, LojaController.insertLoja);

export default router;
