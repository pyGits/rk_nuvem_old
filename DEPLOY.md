# Deploy do RK Nuvem (Docker + GitHub Actions)

## Arquitetura

```
Internet
   │
   ├─ :80  → redirect para 443 (exceto /.well-known/acme-challenge)
   └─ :443 → container "web" (nginx, TLS Let's Encrypt)
               ├─ /      → dist do Vue (SPA, mode history)
               └─ /api/  → container "backend" (Node, HTTP interno na 3000)
                              │
                              └─ PostgreSQL do host (host.docker.internal:5432)
```

Dois containers apenas. O PostgreSQL continua rodando no host, fora do Docker.
Os certificados digitais das lojas ficam no banco (base64), então não há volume
para eles — o único volume é `backend_images`, com as logos dos tenants.

---

## 1. Criar o repositório único

Os projetos hoje estão em dois repositórios (`RK_Nuvem_Back` e `RK_Nuvem_Front`)
e `erp_rk_shared` não está versionado em lugar nenhum — por isso o build em CI
não funcionaria hoje. Na máquina local, a partir de `rk_nuvem/`:

```bash
# Remove os .git antigos (faça backup antes se quiser preservar o histórico)
rm -rf erp_rk_backend/.git erp_rk_front/.git

git init -b main
git add .
git commit -m "Monorepo: backend + front + shared com Docker e CI"
git remote add origin https://github.com/pyGits/rk_nuvem.git
git push -u origin main
```

> Se quiser preservar o histórico dos dois repositórios, use
> `git subtree add --prefix=erp_rk_backend <url> main` em vez de apagar os `.git`.

---

## 2. Preparar a VPS CentOS 8

### 2.1 Docker

CentOS 8 está em EOL — se o `dnf` reclamar dos mirrors, aponte os repositórios
base para o vault antes de continuar:

```bash
sudo sed -i 's/mirrorlist/#mirrorlist/g;s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo
```

```bash
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y --nobest --allowerasing docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
docker compose version
```

### 2.2 Usuário de deploy

```bash
sudo useradd -m -s /bin/bash deploy
sudo usermod -aG docker deploy
sudo mkdir -p /opt/rk_nuvem && sudo chown deploy:deploy /opt/rk_nuvem
```

Na sua máquina, gere a chave que o GitHub Actions vai usar:

```bash
ssh-keygen -t ed25519 -f rk_deploy -C "github-actions"
ssh-copy-id -i rk_deploy.pub deploy@SEU_HOST     # ou cole em ~deploy/.ssh/authorized_keys
```

O conteúdo de `rk_deploy` (a chave **privada**) vai para o secret `VPS_SSH_KEY`.

### 2.3 Firewall

```bash
sudo firewall-cmd --permanent --add-service=http --add-service=https
sudo firewall-cmd --reload
```

### 2.4 PostgreSQL do host acessível pelos containers

O backend chega no banco via `host.docker.internal`, que resolve para o gateway
da bridge do Docker (`172.17.0.1` por padrão).

```bash
# postgresql.conf
listen_addresses = 'localhost,172.17.0.1'
```

```bash
# pg_hba.conf — libere só a faixa das bridges do Docker
host    erp    postgres    172.16.0.0/12    scram-sha-256
```

```bash
sudo firewall-cmd --permanent --zone=trusted --add-source=172.16.0.0/12
sudo firewall-cmd --permanent --zone=trusted --add-port=5432/tcp
sudo firewall-cmd --reload
sudo systemctl restart postgresql
```

### 2.5 Certificado e diretório do ACME

O nginx do container lê `/etc/letsencrypt` do host em modo somente leitura e
serve o desafio ACME a partir de `/var/www/certbot`:

```bash
sudo mkdir -p /var/www/certbot
# Primeira emissão (com a porta 80 ainda livre, antes de subir os containers):
sudo certbot certonly --standalone -d rknuvem.com.br
```

Renovação depois que os containers estiverem no ar (a porta 80 fica ocupada):

