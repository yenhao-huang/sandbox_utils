FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-client \
    git \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @openai/codex@0.125.0

WORKDIR /workspace
