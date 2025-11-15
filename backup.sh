#!/bin/bash

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "ERPNext Backup Script"
echo "===================="
echo ""

echo "Creating database backup..."
docker compose exec -T db mysqldump -u root -p${DB_ROOT_PASSWORD:-admin} --all-databases > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql"

echo "Creating sites backup..."
docker compose exec -T backend bench backup --with-files

echo "Copying backups to host..."
SITE_NAME=${SITE_NAME:-erp.localhost}
docker compose cp backend:/home/frappe/frappe-bench/sites/$SITE_NAME/private/backups/. "$BACKUP_DIR/"

echo ""
echo "Backup completed!"
echo "Backups saved to: $BACKUP_DIR"
echo ""
echo "Files:"
ls -lh "$BACKUP_DIR" | grep "$TIMESTAMP" || ls -lh "$BACKUP_DIR" | tail -5
