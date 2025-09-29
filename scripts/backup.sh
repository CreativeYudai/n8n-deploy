#!/bin/bash

# Script de backup para n8n
# Usage: ./scripts/backup.sh

set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="n8n_backup_${DATE}.tar.gz"

echo "📦 Iniciando backup de n8n..."

# Crear directorio de backups si no existe
mkdir -p $BACKUP_DIR

# Crear backup de los volúmenes de Docker
echo "💾 Creando backup de los datos..."

# Backup de n8n data
docker run --rm \
  -v n8n-deploy_n8n_data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine tar czf /backup/n8n_data_${DATE}.tar.gz -C /data .

# Backup de PostgreSQL
echo "🗄️ Creando backup de la base de datos..."
docker-compose exec -T postgres pg_dump -U n8n n8n > $BACKUP_DIR/postgres_${DATE}.sql

# Crear backup completo
echo "📁 Creando archivo de backup completo..."
tar czf $BACKUP_DIR/$BACKUP_FILE \
  docker-compose.yml \
  .env \
  nginx/ \
  postgres/ \
  n8n/ \
  $BACKUP_DIR/n8n_data_${DATE}.tar.gz \
  $BACKUP_DIR/postgres_${DATE}.sql

# Limpiar archivos temporales
rm $BACKUP_DIR/n8n_data_${DATE}.tar.gz
rm $BACKUP_DIR/postgres_${DATE}.sql

echo "✅ Backup completado: $BACKUP_DIR/$BACKUP_FILE"

# Limpiar backups antiguos (mantener solo los últimos 7)
echo "🧹 Limpiando backups antiguos..."
cd $BACKUP_DIR
ls -t n8n_backup_*.tar.gz | tail -n +8 | xargs -r rm

echo "✅ Backup proceso completado!"