# 职责

本仓库只管理 Nginx、Certbot、TLS 续期和 Docker 网络 `edge`。应用代码、数据和密钥不放在本仓库。

# 规则

- 不得输出或提交密钥、私钥、证书、`.env`、数据库导出或 Docker 卷内容。
- 应用密钥仅存于服务器 `/etc/server-infra/`，由 `root` 持有，文件权限 `0600`。
- 只有网关能对公网提供 80、443；应用通过 `edge` 网络转发，安全组不得开放 New API 的 3000 端口。
- HTTP 域名必须保留 `/.well-known/acme-challenge/`，否则 Let's Encrypt 证书无法签发或续期。
- 证书域名只维护在 `gateway/certbot-domains.txt`。

# 提交与文档

- 所有提交必须符合 Conventional Commits，格式为 `<type>: <中文说明>`。
- 示例：`feat: 添加根域名静态页面`、`fix: 修复证书续期配置`、`docs: 更新服务器清单`。
- 服务状态或跨仓库关联变化时，同步更新 [服务器清单](docs/服务器清单.md)。
