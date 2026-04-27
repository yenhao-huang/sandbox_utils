# claude-sandbox

Claude Code 隔離執行環境，基於 Docker。預設以 `bypassPermissions` 模式啟動，無需手動授權每個操作。

Docker Hub: [yenhao123/claude-sandbox](https://hub.docker.com/r/yenhao123/claude-sandbox)

---

## 首次安裝

### 1. Pull image

```bash
docker pull yenhao123/claude-sandbox:latest
docker tag yenhao123/claude-sandbox:latest claude-sandbox
```

### 2. 設定 run.sh

```bash
mkdir -p ~/.claude/docker
cp run.sh ~/.claude/docker/run.sh
chmod +x ~/.claude/docker/run.sh
```

### 3. 加 alias

```bash
echo 'alias claude-docker="$HOME/.claude/docker/run.sh"' >> ~/.bashrc
source ~/.bashrc
```

### 4. 複製 Claude 憑證

```bash
# 從舊機器複製，或登入後自動產生
scp oldmachine:~/.claude/.credentials.json ~/.claude/.credentials.json
chmod 600 ~/.claude/.credentials.json
```

---

## 日常使用

```bash
cd /your/project
claude-docker          # 進入 Claude Code（bypassPermissions 已內建）
```

Container 為 persistent（`--restart unless-stopped`），第一次啟動後常駐，之後每次 `claude-docker` 直接 `exec` 進去。

---

## 運作原理

- `run.sh` 啟動時把 `~/.claude/.credentials.json` 和 `settings.json` 複製到 `/tmp/claude-sandbox-runtime/`，掛載進 container
- Workspace 固定掛載 `/tmp2/howard` → `/workspace`，執行目錄自動對應
- Claude 以非 root user（host UID）執行，避免 `bypassPermissions` 的 root 限制
- `HOME` 設為 `/claude-home`，credentials 放在 `/claude-home/.claude/`

---

## 更新 image

```bash
# 修改 Dockerfile 後
cd ~/.claude/docker
docker build -t claude-sandbox .
docker tag claude-sandbox yenhao123/claude-sandbox:<new-version>
docker tag claude-sandbox yenhao123/claude-sandbox:latest
docker push yenhao123/claude-sandbox:<new-version>
docker push yenhao123/claude-sandbox:latest
```

---

## Tags

| Tag | 說明 |
|-----|------|
| `latest` | 最新版本 |
| `2.1.119-bypass` | Claude Code 2.1.119，內建 bypassPermissions |
