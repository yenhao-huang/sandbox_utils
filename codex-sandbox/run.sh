docker run --rm -it \
    -w /workspace \
    -e HOME=/home/howard \
    -v /tmp2/howard/side_project/RAG:/workspace \
    -v /tmp2/howard/side_project/sandbox_utils/.runtime/ssh:/home/howard/.ssh:ro \
    codex-sandbox:local \
    bash
