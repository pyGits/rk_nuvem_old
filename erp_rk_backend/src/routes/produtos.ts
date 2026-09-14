import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import ProdutoController from "../controller/ProdutoController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/produtosComPrecos", verifyJWT, ProdutoController.getProdutosWithPreco);
router.get("/produtos", verifyJWT, ProdutoController.getProdutos);
// Importante: registrar antes de "/produtos/:codigo" para não ser capturada por ela.
router.get("/produtos/verificar-codigo-barras", verifyJWT, ProdutoController.verificarCodigoBarras);
router.post("/produtos", verifyJWT, exigeAcesso("cadastro.produto", "compra.recebimento"), ProdutoController.insertProduto);
router.put("/produtos/:codigo", verifyJWT, exigeAcesso("cadastro.produto", "compra.recebimento"), ProdutoController.updateProduto);
router.get("/produtos/:codigo", verifyJWT, ProdutoController.getProduto);

export default router;
