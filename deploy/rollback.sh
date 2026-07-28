#!/bin/bash
# Desfaz a virada: volta para o backend no pm2 + nginx do host.
#
# Os volumes do Docker (logos e XMLs) NAO sao apagados. O que tiver sido
# enviado enquanto os containers estavam no ar continua no volume — se algum
# tenant trocou a logo nesse periodo, copie de volta com:
#   docker run --rm --security-opt label=disable -v rk-nuvem_backend_images:/v \
#     -v /usr/share/nginx/backend/RK_Nuvem_Back/dist/erp_rk_backend/images:/dest alpine \
#     cp -a /v/. /dest/
#
# Rode como root, na VPS:  bash /opt/rk_nuvem/rollback.sh

set -euo pipefail
cd /opt/rk_nuvem

echo "==> 1/4 Derrubando os containers (volumes preservados)"
docker compose down

echo "==> 2/4 Restaurando a renovacao do certbot para o plugin nginx"
for d in rknuvem.com.br homologacao.rknuvem.com.br; do
  f=/etc/letsencrypt/renewal/$d.conf
  if [ -f "$f.bak-pre-docker" ]; then
    cp "$f.bak-pre-docker" "$f"
    echo "  $d restaurado"
  fi
done

echo "==> 3/4 Religando o nginx do host"
systemctl enable nginx
systemctl start nginx

echo "==> 4/4 Religando o backend do RK no pm2"
pm2 start index
pm2 save --force

sleep 5
echo
echo "Estado apos o rollback:"
for u in https://rknuvem.com.br/ https://rknuvem.com.br:3000/ https://homologacao.rknuvem.com.br/ https://vps47862.publiccloud.com.br/privacidade; do
  printf '  %-58s %s\n' "$u" "$(curl -sk -o /dev/null -w '%{http_code}' -m 20 "$u" || echo 000)"
done
