import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import VendaController from "../controller/VendaController";

const router = Router();

router.post("/venda", verifyJWT, VendaController.InserirVenda);
router.post("/vendaItem", verifyJWT, VendaController.InserirVendaItem);
router.post("/vendaForma", verifyJWT, VendaController.InserirVendaForma);

// Subida em lote do agente. As rotas unitarias acima continuam existindo para
// as instalacoes que ainda rodam a versao anterior do Sync.
router.post("/venda/lote", verifyJWT, VendaController.InserirVendaLote);
router.post("/vendaItem/lote", verifyJWT, VendaController.InserirVendaItemLote);
router.post("/vendaForma/lote", verifyJWT, VendaController.InserirVendaFormaLote);

export default router;
