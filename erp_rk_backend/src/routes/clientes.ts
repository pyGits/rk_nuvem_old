import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import ClienteController from "../controller/ClienteController";

const router = Router();

router.get("/clientes", verifyJWT, ClienteController.getClientes);
router.get("/clientes/:codigo", verifyJWT, ClienteController.getCliente);
router.put("/clientes/:codigo", verifyJWT, ClienteController.updateCliente);
router.post("/clientes", verifyJWT, ClienteController.insertCliente);

export default router;
