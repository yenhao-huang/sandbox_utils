# Codex Sandbox

Run Codex inside Docker with your repo mounted into `/workspace`.

Image:

```bash
docker pull yenhao123/codex-sandbox:latest
```

Before running the container directly, create the Codex state directories:

```bash
mkdir -p .codex-docker/home .codex-docker/state .codex-docker/runtime

cat > .codex-docker/runtime/passwd <<EOF2
root:x:0:0:root:/root:/bin/bash
codex:x:$(id -u):$(id -g):Codex User:/workspace/.codex-docker/home:/bin/bash
EOF2

cat > .codex-docker/runtime/group <<EOF2
root:x:0:
codex:x:$(id -g):
EOF2
```

Example:

```bash
docker run -dit \
  --name codex-sandbox \
  -u "$(id -u):$(id -g)" \
  -w /workspace \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --cap-add SYS_ADMIN \
  --cap-add NET_ADMIN \
  -e HOME=/workspace/.codex-docker/home \
  -e USER=codex \
  -e CODEX_HOME=/workspace/.codex-docker/state \
  -v "$PWD:/workspace" \
  -v "$PWD/.codex-docker:/workspace/.codex-docker" \
  -v "$PWD/.codex-docker/runtime/passwd:/etc/passwd:ro" \
  -v "$PWD/.codex-docker/runtime/group:/etc/group:ro" \
  yenhao123/codex-sandbox:latest \
  bash -lc "tail -f /dev/null"
```

Enter the container:

```bash
docker exec -it codex-sandbox bash
cd /workspace
codex
```

Docker sandbox plugin:

```bash
git clone git@github.com:yenhao-huang/sandbox_utils.git
cd sandbox_utils
mkdir -p ~/.docker/cli-plugins
ln -sf "$(pwd)/tools/docker-sandbox" ~/.docker/cli-plugins/docker-sandbox
chmod +x ~/.docker/cli-plugins/docker-sandbox

DOCKER_SANDBOX_IMAGE=yenhao123/codex-sandbox:latest \
DOCKER_SANDBOX_MOUNT_DIR=/tmp2/howard/codex-sandbox \
docker sandbox create codex /path/to/your/repo README.md src tests

docker sandbox run codex
```

To sync the whole repo, pass `.` explicitly:

```bash
docker sandbox create codex /path/to/your/repo .
```

Notes:

- if you use `docker sandbox`, clone `git@github.com:yenhao-huang/sandbox_utils.git` first and install the plugin from that repo
- `docker sandbox` stages files into a host mount directory before running
- the default staging root is `/tmp2/howard/codex-sandbox`
- set `DOCKER_SANDBOX_MOUNT_DIR=/your/path` to change it
- `docker sandbox create` requires explicit mount paths by default
- use `.` if you intentionally want to sync the whole repo
- you can choose which files or directories are synced into the sandbox
- the container mounts the staged workspace, not the original repo
- `docker sandbox run` re-syncs from the source repo before each run
- your repo or staged workspace is mounted at `/workspace`
- Codex state is stored in `.codex-docker`
- if you use plain `docker run`, create `.codex-docker/home`, `.codex-docker/state`, and the passwd/group mapping first
- this example keeps the container running; re-enter it with `docker exec -it codex-sandbox bash`
- the container is intended for isolated Codex execution on a mounted repo