```bash
sudo certbot renew --webroot -w /var/www/certbot \
  --deploy-hook "cd /opt/rk_nuvem && docker compose exec -T web nginx -s reload"
```

### 2.6 Arquivo de ambiente

```bash
scp .env.example deploy@SEU_HOST:/opt/rk_nuvem/.env
ssh deploy@SEU_HOST 'chmod 600 /opt/rk_nuvem/.env && vi /opt/rk_nuvem/.env'
```

Preencha `IMAGE_PREFIX`, `DOMAIN` e as credenciais do banco. Esse arquivo nunca
vai para o git — o workflow só atualiza a linha `IMAGE_TAG` dentro dele.

---

## 3. Configurar o GitHub

Em **Settings → Secrets and variables → Actions**:

| Tipo     | Nome           | Valor                                            |
| -------- | -------------- | ------------------------------------------------ |
| Secret   | `VPS_HOST`     | IP ou hostname da VPS                            |
| Secret   | `VPS_USER`     | `deploy`                                         |
| Secret   | `VPS_SSH_KEY`  | conteúdo da chave privada `rk_deploy`            |
| Secret   | `VPS_PORT`     | porta SSH, se não for 22 (opcional)              |
| Variable | `VPS_PATH`     | `/opt/rk_nuvem` (opcional, é o padrão)           |
| Variable | `RUN_MIGRATIONS` | `true` para rodar `knex migrate:latest` a cada deploy (opcional) |

O `environment: producao` no workflow permite exigir aprovação manual antes do
deploy — crie o environment em **Settings → Environments** se quiser esse gate,
ou remova a linha do workflow.

O push das imagens usa o `GITHUB_TOKEN` do próprio job, então não é preciso PAT.

---

## 4. Primeiro deploy

Faça push na `main`. O workflow:

1. builda `…-backend` e `…-front` em paralelo, com cache;
2. publica no GHCR com as tags `latest` e o SHA do commit;
3. copia o `docker-compose.yml` para a VPS;
4. grava `IMAGE_TAG=<sha>` no `.env` e roda `docker compose pull && up -d`.

Se preferir subir manualmente na primeira vez:

```bash
cd /opt/rk_nuvem
echo $GHCR_PAT | docker login ghcr.io -u SEU_USUARIO --password-stdin
docker compose pull && docker compose up -d
docker compose logs -f
```

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

Os XMLs de nota de entrada em `backend_uploads` são referenciados pela tabela
`nota_fiscal_entrada_diretorio` — entram no backup junto com o banco, não depois.

Testar o build localmente antes de dar push:

```bash
docker compose -f docker-compose.yml -f docker-compose.build.yml build
```

---

## Pendências de segurança encontradas

Não alterei nada disso — são decisões suas, mas vale resolver:

1. **Certificado A1 e XMLs de NF-e que estavam em `erp_rk_front/public/`** — já
   removidos do projeto. Tudo em `public/` é copiado para `dist/`, então esses
   arquivos ficaram publicamente acessíveis em produção enquanto estiveram lá.
   O Dockerfile do front agora apaga `*.pfx`/`*.p12`/`*.xml` antes do build e o
   `.gitignore` bloqueia novos, mas **eles continuam no histórico do repositório
   `RK_Nuvem_Front` — considere o certificado comprometido e revogue/reemita.**
   Se precisar dos XMLs como massa de teste, o lugar é `tests/fixtures/`.
2. **Segredo do JWT hardcoded** em `src/routes/auth.middleware.ts` (`"B0RG55!"`).
   Deveria vir de variável de ambiente. Trocar invalida todos os tokens ativos,
   então precisa ser feito em janela combinada.
3. **`.env` com a senha do banco de produção** está commitado no repositório do
   backend (linhas comentadas). Rotacione a senha ao migrar para o monorepo.
4. **CORS liberado para `*`** no `httpServer.ts`. Com o front na mesma origem
   agora, dá para restringir ao domínio.
