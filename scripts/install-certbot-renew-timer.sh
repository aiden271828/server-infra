#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Run this script with sudo." >&2
  exit 1
fi

project_dir=/opt/server-infra
install -m 0644 "$project_dir/systemd/server-infra-certbot-renew.service" \
  /etc/systemd/system/server-infra-certbot-renew.service
install -m 0644 "$project_dir/systemd/server-infra-certbot-renew.timer" \
  /etc/systemd/system/server-infra-certbot-renew.timer
systemctl daemon-reload
systemctl enable --now server-infra-certbot-renew.timer
systemctl list-timers server-infra-certbot-renew.timer
