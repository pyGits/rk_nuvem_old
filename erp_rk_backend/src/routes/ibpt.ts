import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import IbptController from "../controller/IbptController";

const router = Router();

// Handler async que lanca em rota montada direto no Router (e nao pelo
// httpServer.register) vira unhandled rejection - e no Node atual isso DERRUBA
// o processo, que e o 502 que aparece no navegador em vez do erro real.
// Este adaptador garante que a falha volte como resposta.
const seguro = (handler: any) => async (req: any, res: any) => {
  try {
    await handler(req, res);
  } catch (error: any) {
    res.status(422).json({ message: error?.message || "Erro ao processar a requisição." });
  }
};

// Clientes logados: consulta do modal de NCM.
router.get("/ibpt/ncm", verifyJWT, seguro(IbptController.buscar));
// Antes da rota com parametro: senao "sugestao" seria lido como codigo.
router.get("/ibpt/ncm/sugestao", verifyJWT, seguro(IbptController.sugerir));
router.get("/ibpt/ncm/:codigo", verifyJWT, seguro(IbptController.porCodigo));

// Painel administrativo: a tabela e global, entao quem sobe e o admin.
router.get("/admin/ibpt", verifyJWTADMIN, seguro(IbptController.situacao));
router.post("/admin/ibpt", verifyJWTADMIN, IbptController.publicar);
// Conferencia cruzada: produtos de todos os clientes com NCM fora da tabela.
router.get("/admin/ibpt/produtos-sem-ncm", verifyJWTADMIN, seguro(IbptController.produtosSemNcm));
// Grava os NCM sugeridos nos produtos que o operador escolheu.
router.post("/admin/ibpt/normalizar", verifyJWTADMIN, seguro(IbptController.normalizar));
// Correcao do zero a esquerda: deterministica, roda sobre todos os produtos.
// O GET so conta; o POST aplica.
router.get("/admin/ibpt/zero-esquerda", verifyJWTADMIN, seguro(IbptController.zeroAEsquerda));
router.post("/admin/ibpt/zero-esquerda", verifyJWTADMIN, seguro(IbptController.zeroAEsquerda));
// Busca por IA: consulta o modelo e GRAVA. A conferencia depois so le o cache.
router.post("/admin/ibpt/buscar-ia", verifyJWTADMIN, seguro(IbptController.buscarComIA));
// Mutirao: roda no servidor ate terminar, com retry, e a tela pode ser fechada.
router.post("/admin/ibpt/mutirao-ia", verifyJWTADMIN, seguro(IbptController.iniciarMutiraoIA));
router.get("/admin/ibpt/mutirao-ia", verifyJWTADMIN, seguro(IbptController.situacaoMutiraoIA));
router.delete("/admin/ibpt/mutirao-ia", verifyJWTADMIN, seguro(IbptController.pararMutiraoIA));
// Busca pela SEFAZ: consulta o Cadastro Centralizado de GTIN pelo codigo de
// barras. E consulta exata, nao palpite - tem precedencia sobre a IA.
router.post("/admin/ibpt/sefaz", verifyJWTADMIN, seguro(IbptController.iniciarMutiraoSefaz));
router.get("/admin/ibpt/sefaz", verifyJWTADMIN, seguro(IbptController.situacaoMutiraoSefaz));
router.delete("/admin/ibpt/sefaz", verifyJWTADMIN, seguro(IbptController.pararMutiraoSefaz));
// Normalizacao em massa: roda no servidor sobre a base inteira, com progresso.
router.post("/admin/ibpt/normalizar-tudo", verifyJWTADMIN, seguro(IbptController.iniciarNormalizacao));
router.get("/admin/ibpt/normalizar-tudo", verifyJWTADMIN, seguro(IbptController.situacaoNormalizacao));
router.delete("/admin/ibpt/normalizar-tudo", verifyJWTADMIN, seguro(IbptController.pararNormalizacao));
// Teste real de um GTIN: valida a integracao antes da varredura inteira.
router.post("/admin/ibpt/sefaz/teste", verifyJWTADMIN, seguro(IbptController.testarSefaz));
// Certificado A1 do painel. O upload nao passa pelo `seguro` porque o proprio
// handler ja trata o erro - multer precisa responder o dele.
router.get("/admin/ibpt/certificado", verifyJWTADMIN, seguro(IbptController.situacaoCertificado));
router.post("/admin/ibpt/certificado", verifyJWTADMIN, IbptController.enviarCertificado);
router.delete("/admin/ibpt/certificado", verifyJWTADMIN, seguro(IbptController.removerCertificado));

export default router;
