import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
// import NotaFiscalUseCase from "../infra/usecase/NotaFiscalUseCase";
import upload from "../infra/middleware/uploadMiddleware";

const router = Router();

// router.post("/compra/uploadXML", upload.single("arquivo"), verifyJWT, NotaFiscalUseCase.uploadXML);

export default router;
