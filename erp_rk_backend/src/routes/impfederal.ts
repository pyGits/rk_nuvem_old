import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import ImpFederaisController from "../controller/ImpFederaisController";

const router = Router();

router.get("/impfederal", verifyJWT, ImpFederaisController.getImpFederais);
router.post("/impfederal", verifyJWT, ImpFederaisController.insertImpFederal);
router.put(
  "/impfederal/:codigo",
  verifyJWT,
  ImpFederaisController.updateImpFederal
);
router.get(
  "/impfederal/:codigo",
  verifyJWT,
  ImpFederaisController.getImpFederal
);

export default router;
