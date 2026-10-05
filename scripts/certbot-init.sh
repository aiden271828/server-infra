#!/usr/bin/env bash
set -euo pipefail

project_dir=/opt/server-infra
secret_file=/etc/server-infra/gateway.env
cd "$project_dir"

if [[ ! -r "$secret_file" ]]; then
  echo "Missing $secret_file" >&2
  exit 1
fi

# This file is root-owned and contains only shell-style KEY=value entries.
set -a
# shellcheck disable=SC1090
source "$secret_file"
set +a

: "${CERTBOT_EMAIL:?Set CERTBOT_EMAIL in $secret_file}"
: "${CERTBOT_DOMAINS:?Set CERTBOT_DOMAINS in $secret_file}"

domains=()
IFS=',' read -r -a domain_list <<< "$CERTBOT_DOMAINS"
for domain in "${domain_list[@]}"; do
  domains+=("-d" "$domain")
done

gateway_stopped=0
restart_gateway() {
  if (( gateway_stopped )); then
    docker compose -f gateway/compose.yaml up -d
  fi
}
trap restart_gateway EXIT

docker compose -f gateway/compose.yaml down
gateway_stopped=1
docker compose -f gateway/compose.yaml --profile certbot run --rm --service-ports certbot \
  certonly --standalone --non-interactive --agree-tos --email "$CERTBOT_EMAIL" \
  --cert-name "${domain_list[0]}" "${domains[@]}"
docker compose -f gateway/compose.yaml up -d
gateway_stopped=0
