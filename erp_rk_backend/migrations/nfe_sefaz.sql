-- Integração SEFAZ nativa no backend (banco principal `erp`).
-- Aplicar manualmente caso não use o knex migrate:
--   psql -U postgres -d erp -f migrations/nfe_sefaz.sql

-- Documentos capturados na Distribuição de DFe da SEFAZ.
CREATE TABLE IF NOT EXISTS nfe (
  id                 SERIAL PRIMARY KEY,
  tenant_id          INTEGER NOT NULL,
  chave              VARCHAR(44) NOT NULL,
  xml                TEXT,
  cnpjcpf            VARCHAR(20),
  cnpjcpf_fornecedor VARCHAR(20),
  nome_fornecedor    VARCHAR(255),
  nsu                VARCHAR(20),
  pendente           BOOLEAN NOT NULL DEFAULT TRUE,
  resumo             BOOLEAN NOT NULL DEFAULT FALSE,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_nfe_tenant_chave UNIQUE (tenant_id, chave)
);
CREATE INDEX IF NOT EXISTS idx_nfe_tenant_pendente ON nfe (tenant_id, pendente);

-- Colunas de SEFAZ em lojas (certificado/senha podem já existir).
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS certificado          TEXT;
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS senha                VARCHAR(255);
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS uf                   VARCHAR(2);
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS ultimo_nsu           VARCHAR(15) DEFAULT '000000000000000';
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS certificado_titular  VARCHAR(255);
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS certificado_validade TIMESTAMPTZ;
ALTER TABLE lojas ADD COLUMN IF NOT EXISTS ultimo_sync          TIMESTAMPTZ;
