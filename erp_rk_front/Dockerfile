# syntax=docker/dockerfile:1
#
# Imagem do front: build do Vue + nginx que termina o TLS, serve o dist
# e faz proxy de /api para o backend.
# O contexto de build é a RAIZ do monorepo (rk_nuvem/).

# ---------------------------------------------------------------- build
FROM node:20-bookworm-slim AS builder

WORKDIR /app

COPY erp_rk_front/package.json erp_rk_front/package-lock.json ./
RUN npm ci

COPY erp_rk_front ./

# public/ é copiado inteiro para dist/ e fica acessível publicamente.
# Rede de segurança: certificado ou XML de NF-e que caia aqui nunca é publicado.
RUN rm -f public/*.pfx public/*.p12 public/*.xml

ENV NODE_OPTIONS=--max-old-space-size=4096
RUN npm run build

# -------------------------------------------------------------- runtime
FROM nginx:1.27-alpine AS runtime

RUN rm /etc/nginx/conf.d/default.conf

# Templates em /etc/nginx/templates são processados com envsubst no boot
# (é assim que ${DOMAIN} entra na configuração).
COPY erp_rk_front/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /app/dist /usr/share/nginx/html

# 3000 é a porta legada da API, consumida pelo agente RKNuvem das lojas.
EXPOSE 80 443 3000
