#!/usr/bin/env bash
set -euo pipefail

project_dir=/opt/server-infra
revision=${1:?Usage: deploy.sh <commit-sha>}
cd "$project_dir"

git fetch --quiet origin master
if [[ "$(git rev-parse origin/master)" != "$revision" ]]; then
  echo "Refusing to deploy a commit that is not origin/master." >&2
  exit 1
fi
git checkout --detach "$revision"

docker network inspect edge >/dev/null 2>&1 || docker network create edge >/dev/null
docker compose -f gateway/compose.yaml config -q
docker compose -f gateway/compose.yaml run --rm --no-deps nginx nginx -t
docker compose -f gateway/compose.yaml up -d --pull always --remove-orphans
docker compose -f gateway/compose.yaml exec -T nginx nginx -s reload
