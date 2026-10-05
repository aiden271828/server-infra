# server-infra

服务器共享入口：Nginx 和 HTTPS 证书。

应用独立部署，由 Nginx 按域名转发。

- [服务器清单](docs/服务器清单.md)：服务器信息、服务状态和跨仓库关联
- [服务器初始化](docs/bootstrap.md)：首次部署步骤
- [New API](docs/new-api.md)：New API 的部署约定

网关更新由 GitHub Actions 自动部署。
