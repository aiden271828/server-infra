# server-infra Agent 指南

## 职责

本仓库只管理 Nginx、Certbot、TLS 续期和 Docker 网络 `edge`。应用代码、数据和密钥不放在本仓库。

## 规则

- 不得输出或提交密钥、私钥、证书、`.env`、数据库导出或 Docker 卷内容。
- 应用密钥仅存于服务器 `/etc/server-infra/`，由 `root` 持有，文件权限 `0600`。
- 只有网关能绑定公网 80、443；应用通过 `edge` 网络转发，不开放内部端口。
- HTTP 域名必须保留 `/.well-known/acme-challenge/`，否则 Let's Encrypt 证书无法签发或续期。
- 证书域名只维护在 `gateway/certbot-domains.txt`。

## 提交与文档

- 只向 `master` 推送；每次改动检查后提交并推送。
- 提交格式：`<type>: <中文说明>`；类型使用 `feat`、`fix`、`docs`、`chore` 或 `refactor`。
- 服务状态或跨仓库关联变化时，同步更新 [服务器清单](docs/服务器清单.md)。
