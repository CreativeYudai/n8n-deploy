#!/bin/bash

# Script para generar claves de seguridad para n8n
# Usage: ./scripts/generate-keys.sh

echo "Generando claves de seguridad para n8n..."

# Generar clave de encriptación de 32 caracteres
ENCRYPTION_KEY=$(openssl rand -hex 16)
echo "N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY"

# Generar JWT secret
JWT_SECRET=$(openssl rand -hex 32)
echo "N8N_JWT_SECRET=$JWT_SECRET"

# Generar contraseña segura para la base de datos
DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
echo "POSTGRES_PASSWORD=$DB_PASSWORD"

# Generar contraseña para el usuario de n8n
N8N_PASSWORD=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-12)
echo "N8N_BASIC_AUTH_PASSWORD=$N8N_PASSWORD"

echo ""
echo "Copia estas claves en tus archivos .env (desarrollo) y ansible/inventory/hosts.yml (producción)"
echo "¡Guarda estas claves de forma segura!"