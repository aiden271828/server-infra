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

docker compose -f gateway/compose.yaml config -q
docker compose -f gateway/compose.yaml run --rm --no-deps nginx nginx -t
docker compose -f gateway/compose.yaml up -d --pull always --remove-orphans
