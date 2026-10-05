#!/usr/bin/env bash
set -euo pipefail

project_dir=/opt/server-infra
secret_file=/etc/server-infra/gateway.env
domains_file="$project_dir/gateway/certbot-domains.txt"
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
if [[ ! -r "$domains_file" ]]; then
  echo "Missing $domains_file" >&2
  exit 1
fi

domain_list=()
while IFS= read -r domain || [[ -n "$domain" ]]; do
  domain=${domain%$'\r'}
  [[ -z "$domain" || "$domain" == \#* ]] && continue
  domain_list+=("$domain")
done < "$domains_file"

if (( ${#domain_list[@]} == 0 )); then
  echo "No domains found in $domains_file" >&2
  exit 1
fi

certbot_domains=()
for domain in "${domain_list[@]}"; do
  certbot_domains+=("-d" "$domain")
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
  --cert-name "${domain_list[0]}" "${certbot_domains[@]}"
docker compose -f gateway/compose.yaml up -d
gateway_stopped=0
