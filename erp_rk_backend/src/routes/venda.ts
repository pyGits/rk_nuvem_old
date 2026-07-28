import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import VendaController from "../controller/VendaController";

const router = Router();

router.post("/venda", verifyJWT, VendaController.InserirVenda);
router.post("/vendaItem", verifyJWT, VendaController.InserirVendaItem);
router.post("/vendaForma", verifyJWT, VendaController.InserirVendaForma);

export default router;
