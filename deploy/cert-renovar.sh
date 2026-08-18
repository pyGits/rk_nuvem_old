#!/bin/bash
# Renovacao dos certificados Let's Encrypt DEPOIS da virada para Docker.
#
# O que quebrou: com o nginx do host desabilitado, quem termina TLS e o nginx
# de dentro do container "rk-web". O certbot do host continua dono dos
# certificados em /etc/letsencrypt (montado :ro no container), mas:
#
#   1. se o renewal .conf ainda tiver "installer = nginx", o certbot tenta
#      recarregar o nginx do host — que nao existe mais — e o renew falha
#      inteiro, sem renovar nada;
#   2. mesmo renovando o arquivo em disco, o nginx do container mantem o
#      certificado antigo em memoria ate receber um reload. Sem deploy-hook,
#      o site continua servindo o certificado vencido.
#
# Este script conserta os dois pontos, instala o hook de reload de forma
# permanente, garante o agendamento e renova agora.
#
# Rode como root, na VPS:  bash /opt/rk_nuvem/cert-renovar.sh
#   e, se o certificado ja tiver vencido:  FORCE=1 bash /opt/rk_nuvem/cert-renovar.sh

set -euo pipefail

COMPOSE_DIR=${COMPOSE_DIR:-/opt/rk_nuvem}
CONTAINER=${CONTAINER:-rk-web}
DOMINIOS="rknuvem.com.br homologacao.rknuvem.com.br"

echo "==> 1/5 Ajustando os renewal .conf para webroot sem installer"
mkdir -p /var/www/certbot
for d in $DOMINIOS; do
  f=/etc/letsencrypt/renewal/$d.conf
  [ -f "$f" ] || { echo "  aviso: $f nao existe, pulando"; continue; }
  cp -n "$f" "$f.bak-pre-docker" 2>/dev/null || true

  sed -i 's|^authenticator = nginx|authenticator = webroot|' "$f"
  # "installer = nginx" faria o certbot tentar mexer no nginx do host.
  sed -i 's|^installer = nginx|installer = None|' "$f"
  grep -q '^installer' "$f" || sed -i '/^authenticator = webroot/a installer = None' "$f"
  grep -q '^webroot_path' "$f" || sed -i '/^authenticator = webroot/a webroot_path = /var/www/certbot,' "$f"
  grep -q '^\[\[webroot_map\]\]' "$f" || printf '[[webroot_map]]\n%s = /var/www/certbot\n' "$d" >> "$f"

  printf '  %-30s authenticator=%s installer=%s\n' "$d" \
    "$(sed -n 's|^authenticator = ||p' "$f")" \
    "$(sed -n 's|^installer = ||p' "$f")"
done

echo "==> 2/5 Instalando o deploy-hook que recarrega o nginx do container"
# Roda depois de QUALQUER certificado renovado, inclusive o do dediet, que ja
# usava webroot proprio (/var/www/dediet-acme) e tambem e servido pelo container.
mkdir -p /etc/letsencrypt/renewal-hooks/deploy
cat > /etc/letsencrypt/renewal-hooks/deploy/10-reload-rk-web.sh <<'HOOK'
#!/bin/sh
# SIGHUP no PID 1 do container = reload do nginx, sem derrubar conexao.
docker kill -s HUP rk-web >/dev/null 2>&1 || \
  docker exec rk-web nginx -s reload >/dev/null 2>&1 || true
HOOK
chmod +x /etc/letsencrypt/renewal-hooks/deploy/10-reload-rk-web.sh
echo "  /etc/letsencrypt/renewal-hooks/deploy/10-reload-rk-web.sh"

echo "==> 3/5 Conferindo o agendamento da renovacao"
if systemctl list-timers --all 2>/dev/null | grep -q certbot; then
  systemctl enable --now certbot-renew.timer 2>/dev/null || \
    systemctl enable --now certbot.timer 2>/dev/null || true
  echo "  timer do systemd ativo"
elif ls /etc/cron.d/certbot /etc/cron.daily/certbot >/dev/null 2>&1; then
  echo "  cron do certbot ja instalado"
else
  cat > /etc/cron.d/certbot-rk <<'CRON'
# Renovacao dos certificados do RK Nuvem. Duas vezes ao dia e o recomendado
# pelo Let's Encrypt; o certbot so age quando faltam menos de 30 dias.
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
17 3,15 * * * root certbot renew -q
CRON
  echo "  criado /etc/cron.d/certbot-rk (nao havia timer nem cron)"
fi

echo "==> 4/5 Renovando agora"
# Por padrao o certbot so emite quando faltam menos de 30 dias — rodar este
# script de novo nao gasta cota. Use FORCE=1 apenas quando o certificado ja
# venceu ou esta comprovadamente errado; o Let's Encrypt permite 5 emissoes
# por dominio por semana.
if [ "${FORCE:-0}" = "1" ]; then
  certbot renew --force-renewal --no-random-sleep-on-renew
else
  certbot renew --no-random-sleep-on-renew
fi

echo "==> 5/5 Verificando o que esta sendo servido"
falhou=0
mostra() {
  fim=$(echo | openssl s_client -connect "$1" -servername "$2" 2>/dev/null \
        | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
  printf '  %-48s %s\n' "$1" "${fim:-SEM RESPOSTA}"
  [ -n "$fim" ] || falhou=1
}
mostra rknuvem.com.br:443                    rknuvem.com.br
# Porta legada do agente RKNuvem das lojas: usa o mesmo certificado e tambem
# so pega o novo depois do reload.
mostra rknuvem.com.br:3000                   rknuvem.com.br
mostra homologacao.rknuvem.com.br:443        homologacao.rknuvem.com.br
mostra vps47862.publiccloud.com.br:443       vps47862.publiccloud.com.br

echo
if [ "$falhou" = "0" ]; then
  echo "OK. As datas acima devem estar ~90 dias a frente."
  echo "Teste o ciclo completo depois:  certbot renew --dry-run"
else
  echo "Alguma porta nao respondeu — confira 'docker compose ps' em $COMPOSE_DIR."
  exit 1
fi
