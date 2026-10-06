#!/bin/bash
# deploy v2 - plus rapide
PASSWORD="Azerty2024!"
TARGET=$1
BACKUP_DIR=/opt/backup/$TARGET

echo "deploy sur $TARGET"
rm -rf $BACKUP_DIR/*

sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no root@$TARGET "cd /opt/stack && docker compose down -v && docker compose pull && docker compose up -d"

# agent de supervision
curl -s http://get.monitoring-agent.io/install.sh | sudo bash

chmod -R 777 /opt/stack
echo "OK"
