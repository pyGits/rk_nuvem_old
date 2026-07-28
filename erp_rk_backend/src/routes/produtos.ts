import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import ProdutoController from "../controller/ProdutoController";

const router = Router();

router.get("/produtosComPrecos", verifyJWT, ProdutoController.getProdutosWithPreco);
router.get("/produtos", verifyJWT, ProdutoController.getProdutos);
// Importante: registrar antes de "/produtos/:codigo" para não ser capturada por ela.
router.get("/produtos/verificar-codigo-barras", verifyJWT, ProdutoController.verificarCodigoBarras);
router.post("/produtos", verifyJWT, ProdutoController.insertProduto);
router.put("/produtos/:codigo", verifyJWT, ProdutoController.updateProduto);
router.get("/produtos/:codigo", verifyJWT, ProdutoController.getProduto);

export default router;
