#!/bin/bash

# Script para deploy local de n8n usando Docker Compose
# Usage: ./scripts/local-deploy.sh

set -e

echo "🚀 Iniciando deploy local de n8n..."

# Verificar que existe el archivo .env
if [ ! -f .env ]; then
    echo "❌ No se encontró el archivo .env"
    echo "Copia .env.example a .env y configura las variables:"
    echo "cp .env.example .env"
    exit 1
fi

# Verificar que Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado"
    exit 1
fi

# Verificar que Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado"
    exit 1
fi

# Crear directorios necesarios
echo "📁 Creando directorios necesarios..."
mkdir -p certbot/conf certbot/www

# Hacer ejecutable el script de inicialización de PostgreSQL
chmod +x postgres/init/init-n8n-db.sh

# Descargar las imágenes más recientes
echo "📦 Descargando imágenes de Docker..."
docker-compose pull

# Iniciar los servicios
echo "🏗️ Iniciando servicios..."
docker-compose up -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 30

# Verificar el estado de los servicios
echo "🔍 Verificando estado de los servicios..."
docker-compose ps

# Mostrar logs de n8n
echo "📋 Logs de n8n:"
docker-compose logs n8n | tail -20

echo ""
echo "✅ Deploy completado!"
echo "🌐 n8n está disponible en: http://localhost:5678"
echo "👤 Usuario: admin"
echo "🔑 Contraseña: (ver archivo .env)"
echo ""
echo "Para ver los logs: docker-compose logs -f"
echo "Para parar los servicios: docker-compose down"