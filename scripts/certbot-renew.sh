#!/usr/bin/env bash
set -euo pipefail

cd /opt/server-infra
docker compose -f gateway/compose.yaml --profile certbot run --rm certbot \
  renew --webroot -w /var/www/certbot
docker compose -f gateway/compose.yaml exec -T nginx nginx -s reload
