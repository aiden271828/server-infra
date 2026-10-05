# New API

官方仓库位于 `/opt/new-api`。保留官方 `3000:3000` 映射；服务器安全组不开放 3000。

首次部署：

```bash
sudo /opt/server-infra/scripts/init-new-api-secrets.sh
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  up -d
```

密钥仅保存在 `/etc/server-infra/new-api.env`（`0600`）。服务加入共享网络 `edge`；确认 New API 正常后，再将 `ai.shenyuhan.online` 从 `503` 切换为反向代理。

验证：

```bash
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  ps
curl -fsS http://127.0.0.1:3000/api/status
```
