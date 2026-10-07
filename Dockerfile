FROM python:3.12-slim

WORKDIR /app

# v7.2 (内部版本 7.3.0)：单文件，纯标准库，无第三方依赖
COPY ysp-live.py ./ysp-live.py

# 设备注册 / 缓存状态落盘目录（Zeabur 上挂 volume 到 /data 实现持久化）
ENV YSP_DATA_DIR=/data

EXPOSE 8767

# Zeabur 会注入 PORT 环境变量；本地运行时默认 8767
CMD ["sh", "-c", "python3 ysp-live.py ${PORT:-8767}"]
