# Codex Sandbox

Run Codex inside Docker with `ssh`, `git`, and a named `howard` user.

Steps:

```bash
git clone git@github.com:yenhao-huang/sandbox_utils.git
cd /tmp2/howard/side_project/sandbox_utils/codex-sandbox

docker build \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  --build-arg USERNAME=howard \
  -t codex-sandbox:local \
  .

docker run --rm codex-sandbox:local whoami
docker run --rm codex-sandbox:local ssh -V
docker run --rm codex-sandbox:local codex --version
```

Prepare local SSH files under `sandbox_utils`:

```bash
cd /tmp2/howard/side_project/sandbox_utils
mkdir -p .runtime/ssh
cp ~/.ssh/id_ed25519 .runtime/ssh/
cp ~/.ssh/id_ed25519.pub .runtime/ssh/
cp ~/.ssh/known_hosts .runtime/ssh/
chmod 700 .runtime/ssh
chmod 600 .runtime/ssh/id_ed25519
```

Run against the local `RAG` repo:

```bash
docker run --rm -it \
  -w /workspace \
  -e HOME=/home/howard \
  -v /tmp2/howard/side_project/RAG:/workspace \
  -v /tmp2/howard/side_project/sandbox_utils/.runtime/ssh:/home/howard/.ssh:ro \
  codex-sandbox:local \
  bash
```

Inside the container:

```bash
whoami
ssh -T git@github.com
git remote -v
git push origin feat/add_evalgen_pipeline
```

Notes:

- do not commit private keys into git
- keep SSH files only under the local `.runtime/ssh` directory
- if `known_hosts` is missing, run `ssh -T git@github.com` on the host once first
