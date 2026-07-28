# syntax=docker/dockerfile:1
#
# Imagem do backend. O contexto de build é a RAIZ do monorepo (rk_nuvem/),
# porque o backend importa código de ../erp_rk_shared por caminho relativo.

# ---------------------------------------------------------------- build
FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY erp_rk_backend/package.json erp_rk_backend/package-lock.json ./erp_rk_backend/
RUN cd erp_rk_backend && npm ci

COPY erp_rk_shared ./erp_rk_shared
COPY erp_rk_backend ./erp_rk_backend

# tsconfig usa noEmitOnError=false, então erro de tipo não aborta o build
# (mesmo comportamento do ts-node em desenvolvimento).
# A saída fica em erp_rk_backend/dist/erp_rk_backend e dist/erp_rk_shared.
RUN cd erp_rk_backend && npx tsc

# -------------------------------------------------------------- runtime
FROM node:20-bookworm-slim AS runtime

# xmllint é exigido pelo node-sped-nfe para validar os XMLs contra os XSDs da SEFAZ
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libxml2-utils openssl ca-certificates tzdata \
 && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production \
    TZ=America/Sao_Paulo \
    SERVER_PORT=3000 \
    XMLLINT_PATH=/usr/bin/xmllint

WORKDIR /app/erp_rk_backend

COPY --from=builder /app/erp_rk_shared /app/erp_rk_shared
# Traz node_modules, dist e os fontes .ts (necessários para rodar as migrations
# do knex, que continuam sendo executadas via ts-node).
COPY --from=builder /app/erp_rk_backend ./

RUN mkdir -p images/logo uploads && chown -R node:node /app

USER node
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=25s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:'+(process.env.SERVER_PORT||3000)+'/').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "dist/erp_rk_backend/index.js"]
