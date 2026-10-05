# 服务器初始化

1. 安装 Docker Engine、Docker Compose 与 Git；创建 1 GiB Swap。
2. 创建部署用户并授予 Docker 权限：

   ```bash
   adduser --disabled-password --gecos "" infra-deploy
   usermod -aG docker infra-deploy
   ```

3. 使用只读 Deploy Key，将本仓库克隆到 `/opt/server-infra`，所有者为 `infra-deploy`。
4. 确认 `gateway/certbot-domains.txt` 的所有域名都解析到本服务器，签发证书：

   ```bash
   cd /opt/server-infra
   ./scripts/certbot-init.sh
   ```

5. 在 GitHub 创建 `production` Environment，并配置：

   | 类型 | 名称 |
   | --- | --- |
   | Secret | `SERVER_DEPLOY_PRIVATE_KEY` |
   | Secret | `SERVER_KNOWN_HOSTS` |
   | Variable | `SERVER_HOST` |
   | Variable | `SERVER_DEPLOY_USER` |

## 已验证的问题处理

### 系统更新中断或出现 SSH 配置选择

默认执行 `apt update && apt upgrade -y`。若出现 OpenSSH 配置选择且服务器通过密钥登录，选择“保留当前本地配置”；若更新显示中断，依次执行：

```bash
dpkg --configure -a
apt -f install -y
apt update
apt upgrade -y
```

### Docker Hub 拉取超时

默认直连 Docker Hub。若 `docker pull` 出现 `i/o timeout`，配置 DaoCloud 镜像源后重试：

```bash
tee /etc/docker/daemon.json >/dev/null <<'EOF'
{"registry-mirrors":["https://docker.m.daocloud.io"]}
EOF
systemctl restart docker
```

### Certbot 注册邮箱

`example@example.com` 不能用于 Let’s Encrypt 注册。当前不设置邮箱，脚本会使用 `--register-unsafely-without-email`；如需接收证书到期通知，再改用真实邮箱。

### 网关返回 444

默认使用最新仓库执行证书初始化，脚本完成后会启动正式站点配置。若访问时连接被直接断开，且 Nginx 日志显示 `444`，说明仍在使用仅供签证书的 `00-bootstrap.conf`；拉取最新仓库后重新启动网关。
