#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Run this script with sudo." >&2
  exit 1
fi

secrets_dir=/etc/server-infra
secrets_file="$secrets_dir/new-api.env"

if [[ -e "$secrets_file" ]]; then
  echo "$secrets_file already exists; refusing to overwrite it." >&2
  exit 1
fi

edge_subnet=$(docker network inspect edge --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}')
if [[ -z "$edge_subnet" ]]; then
  echo "Could not determine the edge network subnet." >&2
  exit 1
fi

install -d -m 0700 "$secrets_dir"
umask 077
{
  printf 'POSTGRES_PASSWORD=%s\n' "$(openssl rand -hex 32)"
  printf 'REDIS_PASSWORD=%s\n' "$(openssl rand -hex 32)"
  printf 'SESSION_SECRET=%s\n' "$(openssl rand -hex 32)"
  printf 'EDGE_SUBNET=%s\n' "$edge_subnet"
} > "$secrets_file"
chmod 0600 "$secrets_file"

echo "Created $secrets_file with root-only permissions."
