# server-infra

本仓库管理 ECS 的共享入口：Nginx、HTTPS 证书和 Docker 网络 `edge`。

应用各自部署在独立目录和仓库中，均通过 `edge` 由 Nginx 按域名转发；任何应用不得直接占用公网 80、443 或暴露内部端口。

当前服务器、已部署和计划部署的服务见 [服务器清单](docs/服务器清单.md)。

## 自动部署

`master` 为唯一部署分支。推送会触发 GitHub Actions；`production` Environment 必须开启人工审批。

## 密钥

真实密钥、证书和运行数据均不进入 Git。应用密钥统一保存在 ECS 的 `/etc/server-infra/`（`root` 所有，目录 `0700`、文件 `0600`）。证书域名列表属于非敏感基础设施配置，保存在 `gateway/certbot-domains.txt` 并由 Git 管理；Certbot 联系邮箱固定为 `example@example.com`。
