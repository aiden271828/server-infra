# New API

在 `/opt/new-api` 克隆官方仓库，按官方 Docker Compose 文档部署 New API、PostgreSQL 和 Redis。

- 保留官方 `3000:3000` 端口映射；服务器安全组只开放 22、80、443，不开放 3000。
- 将 `new-api` 服务加入外部 Docker 网络 `edge`。
- 将 `gateway/nginx/conf.d/10-sites.conf` 中 `ai.shenyuhan.online` 的 `return 503;` 改为反向代理 `new-api:3000`。
- 将 `POSTGRES_PASSWORD`、`SESSION_SECRET`、`CRYPTO_SECRET` 写入 `/etc/server-infra/new-api.env`，权限设为 `0600`。

启动时使用：

```bash
docker compose --env-file /etc/server-infra/new-api.env up -d
```
