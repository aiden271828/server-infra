# New API

## 网络

`new-api-network` 的 MTU 固定为 `1450`，并是 New API 容器的默认出站网关。`edge` 网络只用于 Nginx 转发进入的请求，保持默认 MTU。这样可避免大图片响应在 Docker bridge 网络中传输不完整。

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

## 重启

普通重启不更新镜像或 Compose 配置：

```bash
cd /opt/new-api
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  restart
```

验证：

```bash
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  ps
curl -fsS http://127.0.0.1:3000/api/status
```

## 更新

不自动跟随官方更新。更新前先备份数据库，再检查官方 Compose 是否变更服务名或环境变量：

官方更新文档：[New API 系统更新指南](https://docs.newapi.ai/zh/docs/installation/config-maintenance/system-update)。

```bash
cd /opt/new-api
sudo mkdir -p -m 0700 /root/backups
sudo sh -c 'umask 077; docker exec postgres pg_dump -U root new-api > /root/backups/new-api-$(date +%F).sql'
sudo -u infra-deploy git fetch origin
sudo -u infra-deploy git diff --stat HEAD..origin/main -- docker-compose.yml
```

确认变更适配 `compose.production.yml` 后更新并验证：

```bash
sudo -u infra-deploy git pull --ff-only
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  config -q
sudo docker compose \
  --env-file /etc/server-infra/new-api.env \
  -f /opt/new-api/docker-compose.yml \
  -f /opt/server-infra/new-api/compose.production.yml \
  up -d --pull always
```
