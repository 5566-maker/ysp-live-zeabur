# ysp-live on Zeabur

央视频全频道直播代理（v7.2 / 内部 7.3.0），纯 Python 标准库，单文件。

## 部署步骤

1. 把本目录推送到一个新的 GitHub 仓库（比如 `ysp-live-zeabur`）：
   ```bash
   cd ~/workspace/ysp-deploy/zeabur
   git init && git add . && git commit -m "ysp-live for zeabur"
   gh repo create ysp-live-zeabur --private --source=. --push
   ```
   （没有 gh 的话在 GitHub 网页上建空仓库再 push）

2. Zeabur 控制台 → New Service → Git → 选这个仓库。
   Zeabur 会自动识别 Dockerfile 并构建。

3. （可选但推荐）给服务加一个 Volume，挂载到 `/data`：
   设备注册信息（`device-state-rs.json`）和缓存会落在这里，
   不挂的话每次重启/重新部署都要重新走设备注册。

4. 部署完成后 Zeabur 会给一个 `https://xxx.zeabur.app` 域名：
   - 首页：`https://xxx.zeabur.app/`
   - 聚合订阅：`https://xxx.zeabur.app/all.m3u`（播放器一次导入全部频道）
   - 诊断页：`https://xxx.zeabur.app/diag`
   - 健康检查：`https://xxx.zeabur.app/health`

5. Region 建议选香港/台湾/日本，离大陆近延迟低。

## 重要提醒

- **机房 IP 可能过不了央视的设备注册**：原作者明确说"必须在家庭宽带下运行，
  设备注册在机房/公司网络会被央视拒绝"。Zeabur 是机房网络，
  设备协议频道（26 路高码率/真 4K）大概率注册失败——程序会自动回落到 1080p，
  不影响观看，只是没有 4K。如果哪天 1080p 的源也抽风，可以加启动参数
  `--no-4k`（改 Dockerfile 的 CMD）彻底跳过设备协议。
- 真 4K 频道走本地中继时会跑视频流量（约 15GB/小时），注意 Zeabur 的流量额度。
- 这是第三方来源的脚本，已做过基本检查（纯标准库、无可疑外联），
  但毕竟不是官方发行版，自用可以，别公开分享订阅链接。

## 本地测试

```bash
cd ~/workspace/ysp-deploy/zeabur
docker build -t ysp-live . && docker run -p 8767:8767 ysp-live
# 打开 http://localhost:8767/
```
