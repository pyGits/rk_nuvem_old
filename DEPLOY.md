# Deploy do RK Nuvem (Docker + GitHub Actions)

## Arquitetura

A VPS não hospeda só o RK. O nginx atende três vhosts, e o container assume as
três — o `dediet-api` continua rodando no pm2, intocado; só quem faz TLS e
proxy na frente dele muda.

```
Internet
   ├─ :80  → redirect 443 (exceto /.well-known/acme-challenge)
   └─ :443 → container "web" (nginx, network_mode: host)
               ├─ rknuvem.com.br              → dist do Vue (na imagem)
               │     └─ /api/                 → 127.0.0.1:3001 → container "backend"
               ├─ homologacao.rknuvem.com.br  → bind mount do disco do host
               └─ vps47862.publiccloud...     → 127.0.0.1:3333 (dediet-api, pm2)
                                                 /privacidade → bind mount

container "backend" → PostgreSQL do host (host.docker.internal:5432)
```

**Por que `network_mode: host`:** a API do dediet escuta apenas em
`127.0.0.1:3333`, e um container em rede bridge não alcança o loopback do host.
Como consequência, o backend do RK é publicado em `127.0.0.1:3001` e o nginx o
acessa por ali, em vez do DNS interno do Docker.

O PostgreSQL continua no host, fora do Docker. Os certificados digitais das
lojas ficam no banco (base64) — os volumes guardam só logos e XMLs de nota.

---

## Estado atual da VPS (preparado em 28/07/2026)

Já está feito:

- Docker CE 26.1.3 + compose v2.27.0 instalados e habilitados no boot
- usuário `deploy` (no grupo `docker`), com a chave do GitHub Actions autorizada
- `/opt/rk_nuvem` com `.env`, `docker-compose.yml`, `virada.sh` e `rollback.sh`
- volumes `rk-nuvem_backend_images` (com as 3 logos de produção já migradas) e
  `rk-nuvem_backend_uploads`
- stack validada de ponta a ponta em 8080/8443, com o ambiente de produção no ar

**Nada foi virado ainda.** Produção segue no pm2 + nginx do host.

> **Peculiaridade do servidor:** é CentOS Stream 8, cujos repositórios base
> (`baseos`, `appstream`, `extras`) saíram do ar — o vault dá timeout. Qualquer
> `dnf install` de pacote do sistema vai falhar. O Docker foi instalado
> baixando `container-selinux` e `libcgroup` do Rocky 8 (binário-compatível) como
> RPMs avulsos, em `/root/rpms-docker`. Nenhum repositório novo foi adicionado.

---

## A virada

Só pode rodar **depois** que um push na `main` tiver reconstruído a imagem do
front com a configuração das três vhosts. O script verifica isso sozinho e
aborta se a imagem estiver velha.

```bash
ssh root@rknuvem.com.br
bash /opt/rk_nuvem/virada.sh
```

O script: para o `index` no pm2 (o dediet-api **não** é tocado) → para e desabilita
o nginx do host → migra a renovação do certbot de plugin `nginx` para `webroot`
→ ajusta portas e liga o agendador SEFAZ no `.env` → sobe os containers →
verifica as quatro URLs.

Se algo não responder como esperado:

```bash
bash /opt/rk_nuvem/rollback.sh
```

Depois da virada, confira a renovação dos certificados:

```bash
certbot renew --dry-run
```

---

## Configurar o GitHub

Em **Settings → Secrets and variables → Actions**:

| Tipo     | Nome             | Valor                                    |
| -------- | ---------------- | ---------------------------------------- |
| Secret   | `VPS_HOST`       | `rknuvem.com.br`                         |
| Secret   | `VPS_USER`       | `deploy`                                 |
| Secret   | `VPS_SSH_KEY`    | chave privada gerada em `/root/rk_deploy` |
| Variable | `VPS_PATH`       | `/opt/rk_nuvem` (opcional, é o padrão)   |
| Variable | `RUN_MIGRATIONS` | `true` para rodar o knex a cada deploy   |

O push das imagens usa o `GITHUB_TOKEN` do próprio job — não é preciso PAT.

---

## Operação

```bash
cd /opt/rk_nuvem

docker compose ps
docker compose logs -f backend
docker compose logs -f web

# migrations
docker compose exec backend npx knex migrate:latest --knexfile knexfile.ts

# rollback para um commit anterior
sed -i 's|^IMAGE_TAG=.*|IMAGE_TAG=<sha-anterior>|' .env
docker compose pull && docker compose up -d

# backup dos volumes (logos e XMLs de NF-e)
for v in backend_images backend_uploads; do
  docker run --rm -v rk-nuvem_$v:/data -v $PWD:/backup alpine \
    tar czf /backup/$v-$(date +%F).tar.gz -C /data .
done
```

Os XMLs de nota em `backend_uploads` são referenciados pela tabela
`nota_fiscal_entrada_diretorio` — entram no backup junto com o banco, não depois.

Validar o build localmente antes de dar push:

```bash
docker compose -f docker-compose.yml -f docker-compose.build.yml build
```

Testar na VPS sem derrubar produção (portas 8080/8443):

```bash
sed -i 's|^HTTP_PORT=.*|HTTP_PORT=8080|; s|^HTTPS_PORT=.*|HTTPS_PORT=8443|' .env
docker compose up -d
```

> A VPS tem 1,7 GB de RAM e já opera com swap alto. Se um container falhar com
> `cannot allocate memory` ao criar a rede, rode `sync; echo 3 > /proc/sys/vm/drop_caches`
> e tente de novo. Depois da virada sobra folga, porque o pm2 e o nginx do host saem.

---

## Pendências de segurança

Nenhuma destas foi alterada — são decisões suas:

1. **As imagens no GHCR estão públicas.** Qualquer pessoa consegue
   `docker pull ghcr.io/pygits/rk_nuvem_old-backend:latest` e extrair todo o
   código-fonte do backend, sem autenticação. Torne os pacotes privados em
   **Package settings → Change visibility**. O deploy continua funcionando: o
   workflow autentica com o `GITHUB_TOKEN`.
2. **PostgreSQL aberto para a internet.** O `pg_hba.conf` tem
   `host all all 0.0.0.0/0 md5` e o firewalld libera `5432/tcp` na zona pública.
   Depois da virada, o banco só precisa aceitar a bridge do Docker — dá para
   fechar a 5432 no firewalld e restringir o `pg_hba` a `172.16.0.0/12`.
   As portas `3306`, `4000`, `4001`, `7777` e `8888` também estão abertas.
3. **Certificado A1 e XMLs de NF-e** ficaram publicamente acessíveis em
   `erp_rk_front/public/` enquanto estiveram lá. Já removidos, mas continuam no
   histórico do repositório `RK_Nuvem_Front` — considere o certificado
   comprometido e reemita.
4. **Segredo do JWT hardcoded** em `src/routes/auth.middleware.ts` (`"B0RG55!"`),
   e visível na imagem pública. Trocar invalida todos os tokens ativos.
5. **Senha do root da VPS** foi compartilhada em texto e usada nesta sessão —
   troque.
