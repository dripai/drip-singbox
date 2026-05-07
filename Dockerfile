FROM alpine:latest AS builder

ARG SING_BOX_VERSION=1.10.1
ARG CLOUDFLARED_VERSION=2024.4.1
ARG TARGETARCH=amd64

# 设置版本变量，方便以后维护
# sing-box 版本: https://github.com/SagerNet/sing-box/releases
# cloudflared 版本: https://github.com/cloudflare/cloudflared/releases

RUN apk add --no-cache ca-certificates wget tar

WORKDIR /tmp

# 1. 下载并安装 sing-box (对应你的 web-app)
# 根据架构动态下载对应的版本
RUN wget -q https://github.com/SagerNet/sing-box/releases/download/v${SING_BOX_VERSION}/sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar -xzf sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}.tar.gz && \
    mv sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}/sing-box /tmp/sing-box && \
    rm -rf sing-box-${SING_BOX_VERSION}-linux-${TARGETARCH}* && \
    chmod +x /tmp/sing-box

# 2. 下载并安装 cloudflared (对应你的 sys-service)
RUN wget -q -O /tmp/cloudflared https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-${TARGETARCH} && \
    chmod +x /tmp/cloudflared

# =====================================================
# 最终镜像阶段：精简构建产物
# =====================================================
FROM alpine:latest

RUN apk add --no-cache ca-certificates bash

WORKDIR /app

# 从 builder 阶段复制二进制文件
COPY --from=builder /tmp/sing-box /usr/local/bin/sing-box
COPY --from=builder /tmp/cloudflared /usr/local/bin/cloudflared

# 3. 复制你仓库里现有的配置文件 (config.json, start.sh 等)
# 注意：.dockerignore 会排除敏感文件
COPY config.json .
COPY start.sh .

# 4. 赋予执行权限
RUN chmod +x /usr/local/bin/sing-box && \
    chmod +x /usr/local/bin/cloudflared && \
    chmod +x start.sh

# 声明端口
EXPOSE 8080

# 启动脚本
CMD ["./start.sh"]