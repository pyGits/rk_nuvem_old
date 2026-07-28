-- Tabela de códigos de barras auxiliares do produto (1 produto -> N EANs).
-- Rode manualmente caso o projeto não possua runner de migrations configurado.

CREATE TABLE IF NOT EXISTS produto_codigos_barras (
  id            SERIAL PRIMARY KEY,
  tenant_id     INTEGER     NOT NULL,
  codigo_produto VARCHAR(6) NOT NULL,
  codigo_barras VARCHAR(14) NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Código de barras auxiliar único por tenant
CREATE UNIQUE INDEX IF NOT EXISTS uq_produto_codigos_barras_tenant_codigo
  ON produto_codigos_barras (tenant_id, codigo_barras);

-- Busca rápida dos auxiliares de um produto
CREATE INDEX IF NOT EXISTS idx_produto_codigos_barras_produto
  ON produto_codigos_barras (tenant_id, codigo_produto);
