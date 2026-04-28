# Codex Sandbox

Run Codex inside Docker with `ssh`, `git`, and a named `howard` user.

Steps:

```bash
git clone git@github.com:yenhao-huang/sandbox_utils.git
cd sandbox_utils/codex-sandbox

# 建立 image
docker build \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  --build-arg USERNAME=howard \
  -t codex-sandbox:local \
  .

# 測試
docker run --rm codex-sandbox:local whoami
docker run --rm codex-sandbox:local ssh -V
docker run --rm codex-sandbox:local codex --version

# 建立永久 container
docker run -d \
    --name codex-sandbox \
    -w /workspace \
    -e HOME=/home/howard \
    -v /tmp2/howard/side_project/RAG:/workspace \
    -v /tmp2/howard/side_project/sandbox_utils/.runtime/ssh:/home/howard/.ssh:ro \
    codex-sandbox:local \
    sleep infinity

# 進入 container
docker exec -it codex-sandbox bash
```