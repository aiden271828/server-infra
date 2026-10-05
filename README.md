# server-infra

服务器共享入口：Nginx、HTTPS 证书和 Docker 网络 `edge`。

应用独立部署，通过 `edge` 由 Nginx 按域名转发，不直接开放应用端口。

- [服务器清单](docs/服务器清单.md)：服务器信息、服务状态和跨仓库关联
- [服务器初始化](docs/bootstrap.md)：首次部署步骤
- [New API](docs/new-api.md)：New API 的部署约定

`master` 是唯一部署分支。推送触发 GitHub Actions，`production` Environment 必须保留人工审批。
