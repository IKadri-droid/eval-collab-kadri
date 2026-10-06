#!/usr/bin/env bash
# Déploie la stack sur un hôte : ./scripts/deploy.sh srv-01
set -euo pipefail

HOST="${1:?usage: deploy.sh <srv-01|srv-02>}"
REMOTE_DIR="/opt/stack"

rsync -az --delete --exclude .git --exclude .env ./ "deploy@${HOST}:${REMOTE_DIR}/"
ssh "deploy@${HOST}" "cd ${REMOTE_DIR} && docker compose pull && docker compose up -d"
ssh "deploy@${HOST}" "cd ${REMOTE_DIR} && docker compose ps"
