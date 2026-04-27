# claude-sandbox

Claude Code running in an isolated Docker container with `bypassPermissions` mode built in — no manual permission prompts.

Docker Hub: [yenhao123/claude-sandbox](https://hub.docker.com/r/yenhao123/claude-sandbox)

---

## First-time Setup

### 1. Clone this repo

```bash
git clone https://github.com/yenhao-huang/sandbox_utils.git
cd sandbox_utils/claude-sandbox
```

### 2. Pull image

```bash
docker pull yenhao123/claude-sandbox:latest
docker tag yenhao123/claude-sandbox:latest claude-sandbox
```

### 3. Install run.sh

```bash
mkdir -p ~/.claude/docker
cp run.sh ~/.claude/docker/run.sh
chmod +x ~/.claude/docker/run.sh
```

### 4. Add alias

```bash
echo 'alias claude-docker="$HOME/.claude/docker/run.sh"' >> ~/.bashrc
source ~/.bashrc
```

### 5. Copy Claude credentials

```bash
# Copy from another machine, or log in to generate
scp oldmachine:~/.claude/.credentials.json ~/.claude/.credentials.json
chmod 600 ~/.claude/.credentials.json
```

---

## Daily Usage

```bash
cd /your/project
claude-docker
```

The container runs persistently (`--restart unless-stopped`). The first call starts it; subsequent calls `exec` directly into the running container.

---

## How It Works

- `run.sh` copies `~/.claude/.credentials.json` and `settings.json` to `/tmp/claude-sandbox-runtime/` and mounts them into the container
- `/tmp2/howard` is mounted as `/workspace`; the working directory inside the container mirrors your current path on the host
- Claude runs as the host user (non-root) via `--user $(id -u):$(id -g)` so `bypassPermissions` is not blocked
- `HOME` is set to `/claude-home` where credentials are placed at `/claude-home/.claude/`

---

## Upgrading the Image

```bash
# After editing the Dockerfile
cd ~/.claude/docker
docker build -t claude-sandbox .
docker tag claude-sandbox yenhao123/claude-sandbox:<new-version>
docker tag claude-sandbox yenhao123/claude-sandbox:latest
docker push yenhao123/claude-sandbox:<new-version>
docker push yenhao123/claude-sandbox:latest
```

---

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest build |
| `2.1.119-bypass` | Claude Code 2.1.119 with bypassPermissions entrypoint |
