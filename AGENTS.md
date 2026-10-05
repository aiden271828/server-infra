# server-infra Agent 指南

## 职责

本仓库只管理共享网关：Nginx、Certbot、TLS 续期和外部 Docker 网络 `edge`。应用代码、数据库、Redis、日志和业务密钥不归本仓库管理。

## 安全规则

- 禁止输出、提交或复制真实密钥、证书、私钥、`.env`、数据库导出和 Docker 卷内容。
- 应用的真实运行时密钥只保存在 ECS 的 `/etc/server-infra/`，由 `root` 持有，文件权限 `0600`。
- 证书域名不是密钥，统一维护在 `gateway/certbot-domains.txt`；修改后需重新签发证书。
- 只有网关可以绑定公网 80 和 443；应用经 `edge` 网络由 Nginx 转发，禁止直接向公网开放内部端口。
- 修改 `gateway/nginx/` 时，所有 HTTP 域名必须保留 `/.well-known/acme-challenge/` 路由；它供 Let's Encrypt 校验域名，删除会导致证书签发或续期失败。

## 工作约定

- `master` 是唯一部署分支；每次改动经必要检查后，使用约定式提交并推送。
- 提交格式为 `<type>: <中文说明>`，例如 `feat: 添加根域名静态页面`。
- 常用类型为 `feat`（功能）、`fix`（修复）、`docs`（文档）、`chore`（维护）和 `refactor`（重构）；类型保留英文，说明使用中文。
- GitHub Actions 通过 `production` Environment 部署，必须保留人工审批。
- ECS 检出目录为 `/opt/server-infra`；应用分别部署在各自目录。
- 服务清单是跨仓库关联的唯一入口，修改部署状态后同步更新 [docs/服务器清单.md](docs/服务器清单.md)。
