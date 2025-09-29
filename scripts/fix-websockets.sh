#!/bin/bash

# Script para solucionar problemas de WebSocket (Invalid Origin)

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Cambiar al directorio de Ansible
cd "$(dirname "$0")/../ansible"

echo -e "${BLUE}🔧 Solucionando problemas de WebSocket...${NC}"

echo -e "${YELLOW}📝 Actualizando configuración de n8n (.env)...${NC}"
# Actualizar configuración .env
ansible n8n-prod -i inventory/hosts.yml -m template -a "src=templates/.env.j2 dest=/ubuntu/n8n/.env mode=0600" -b

echo -e "${YELLOW}🌐 Actualizando configuración de nginx...${NC}"
# Actualizar configuración nginx
ansible n8n-prod -i inventory/hosts.yml -m template -a "src=templates/nginx.conf.j2 dest=/ubuntu/n8n/nginx/nginx.conf mode=0644" -b
ansible n8n-prod -i inventory/hosts.yml -m template -a "src=templates/n8n.conf.j2 dest=/ubuntu/n8n/nginx/sites-available/n8n.conf mode=0644" -b

echo -e "${YELLOW}🔄 Reiniciando servicios para aplicar cambios...${NC}"
# Reiniciar nginx primero
ansible n8n-prod -i inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose restart nginx" -b

# Esperar un poco para que nginx esté listo
sleep 5

# Reiniciar n8n para que tome las nuevas variables de entorno
ansible n8n-prod -i inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose restart n8n" -b

echo -e "${YELLOW}📊 Verificando estado de los servicios...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "cd /ubuntu/n8n && docker-compose ps" -b

echo -e "${YELLOW}🔍 Verificando logs de n8n...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "docker logs \$(docker ps -q --filter name=n8n-n8n) --tail 10" -b

echo -e "${YELLOW}🔍 Verificando logs de nginx...${NC}"
ansible n8n-prod -i inventory/hosts.yml -m shell -a "docker logs \$(docker ps -q --filter name=n8n-nginx) --tail 10" -b

echo -e "${GREEN}✅ Configuración de WebSocket actualizada${NC}"
echo -e "${BLUE}🌐 Prueba accediendo a: https://n8n.yudaicreator.com${NC}"
echo -e "${BLUE}📝 Los WebSockets deberían funcionar correctamente ahora${NC}"