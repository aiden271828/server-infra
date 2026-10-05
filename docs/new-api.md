# New API

在 `/opt/new-api` 克隆官方仓库，并使用其 Docker Compose 配置部署 New API、PostgreSQL 和 Redis。

- 保留官方的 `3000:3000` 端口映射；服务器安全组只开放 22、80、443，不开放 3000。
- Nginx 通过 `ai.shenyuhan.online` 转发到 `host.docker.internal:3000`。
- 将 `POSTGRES_PASSWORD`、`SESSION_SECRET`、`CRYPTO_SECRET` 写入 `/etc/server-infra/new-api.env`，权限设为 `0600`。

启动时使用：

```bash
docker compose --env-file /etc/server-infra/new-api.env up -d
```
