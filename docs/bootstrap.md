# ECS 初始化

1. 重置 ECS 后安装 Docker Engine 和 Docker Compose，仅在安全组开放 80、443 与 SSH；不要开放应用内部端口。
2. 创建 `infra-deploy` 部署用户（加入 `docker` 组），将本仓库克隆到 `/opt/server-infra`。
3. 创建密钥目录：

   ```bash
   sudo install -d -m 700 -o root -g root /etc/server-infra
   ```

4. 确认 `gateway/certbot-domains.txt` 中的全部域名都已解析到该 ECS，再创建共享网络并签发证书：

   ```bash
   docker network create edge
   cd /opt/server-infra
   ./scripts/certbot-init.sh
   ```

5. GitHub 配置 `production` Environment（必须审批），并添加：

   | 类型 | 名称 |
   | --- | --- |
   | Secret | `ECS_DEPLOY_PRIVATE_KEY` |
   | Secret | `ECS_KNOWN_HOSTS` |
   | Variable | `ECS_HOST` |
   | Variable | `ECS_DEPLOY_USER` |

详细服务状态和域名请查看 [服务器清单](服务器清单.md)。
