# Codex Sandbox

Run Codex inside Docker through a staged sandbox workspace.

Image:

```bash
docker pull yenhao123/codex-sandbox:latest
```

The published image is expected to include `openssh-client`, `git`, and `ca-certificates`, so `git push` works for SSH remotes such as `git@github.com:...`.

Local image build:

```bash
cd /path/to/sandbox_utils
docker build -t codex-sandbox:local ./codex-sandbox
```

You can also build with an absolute path:

```bash
docker build -t codex-sandbox:local /path/to/sandbox_utils/codex-sandbox
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

Enter the container:

```bash
cd /workspace
codex
```

To sync the whole repo, pass `.` explicitly:

```bash
docker sandbox create codex /path/to/your/repo .
```

Notes:

- if you use `docker sandbox`, clone `git@github.com:yenhao-huang/sandbox_utils.git` first and install the plugin from that repo
- do not use plain `docker run -v "$PWD:/workspace"` for customer workflows
- `docker sandbox` stages files into a host mount directory before running
- the default staging root is `/tmp2/howard/codex-sandbox`
- set `DOCKER_SANDBOX_MOUNT_DIR=/your/path` to change it
- `docker sandbox create` requires explicit mount paths by default
- use `.` if you intentionally want to sync the whole repo
- you can choose which files or directories are synced into the sandbox
- the container mounts the staged workspace, not the original repo
- `docker sandbox run` re-syncs from the source repo before each run
- the staged workspace is mounted at `/workspace`
- Codex state is stored in the sandbox staging area
- the container is intended for isolated Codex execution on a mounted repo
