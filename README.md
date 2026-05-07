
### 🎯 核心部分
- ✨ **项目特性**：轻量高效、高隐匿性、多架构支持等
- 📦 **项目结构**：清晰的文件目录说明
- 🛠️ **部署教程**：详细的准备工作步骤

### 🔄 版本更新指南（最新逻辑）

版本号统一放在 `versions.env` 中，Docker 构建时会：
1. 先尝试通过 `scripts/update-versions.sh` 获取 GitHub 上最新稳定版（获取失败不会中断构建）
2. 成功则用最新版本下载二进制；失败则回退使用 `versions.env` 中的版本号

#### **方式 1️⃣：更新 versions.env（推荐）** ⭐
```
1. 编辑 versions.env 里的版本号
2. git push 触发构建（或本地 docker build）
```

#### **方式 2️⃣：用脚本自动更新 versions.env**
脚本会拉取最新稳定版，拉取成功才会覆盖 `versions.env`（失败不改文件）。

在 WSL 或 Git Bash 中执行：
```
bash scripts/update-versions.sh
```

只查看将要更新到的版本号（不改文件）：
```
bash scripts/update-versions.sh --dry-run
```

#### **说明：为什么不在容器启动时更新**
镜像生成后版本就已经确定，运行阶段不再依赖外部网络拉版本，启动更稳定、更可控。

### 🚀 部署指南
- **Koyeb** 部署步骤
- **Render** 部署步骤  
- **个人 VPS** 部署步骤
- Docker Compose 方式

### 📱 客户端连接
- 详细的节点配置表格
- 快速分享链接格式

### ⚙️ 高级配置
- 修改 sing-box 配置
- 查看容器日志
- 进入容器调试

### 🔐 安全建议
- 保护 UUID 和 Token
- 定期更新版本
- TLS 加密建议

### 🐛 常见问题解答
- 连接超时问题排查
- 镜像拉取问题
- 自定义配置方法

---

## 📍 直接访问

👉 **https://github.com/dripai/drip-singbox**

所有文件已完整上传：
- ✅ Dockerfile
- ✅ .dockerignore
- ✅ .github/workflows/build.yml
- ✅ config.json
- ✅ start.sh
- ✅ versions.env
- ✅ scripts/update-versions.sh
- ✅ **README.md** ← 新增！

---

## 🎉 现在你有了完整的项目！

任何人访问你的项目都能：
1. 快速了解项目功能
2. 按照 README 逐步部署
3. 知道如何更新版本（不会忘记！）
4. 解决常见问题
5. 进行高级配置
