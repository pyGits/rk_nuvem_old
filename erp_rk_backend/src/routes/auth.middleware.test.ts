import jwt from "jsonwebtoken";
import { verifyJWT } from "./auth.middleware";

// A identidade que o token passou a carregar, e - principalmente - o que
// acontece com os tokens que NAO a carregam: os de 24h emitidos antes desta
// mudanca e o de 30 anos que o agente das lojas tem gravado. Se este arquivo
// falhar, a carga e a subida de venda de todas as lojas param.

function requisicao(token: string) {
  return { headers: { "x-access-token": token }, params: {} } as any;
}

function resposta() {
  const res: any = { statusCode: 0 };
  res.status = (codigo: number) => {
    res.statusCode = codigo;
    return res;
  };
  res.end = () => res;
  return res;
}

describe("verifyJWT", () => {
  it("token de usuario web: identifica quem e e marca como nao principal", () => {
    const token = jwt.sign(
      { tenant_id: 7, principal: false, usuario_codigo: "002", usuario_user: "joao" },
      "B0RG55!"
    );
    const req = requisicao(token);
    const next = jest.fn();

    verifyJWT(req, resposta(), next);

    expect(next).toHaveBeenCalled();
    expect(req.tenant_id).toBe(7);
    expect(req.principal).toBe(false);
    expect(req.usuario_codigo).toBe("002");
    // v2/v3 leem tudo de req.params
    expect(req.params.tenant_id).toBe(7);
    expect(req.params.usuario_codigo).toBe("002");
    expect(req.params.principal).toBe(false);
  });

  it("token do login principal: principal, sem usuario", () => {
    const token = jwt.sign({ tenant_id: 7, principal: true }, "B0RG55!");
    const req = requisicao(token);
    const next = jest.fn();

    verifyJWT(req, resposta(), next);

    expect(next).toHaveBeenCalled();
    expect(req.principal).toBe(true);
    expect(req.usuario_codigo).toBeNull();
  });

  it("token antigo, so com tenant_id: vale como principal", () => {
    // Formato emitido antes desta feature. Continua chegando pelas 24h
    // seguintes ao deploy.
    const token = jwt.sign({ tenant_id: 7 }, "B0RG55!");
    const req = requisicao(token);
    const next = jest.fn();

    verifyJWT(req, resposta(), next);

    expect(next).toHaveBeenCalled();
    expect(req.tenant_id).toBe(7);
    expect(req.principal).toBe(true);
    expect(req.usuario_codigo).toBeNull();
  });

  it("token do agente da loja (loginCarga, 30 anos): vale como principal", () => {
    const token = jwt.sign({ tenant_id: 7 }, "B0RG55!", { expiresIn: "30y" });
    const req = requisicao(token);
    const next = jest.fn();

    verifyJWT(req, resposta(), next);

    expect(next).toHaveBeenCalled();
    expect(req.principal).toBe(true);
  });

  it("token invalido continua devolvendo 401", () => {
    const req = requisicao("nao-e-um-token");
    const res = resposta();
    const next = jest.fn();

    verifyJWT(req, res, next);

    expect(next).not.toHaveBeenCalled();
    expect(res.statusCode).toBe(401);
  });
});
