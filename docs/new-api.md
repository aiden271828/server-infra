# New API

- 上游仓库：`https://github.com/QuantumNous/new-api.git`
- ECS 目录：`/opt/new-api`
- 公网域名：`ai.shenyuhan.online`
- 容器地址：`new-api:3000`（仅 `edge` Docker 网络内可访问）

使用上游 Docker Compose 部署，保留 PostgreSQL 和 Redis；删除 `3000:3000` 端口映射，并让 `new-api` 服务加入外部网络 `edge`。

真实值写入 `/etc/server-infra/new-api.env`（权限 `0600`），Compose 通过 `--env-file /etc/server-infra/new-api.env` 启动。至少配置互不相同的 `POSTGRES_PASSWORD`、`SESSION_SECRET` 和 `CRYPTO_SECRET`。

首次管理员初始化通过 `https://ai.shenyuhan.online` 完成，禁止为此临时公开 3000 端口。
