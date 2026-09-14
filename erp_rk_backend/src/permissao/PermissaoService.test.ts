import { podeAcessar, invalidarCache } from "./PermissaoService";
import PermissaoRepository from "./PermissaoRepository";

// As cinco decisoes que, se quebrarem, tiram cliente do ar: quatro sobre quem
// pode abrir a tela e uma sobre o token antigo/de carga continuar passando.
jest.mock("./PermissaoRepository", () => ({
  __esModule: true,
  default: { listarTelas: jest.fn() },
}));

const listarTelas = PermissaoRepository.listarTelas as jest.Mock;

describe("podeAcessar", () => {
  beforeEach(() => {
    listarTelas.mockReset();
    // O cache tem TTL de 30s e e global ao processo: sem limpar, o segundo
    // teste leria a resposta do primeiro.
    invalidarCache(1, "001");
  });

  it("libera o login principal sem nem consultar o banco", async () => {
    const req = { principal: true, tenant_id: 1, usuario_codigo: null };

    expect(await podeAcessar(req, "financeiro.contas_pagar")).toBe(true);
    expect(listarTelas).not.toHaveBeenCalled();
  });

  it("libera token sem usuario_codigo - token antigo e o do agente da loja", async () => {
    // E o que o verifyJWT monta quando o payload nao tem usuario_codigo.
    const req = { principal: true, tenant_id: 1, usuario_codigo: null };

    expect(await podeAcessar(req, "cadastro.produto")).toBe(true);
  });

  it("libera tudo para quem tem a marca de acesso total", async () => {
    listarTelas.mockResolvedValue(["*"]);
    const req = { principal: false, tenant_id: 1, usuario_codigo: "001" };

    expect(await podeAcessar(req, "financeiro.contas_receber")).toBe(true);
  });

  it("libera a tela marcada", async () => {
    listarTelas.mockResolvedValue(["cadastro.produto", "relatorio.caixa.painel"]);
    const req = { principal: false, tenant_id: 1, usuario_codigo: "001" };

    expect(await podeAcessar(req, "cadastro.produto")).toBe(true);
  });

  it("nega a tela que nao foi marcada", async () => {
    listarTelas.mockResolvedValue(["cadastro.produto"]);
    const req = { principal: false, tenant_id: 1, usuario_codigo: "001" };

    expect(await podeAcessar(req, "financeiro.contas_pagar")).toBe(false);
  });

  it("nega tudo para usuario sem nenhuma tela - o padrao de quem acabou de ser criado", async () => {
    listarTelas.mockResolvedValue([]);
    const req = { principal: false, tenant_id: 1, usuario_codigo: "001" };

    expect(await podeAcessar(req, "cadastro.produto")).toBe(false);
  });
});
