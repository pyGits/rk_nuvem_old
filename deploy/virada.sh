#!/bin/bash
# Virada: troca o backend do pm2 + nginx do host pelos containers.
#
# NAO toca no dediet-api, que continua rodando no pm2 exatamente como esta.
# O que muda para o dediet e apenas quem faz TLS/proxy na frente dele: passa a
# ser o nginx do container, com a mesma configuracao.
#
# Rode como root, na VPS:  bash /opt/rk_nuvem/virada.sh
# Para desfazer:           bash /opt/rk_nuvem/rollback.sh

set -euo pipefail
cd /opt/rk_nuvem

echo "==> 0/6 Conferindo se a imagem do front ja tem as 3 vhosts"
# A configuracao das 3 vhosts vai DENTRO da imagem. Se o push que a reconstroi
# ainda nao rodou, a imagem no GHCR e a antiga (uma vhost so, apontando para o
# DNS interno do Docker) e a virada derrubaria homologacao e dediet.
docker compose pull web >/dev/null 2>&1 || true
IMG=$(docker compose config --images 2>/dev/null | grep -- '-front' | head -1)
if ! docker run --rm --entrypoint sh "$IMG" -c 'grep -q DOMAIN_HOMOLOG /etc/nginx/templates/default.conf.template' 2>/dev/null; then
  echo
  echo "ABORTADO: a imagem $IMG ainda nao contem a configuracao das 3 vhosts."
  echo "Faca push na main, espere o workflow do GitHub terminar e rode de novo."
  exit 1
fi
echo "  ok, imagem atualizada"

echo "==> 1/6 Parando o backend do RK no pm2 (dediet-api continua no ar)"
pm2 stop index
pm2 save --force

echo "==> 2/6 Parando o nginx do host e tirando do boot"
systemctl stop nginx
systemctl disable nginx

echo "==> 3/6 Migrando a renovacao do certbot de plugin nginx para webroot"
# O plugin nginx do certbot depende do nginx do host, que acabou de sair. Com o
# container ocupando a 80, a renovacao passa a usar webroot — o mesmo metodo que
# o dediet ja usava. O container serve /.well-known/acme-challenge de /var/www/certbot.
mkdir -p /var/www/certbot
for d in rknuvem.com.br homologacao.rknuvem.com.br; do
  f=/etc/letsencrypt/renewal/$d.conf
  [ -f "$f" ] || { echo "  aviso: $f nao existe, pulando"; continue; }
  cp -n "$f" "$f.bak-pre-docker"
  sed -i 's|^authenticator = nginx|authenticator = webroot|' "$f"
  # "installer = nginx" faria o certbot tentar recarregar o nginx do host, que
  # acabou de sair — o renew inteiro falharia e o certificado venceria calado.
  sed -i 's|^installer = nginx|installer = None|' "$f"
  grep -q '^webroot_path' "$f" || sed -i '/^authenticator = webroot/a webroot_path = /var/www/certbot,' "$f"
  grep -q '^\[\[webroot_map\]\]' "$f" || printf '[[webroot_map]]\n%s = /var/www/certbot\n' "$d" >> "$f"
  echo "  $d -> webroot"
done

# Quem termina TLS agora e o nginx de dentro do container. Ele mantem o
# certificado carregado em memoria: sem este hook, renovar o arquivo em disco
# nao muda o que o site serve ate o proximo restart do container.
mkdir -p /etc/letsencrypt/renewal-hooks/deploy
cat > /etc/letsencrypt/renewal-hooks/deploy/10-reload-rk-web.sh <<'HOOK'
#!/bin/sh
docker kill -s HUP rk-web >/dev/null 2>&1 || \
  docker exec rk-web nginx -s reload >/dev/null 2>&1 || true
HOOK
chmod +x /etc/letsencrypt/renewal-hooks/deploy/10-reload-rk-web.sh

echo "==> 4/6 Ajustando o .env para producao"
# Portas reais e agendador SEFAZ ligado (o do pm2 acabou de parar, entao agora
# nao ha risco de duas instancias sincronizando a mesma loja).
sed -i 's|^HTTP_PORT=.*|HTTP_PORT=80|; s|^HTTPS_PORT=.*|HTTPS_PORT=443|; s|^SEFAZ_SCHEDULER_ENABLED=.*|SEFAZ_SCHEDULER_ENABLED=true|' .env
# A porta legada da API tem que voltar a 3000 em producao: e o endereco compilado
# no agente RKNuvem de cada loja.
if grep -q '^API_PORT=' .env; then
  sed -i 's|^API_PORT=.*|API_PORT=3000|' .env
else
  echo 'API_PORT=3000' >> .env
fi

echo "==> 5/6 Subindo os containers"
docker compose up -d

echo "==> 6/6 Verificando (aguardando o backend ficar pronto)"
sleep 15
falhou=0
verifica() {
  code=$(curl -sk -o /dev/null -w '%{http_code}' -m 20 "$1" || echo 000)
  printf '  %-58s %s' "$1" "$code"
  if [ "$code" = "$2" ]; then echo "  ok"; else echo "  ESPERADO $2"; falhou=1; fi
}
verifica https://rknuvem.com.br/                          200
verifica https://rknuvem.com.br/api/produtos              401
# Porta legada consumida pelo agente RKNuvem das lojas. Se esta cair, as lojas
# param de receber carga e de subir venda — e o agente so reclama no log local,
# nada aparece aqui. Verificar sempre.
verifica https://rknuvem.com.br:3000/api/produtos         401
verifica https://homologacao.rknuvem.com.br/              200
verifica https://vps47862.publiccloud.com.br/privacidade  200

echo
if [ "$falhou" = "0" ]; then
  echo "VIRADA CONCLUIDA. Confira tambem no navegador antes de considerar encerrado."
  echo "Renovacao do certificado: certbot renew --dry-run"
else
  echo "ALGO NAO RESPONDEU COMO ESPERADO."
  echo "Para voltar ao estado anterior:  bash /opt/rk_nuvem/rollback.sh"
  exit 1
fi
